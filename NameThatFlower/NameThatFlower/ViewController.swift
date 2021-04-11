//
//  ViewController.swift
//  NameThatFlower
// 
//  by mrcos-mrtinelli
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    
    let imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        descriptionLabel.text = ""
        
        let cameraBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        
        navigationItem.rightBarButtonItem = cameraBarButton
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
    }
    
    //MARK: Navigation Bar
    @objc func cameraTapped() {
        
        present(imagePicker, animated: true)
    
    }
    
    //MARK: Process Method
    func process(image: CIImage) {
       
        // create model
        guard let model = try? VNCoreMLModel(for: FlowerClassification(configuration: MLModelConfiguration()).model) else {
            fatalError("Unable to process CIImage")
        }
        
        // create a request
        let request = VNCoreMLRequest(model: model) { (req, err) in
            
            guard let results = req.results as? [VNClassificationObservation] else {
                fatalError("error getting results")
            }
            
            if let firstResult = results.first {
                let flowerName = firstResult.identifier.capitalized
                self.title = flowerName
                
                self.getWikiFor(flowerName)
            }
        }
        
        // create a handler
        let handler = VNImageRequestHandler(ciImage: image)
        
        // perform request
        do {
            
            try handler.perform([request])
            
        } catch  {
            fatalError("could not perform request")
        }
        
    }
    
    func getWikiFor(_ flowerName: String) {
        let wikipediaURl = "https://en.wikipedia.org/w/api.php"
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "pithumbsize": "500",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "indexpageids" : "",
            "redirects" : "1",
        ]
        
        Alamofire.request(wikipediaURl, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let pageid = json["query"]["pageids"][0].stringValue
                let title = json["query"]["pages"][pageid]["title"].stringValue
                let extract = json["query"]["pages"][pageid]["extract"].stringValue
                let flowerImage = json["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                
                self.titleLabel.text = title
                self.descriptionLabel.text = extract
                self.imageView.sd_setImage(with: URL(string: flowerImage))
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("unable to get image")
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("unable to convert UIImage to CIIage")
        }
        
        imageView.image = image
        
        imagePicker.dismiss(animated: true)
        
        process(image: ciImage)
    }
}

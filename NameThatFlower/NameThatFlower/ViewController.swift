//
//  ViewController.swift
//  NameThatFlower
// 
//  by mrcos-mrtinelli
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.title = firstResult.identifier.capitalized
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

//
//  ViewController.swift
//  SeeFood
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
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        
        navigationItem.rightBarButtonItem = cameraButton
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    @objc func cameraTapped() {
        
        present(imagePicker, animated: true)
        
    }
    
    func process(image: CIImage) {
            
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            print("error processing CIImage")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("unable to request results")
                return
            }
            
            if let result = results.first {
                if result.identifier.contains("hotdog") {
                    self.title = "Hot Dog!"
                } else {
                    self.title = "Not Hotdog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
            
        } catch {
            print("error! \(error)")
        }
        
    }

}

//MARK: - Delegates
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("no image edited")
            return
        }
        
        guard let ciimage = CIImage(image: image) else {
            print("unable to conver image to ciimage")
            return
        }
        
        imageView.image = image
        
        process(image: ciimage)
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        
        navigationItem.rightBarButtonItem = cameraButton
        
        
    }
    
    @objc func cameraTapped() {
        
    }

}

//MARK: - Delegates
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

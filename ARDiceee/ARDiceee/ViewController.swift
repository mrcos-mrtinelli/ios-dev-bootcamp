//
//  ViewController.swift
//  ARDiceee
// 
//  by mrcos-mrtinelli
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // create cube using SceneKit's methods
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.001)
        
        let sphere = SCNSphere(radius: 0.1)
        
        // add some color to the cube
//        let cubeMaterial = SCNMaterial()
        
        let sphereMaterial = SCNMaterial()
        
//        cubeMaterial.diffuse.contents = UIColor.red
        
        sphereMaterial.diffuse.contents = UIImage(named: "art.scnassets/Mars.jpg")
        
//        cube.materials = [cubeMaterial]
        
        sphere.materials = [sphereMaterial]
        
//        let cubeNode = SCNNode()
        
        let sphereNode = SCNNode()
        
//        cubeNode.position = SCNVector3(0, 0.1, -0.5)
        
//        cubeNode.geometry = cube
        
        sphereNode.position = SCNVector3(0.2, 0.1, -0.5)
        
        sphereNode.geometry = sphere
        
//        sceneView.scene.rootNode.addChildNode(cubeNode)
        
        sceneView.scene.rootNode.addChildNode(sphereNode)

        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}

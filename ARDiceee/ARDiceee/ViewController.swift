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
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // create cube using SceneKit's methods
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.001)
//        let sphere = SCNSphere(radius: 0.1)
        // add some color to the cube
//        let cubeMaterial = SCNMaterial()
//        let sphereMaterial = SCNMaterial()
//        cubeMaterial.diffuse.contents = UIColor.red
//        sphereMaterial.diffuse.contents = UIImage(named: "art.scnassets/Mars.jpg")
//        cube.materials = [cubeMaterial]
//        sphere.materials = [sphereMaterial]
//        let cubeNode = SCNNode()
//        let sphereNode = SCNNode()
//        cubeNode.position = SCNVector3(0, 0.1, -0.5)
//        cubeNode.geometry = cube
//        sphereNode.position = SCNVector3(0.2, 0.1, -0.5)
//        sphereNode.geometry = sphere
//        sceneView.scene.rootNode.addChildNode(cubeNode)
//        sceneView.scene.rootNode.addChildNode(sphereNode)

        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
        
        // Set the scene to the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }

}

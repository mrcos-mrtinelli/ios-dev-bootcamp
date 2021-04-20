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
    
    private var diceArray = [SCNNode]()
    
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
    
    // touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlane)
            
            if let hitResult = results.first {
                
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    let wtColumns = hitResult.worldTransform.columns.3
                    
                    diceNode.position = SCNVector3(
                        x: wtColumns.x,
                        y: wtColumns.y + diceNode.boundingSphere.radius,
                        z: wtColumns.z
                    )
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    diceArray.append(diceNode)
                    
                }
            }
        }
    }
    
    @IBAction func rollDice(_ sender: Any) {
        rollAll()
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    func rollAll() {
        
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice)
            }
        }
        
    }
    
    func roll(_ diceNode: SCNNode) {
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let action = SCNAction.rotateBy(x: CGFloat(randomX * 5), y: CGFloat(0), z: CGFloat(randomZ * 5), duration: 0.5)
        
        diceNode.runAction(action)
        
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

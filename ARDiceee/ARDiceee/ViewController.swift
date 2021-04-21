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
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlane)
            
            if let hitResult = results.first {
                addDice(at: hitResult)
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func rollDice(_ sender: Any) {
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: Any) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    //MARK: - Dice Methods
    
    func addDice(at hitResult: ARHitTestResult) {
        
        guard let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn") else { return }
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            let worldTransCols = hitResult.worldTransform.columns.3
            
            diceNode.position = SCNVector3(
                x: worldTransCols.x,
                y: worldTransCols.y + diceNode.boundingSphere.radius,
                z: worldTransCols.z
            )
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            diceArray.append(diceNode)
            
        }
        
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
    
    //MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlane(withAnchor: planeAnchor)
        
        node.addChildNode(planeNode)

    }

    //MARK: - Planed Rendering Methods
    func createPlane(withAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
        
        return planeNode
        
    }
    
}

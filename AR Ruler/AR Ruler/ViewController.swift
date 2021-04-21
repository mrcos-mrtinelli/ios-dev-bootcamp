//
//  ViewController.swift
//  AR Ruler
// 
//  by mrcos-mrtinelli
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodesArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
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
    
    // MARK: - Touch Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            guard let hitResult = hitTestResults.first else { return }
            
            addDot(at: hitResult)
            
        }
    }
    
    // MARK: - Methods
    
    func addDot(at location: ARHitTestResult) {
        let dot = SCNSphere()
        let dotMaterials = SCNMaterial()
        let dotNode = SCNNode()
        
        dot.radius = 0.005
        
        dotNode.geometry = dot
        dotNode.position = SCNVector3(
            x: Float(location.worldTransform.columns.3.x),
            y: Float(location.worldTransform.columns.3.y),
            z: Float(location.worldTransform.columns.3.z)
        )
        
        if dotNodesArray.count == 2 {
            for dot in dotNodesArray {
                dot.removeFromParentNode()
            }
            
            dotNodesArray.removeAll()
        }
        
        if dotNodesArray.count == 0 {
            dotMaterials.diffuse.contents = UIColor.green
        } else if dotNodesArray.count == 1 {
            dotMaterials.diffuse.contents = UIColor.red
        }
        
        dot.materials = [dotMaterials]
        
        dotNodesArray.append(dotNode)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        if dotNodesArray.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        guard let start = dotNodesArray.first,
              let end = dotNodesArray.last else { return }
        
        let a = end.position.x - start.position.x,
            b = end.position.y - start.position.y,
            c = end.position.z - end.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print("current distance = \(abs(distance))")
        
    }
}

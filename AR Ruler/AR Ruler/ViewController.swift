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
    
    func addDot(at location: ARHitTestResult) {
        let dot = SCNSphere()
        let dotMaterials = SCNMaterial()
        let dotNode = SCNNode()
        
        dotMaterials.diffuse.contents = UIColor.red
        
        dot.radius = 0.005
        dot.materials = [dotMaterials]
        
        dotNode.geometry = dot
        dotNode.position = SCNVector3(
            x: Float(location.worldTransform.columns.3.x),
            y: Float(location.worldTransform.columns.3.y),
            z: Float(location.worldTransform.columns.3.z)
        )
        
        sceneView.scene.rootNode.addChildNode(dotNode)
    }

    // MARK: - ARSCNViewDelegate
}

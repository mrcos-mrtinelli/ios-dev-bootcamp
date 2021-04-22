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
        let distanceInInches = (distance * 100) / 2.54
        let formattedInches = String(format: "%.2f in", distanceInInches)
        
        showMeasurement(text: formattedInches, at: start.position)
        
    }
    
    func showMeasurement(text: String, at location: SCNVector3) {
        
        let textGeo = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeo.firstMaterial?.diffuse.contents = UIColor.red
        
        let textNode = SCNNode(geometry: textGeo)
        
        textNode.name = "textNode"
        textNode.position = SCNVector3(x: location.x, y: location.y + 0.01, z: location.z)
        textNode.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.005)
        
        sceneView.scene.rootNode.childNodes
            .filter({ $0.name == "textNode" })
            .forEach({ $0.removeFromParentNode() })
        
        sceneView.scene.rootNode.addChildNode(textNode)
                
    }
}

//
//  ViewController.swift
//  AR Image Finder
//
//  Created by Denis Bystruev on 20/09/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
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
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources",
            bundle: nil
        )!
        
        configuration.trackingImages = referenceImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        switch anchor {
        case let imageAncor as ARImageAnchor:
            nodeAdded(node, for: imageAncor)
        case let planeAncor as ARPlaneAnchor:
            nodeAdded(node, for: planeAncor)
        default:
            print("Нашли якорь, но это не плоскость и не картинка")
        }
    }
    
    func nodeAdded(_ node: SCNNode, for imageAncor: ARImageAnchor) {
        let referenceImage = imageAncor.referenceImage
        
        let plane = SCNPlane(
            width: referenceImage.physicalSize.width,
            height: referenceImage.physicalSize.height
        )
        
        plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.25
        planeNode.eulerAngles.x = -Float.pi / 2
        
        node.addChildNode(planeNode)
    }
    
    func nodeAdded(_ node: SCNNode, for planAncor: ARPlaneAnchor) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

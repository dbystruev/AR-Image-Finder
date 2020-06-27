//
//  ViewController.swift
//  AR Image Finder
//
//  Created by Denis Bystruev on 20/09/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//
//  See WWDC 2018 Session 602: What's New in ARKit 2
//  https://developer.apple.com/videos/play/wwdc2018-602/?time=2464

import ARKit

// MARK: - Properties
class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // Create video player
    let videoPlayer: AVPlayer = {
        
        // Load video from the bundle
        guard let url = Bundle.main.url(forResource: "finversia",
                                        withExtension: "mov",
                                        subdirectory: "art.scnassets")
            else {
                print("Could not find video file finversia.mov")
                return AVPlayer()
        }
        
        return AVPlayer(url: url)
    }()
    
}

// MARK: - UIViewController
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Images to be tracked
        let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources",
            bundle: nil
            )!
        
        // Track the images
        configuration.trackingImages = referenceImages
        
        // Set maximum number of images to track in parallel
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Pause the view's session
        sceneView.session.pause()
        
        super.viewWillDisappear(animated)
    }
    
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    // Create and configure node for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        return node(for: imageAnchor)
    }
    
}

// MARK: - Methods
extension ViewController {
    
    func node(for imageAncor: ARImageAnchor) -> SCNNode {
        // Get reference image size
        let referenceSize = imageAncor.referenceImage.physicalSize
        
        // Create a plane
        let plane = SCNPlane(
            width: referenceSize.width,
            height: referenceSize.height
        )
        
        // Set AVPlayer as the plane's texture and play
        plane.firstMaterial?.diffuse.contents = videoPlayer
        videoPlayer.play()
        
        // Create a node matching plane geometry
        let planeNode = SCNNode(geometry: plane)
        
        // Rotate the plane to match the anchor
        planeNode.eulerAngles.x = -.pi / 2
        
        // Create a node to return
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        return node
    }
    
}

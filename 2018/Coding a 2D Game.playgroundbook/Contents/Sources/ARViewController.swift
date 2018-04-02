//
//  ViewController.swift
//  ar-boilerplate
//
//  Created by Jordan Osterberg on 3/19/18.
//  Copyright © 2018 Jordan Osterberg. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import ARKit

@available(iOS 11.0, *)
public class ARViewController: UIViewController {
    
    var has2dSceneBeenAdded = false
    
    var gameScene : GameScene?
    var playerPosition : CGPoint?
    var activateCheckpoint : Bool? = false
    
    var sceneView = ARSCNView()
    
    let doneButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "done-button"), for: .normal)
        return button
    }()
 
    let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap the screen to place the AR Map"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        if !ARConfiguration.isSupported {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.rules = [.noFish] // Hide fish whilst in AR
        
        if self.activateCheckpoint != nil {
            gameScene?.forceCheckpoint = self.activateCheckpoint! // Turn on the checkpoint if it's been reached
        }
        
        gameScene?.childNode(withName: "background")?.alpha = 0
        gameScene?.backgroundColor = UIColor.clear
        
        gameScene?.startGame()
        
        if let arCamera = gameScene?.childNode(withName: "ARCamera") as? SKCameraNode {
            gameScene?.camera = arCamera
        }
        
        if let position = self.playerPosition {
            gameScene?.catNode?.position = position
        }
        
        sceneView = ARSCNView(frame: view.frame)
        
        self.view.addSubview(self.sceneView)
        
        self.sceneView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.sceneView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.sceneView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.sceneView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.view.addSubview(self.doneButton)
        
        self.doneButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.doneButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        self.doneButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        self.doneButton.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(self.label)
        
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false

        // Create a new scene
        let scene = SCNScene()

        scene.rootNode.scale = SCNVector3Make(1, -1, 1)

        sceneView.backgroundColor = UIColor.clear

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAnchor)))

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
        self.addAnchor()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

@available(iOS 11.0, *)
extension ARViewController : ARSCNViewDelegate {

    // Override to create and configure nodes for anchors added to the view's session.
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if self.has2dSceneBeenAdded {
            return nil
        }

        self.has2dSceneBeenAdded = true

        let plane = SCNPlane(width: 2, height: 1)
        
        plane.firstMaterial?.diffuse.contents = gameScene
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0) // Make it right side up
        plane.firstMaterial?.isDoubleSided = true // Make sure our scene shows up on both sides

        let node = SCNNode(geometry: plane) // Create the node
        
        return node
    }

    @objc func addAnchor() {
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.4
            let transform = simd_mul(currentFrame.camera.transform, translation)

            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)

            sceneView.session.add(anchor: anchor)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.label.alpha = 0
            }, completion: nil)
        }
    }

    public func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    public func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    public func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }

}


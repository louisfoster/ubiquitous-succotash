//
//  GameViewController.swift
//  Ktanosha
//
//  Created by Louie on 15/12/17.
//  Copyright © 2017 Louis Foster. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    // MARK: Properties
    
    // Harness holds the relative position for the avatar and camera, as well as takes user input
    let avatarHarness: Harness = Harness()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create our first scene
        let scene1 = SCNScene()
        
        
        /**
         * Top level node, the "environment" aka earthly plane
         */
        // Plane geo for our "world"
        let planeGeo = SCNPlane(width: 100, height: 100)
        
        // Add an irregular looking image texture so movement is obvious
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
        planeMaterial.diffuse.wrapS = .repeat
        planeMaterial.diffuse.wrapT = .repeat
        planeMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(10, 10, 0)
        
        planeGeo.firstMaterial = planeMaterial
        
        let plane = SCNNode(geometry: planeGeo)
        let rotateBy = -90 / 180 * Double.pi // Angle to make plane flat
        plane.rotation = SCNVector4(1, 0, 0, rotateBy)
        
        scene1.rootNode.addChildNode(plane)
        
        
        
        /**
         * Top level node, the avatar/camera harness
         */
        // The harness is just an empty node
        scene1.rootNode.addChildNode(avatarHarness)
        
        // Starts at a given point, in this case, the global origin
        avatarHarness.position = SCNVector3(x: 0, y: 0, z: 0)
        
        
        /**
         * Harness child node, the camera, remains at a fixed location relative to the harness origin's location and rotation
         */
        // create and add a camera to the scene
        let camera = SCNNode()
        camera.camera = SCNCamera()
        avatarHarness.addChildNode(camera)
        
        // position the camera relative to the harness
        camera.position = SCNVector3(x: 0, y: 6, z: 6)
        // The camera node should automatically angle from its position towards the center of the harness for "tracking"
        camera.look(at: avatarHarness.position)
        
        
        
        /**
         * Harness child node, the avatar (containing the box geometry), is located at the origin of the harness
         */
        
        // Create our placeholder player avatar (box)
        let boxGeometry = SCNBox()
        
        
        
        // Assign a colour material for each side of the box
        let colors = [UIColor.green, // front
            UIColor.red, // right
            UIColor.blue, // back
            UIColor.yellow, // left
            UIColor.purple, // top
            UIColor.gray] // bottom
        
        let sideMaterials = colors.map { color -> SCNMaterial in
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.locksAmbientWithDiffuse = true
            return material
        }
        
        boxGeometry.materials = sideMaterials
        
        let avatar = SCNNode(geometry: boxGeometry)
        avatar.castsShadow = false // No shadow (at least for now)
        avatarHarness.addChildNode(avatar)
        avatar.position = SCNVector3(x: 0, y: 0.5, z: 0) // This will sit on the plane
        
        
        
        /**
         * Lights, for now, are top level nodes
         */
        
        // create and add an omni light to the scene
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = .omni
        omniLightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene1.rootNode.addChildNode(omniLightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene1.rootNode.addChildNode(ambientLightNode)
        
        
        
        /**
         * Setup for the scene view
         */
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene1
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = false
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        
        
        /**
         * Set up gesture recognition
         * Each swipe direction requires it's own recogniser but can call the same selector
         */
        
        // Swipe left (right to left)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        scnView.addGestureRecognizer(leftSwipe)
        
        // Swipe right (left to right)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        scnView.addGestureRecognizer(rightSwipe)
        
        // Swipe up (bottom to top)
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upSwipe.direction = .up
        scnView.addGestureRecognizer(upSwipe)
        
        // Swip down (top to bottom)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe.direction = .down
        scnView.addGestureRecognizer(downSwipe)
        
    }
    
    
    /// Handle the 4 different swipe directions
    ///
    /// - Parameter swipeRecognize: the provided swipe gesture being recognised
    @objc func handleSwipe(_ swipeRecognize: UISwipeGestureRecognizer) {
        
        // Pass the swipe directions onto the harness for movement/rotations
        switch swipeRecognize.direction {
        case .up:
            avatarHarness.moveHarnessForward()
            break
        case .down:
            avatarHarness.moveHarnessBack()
            break
        case .left:
            avatarHarness.rotateHarnessLeft()
            break
        case .right:
            avatarHarness.rotateHarnessRight()
            break
        default:
            return
        }
        
    }
    
    /* Keeping for future reference
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    */
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}

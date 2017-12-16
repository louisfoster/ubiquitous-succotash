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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create our first scene
        let scene1 = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene1.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 5, y: 10, z: 5)
        
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
        
        // Create our placeholder player avatar (box)
        let boxGeo = SCNBox()
        
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
        
        boxGeo.materials = sideMaterials
        
        let box = SCNNode(geometry: boxGeo)
        box.castsShadow = false // No shadow (at least for now)
        box.position = SCNVector3(x: 0, y: 0.5, z: 0) // This will sit on the plane
        
        scene1.rootNode.addChildNode(box)
        
        // The camera node should automatically angle from its position towards the box for "tracking"
        cameraNode.look(at: box.position)
        
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
        
        
        // animate the 3d object, keeping this for reference
        // ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene1
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer, keeping for reference
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

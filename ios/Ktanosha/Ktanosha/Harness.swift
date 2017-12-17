//
//  Harness.swift
//  Ktanosha
//
//  Created by Louie on 17/12/17.
//  Copyright © 2017 Louis Foster. All rights reserved.
//

import UIKit
import SceneKit

class Harness: SCNNode {
    
    //MARK: Properties
    
    // Manages the vertical axis alignment and top end polarity to ensure consistent movement
    struct harnessState {
        var moveAxis: String = "Z"
        var upDirection: String = "-"
    }
    var state: harnessState = harnessState.init()
    
    
    //MARK: Initialisers
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Actions
    
    
    /// Turn left (according to player/screen view), updates harness axis alignment state
    func rotateHarnessLeft() {
        let turnRadians = 90 / 180 * CGFloat.pi
        self.runAction(SCNAction.rotate(by: turnRadians, around: SCNVector3(x: 0, y: 1, z: 0), duration: 0.5))
        switch state.moveAxis + state.upDirection {
        case "Z+":
            state.moveAxis = "X"
            break
        case "X+":
            state.moveAxis = "Z"
            state.upDirection = "-"
            break
        case "Z-":
            state.moveAxis = "X"
            break
        case "X-":
            state.moveAxis = "Z"
            state.upDirection = "+"
            break
        default:
            return
        }
    }
    
    /// Turn right (according to player/screen view), updates harness axis alignment state
    func rotateHarnessRight() {
        let turnRadians = -90 / 180 * CGFloat.pi
        self.runAction(SCNAction.rotate(by: turnRadians, around: SCNVector3(x: 0, y: 1, z: 0), duration: 0.5))
        switch state.moveAxis + state.upDirection {
        case "Z+":
            state.moveAxis = "X"
            state.upDirection = "-"
            break
        case "X+":
            state.moveAxis = "Z"
            break
        case "Z-":
            state.moveAxis = "X"
            state.upDirection = "+"
            break
        case "X-":
            state.moveAxis = "Z"
            break
        default:
            return
        }
    }
    
    /// Translate harness in an upwards direction (according to player/screen view) based on axis alignment state
    func moveHarnessForward() {
        let distance: Float = 2.0
        var Z: Float = 0, X: Float = 0
        switch state.moveAxis + state.upDirection {
        case "Z+":
            Z = 1
            break
        case "X+":
            X = 1
            break
        case "Z-":
            Z = -1
            break
        case "X-":
            X = -1
            break
        default:
            return
        }
        self.runAction(SCNAction.move(by: SCNVector3(x: X * distance, y: 0, z: Z * distance), duration: 0.5))
    }
    
    /// Translates harness in a downward direction (according to player/screen view) based on axis alignment state
    func moveHarnessBack() {
        let distance: Float = 2
        var Z: Float = 0, X: Float = 0
        switch state.moveAxis + state.upDirection {
        case "Z+":
            Z = -1
            break
        case "X+":
            X = -1
            break
        case "Z-":
            Z = 1
            break
        case "X-":
            X = 1
            break
        default:
            return
        }
        self.runAction(SCNAction.move(by: SCNVector3(x: X * distance, y: 0, z: Z * distance), duration: 0.5))
    }
    
}

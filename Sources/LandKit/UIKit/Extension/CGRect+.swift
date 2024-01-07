//
//  CGRect+.swift
//  LandKit
//
//  Created by LandKit on 2023/7/21.
//

import UIKit

public extension CGRect {
    // Implement a getter and setter for the center
    // of the on CGRect
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
        set {
            origin = CGPoint(
                x: newValue.x - (size.width * 0.5),
                y: newValue.y - (size.height * 0.5)
            )
        }
    }
    
    // Implement a getter and setter for the top left
    // corner of the CGRect
    var topLeft: CGPoint {
        get {
            return CGPoint(x: minX, y: minY)
        }
        set {
            origin = CGPoint(
                x: newValue.x,
                y: newValue.y
            )
        }
    }
    
    // Implement a getter and setter for the bottom left
    // corner of the CGRect
    var bottomLeft: CGPoint {
        get {
            return CGPoint(x: minX, y: maxY)
        }
        set {
            origin = CGPoint(
                x: newValue.x,
                y: newValue.y - size.height
            )
        }
    }
    
    // Implement a getter and setter for the top right
    // corner of the CGRect
    var topRight: CGPoint {
        get {
            return CGPoint(x: maxX, y: minY)
        }
        set {
            origin = CGPoint(
                x: newValue.x - size.width,
                y: newValue.y
            )
        }
    }
    
    // Implement a getter and setter for the bottom right
    // corner of the CGRect
    var bottomRight: CGPoint {
        get {
            return CGPoint(x: maxX, y: maxY)
        }
        set {
            origin = CGPoint(
                x: newValue.x - size.width,
                y: newValue.y - size.height
            )
        }
    }
}

//
//  Positionable.swift
//  Spot
//
//  Created by 전민건 on 11/29/23.
//

import Foundation
import QuartzCore
import UIKit

public protocol Positionable: AnyObject {
    
    var bounds: CGRect { get set }
    var layer: CALayer { get }
    
}

extension UIView: Positionable {
    
}

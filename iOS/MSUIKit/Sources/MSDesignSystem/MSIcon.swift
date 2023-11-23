//
//  MSIcon.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

public enum MSIcon: String {
    case check = "Check"
    case close = "Close"
    
    case arrowUp = "Up"
    case arrowLeft = "Left"
    case arrowDown = "Down"
    case arrowRight = "Right"
    
    case calendar = "Calendar"
    case image = "Image"
    case location = "Location"
    case addLocation = "Location Add"
    case lock = "Lock"
    case map = "Map"
    case message = "Message"
    case setting = "Setting"
    case userTag = "User Tag"
    
    case pause = "Pause"
    case play = "Play"
    case voice = "Voice"
    case volumeHigh = "Volume High"
    case volumeOff = "Volume Off"
}

extension UIImage {
    
    public static func msIcon(_ icon: MSIcon) -> UIImage? {
        return UIImage(named: icon.rawValue, in: .module, compatibleWith: .current)?.withRenderingMode(.alwaysTemplate)
    }
    
}

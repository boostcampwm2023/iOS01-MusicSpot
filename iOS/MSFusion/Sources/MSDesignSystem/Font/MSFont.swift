//
//  MSFont.swift
//  MSDesignSystem
//
//  Created by 이창준 on 11/19/23.
//

import CoreGraphics
import CoreText
import Foundation

public enum MSFont {
    case superTitle
    case duperTitle
    case headerTitle
    case subtitle
    case buttonTitle
    case paragraph
    case boldCaption
    case caption
    
    // MARK: - Functions
    
    internal var fontDetails: (fontName: String, size: CGFloat) {
        switch self {
        case .superTitle: return ("Pretendard-Bold", 34.0)
        case .duperTitle: return ("Pretendard-Bold", 28.0)
        case .headerTitle: return ("Pretendard-Bold", 22.0)
        case .subtitle: return ("Pretendard-Bold", 20.0)
        case .buttonTitle: return ("Pretendard-SemiBold", 20.0)
        case .paragraph: return ("Pretendard-Regular", 17.0)
        case .boldCaption: return ("Pretendard-SemiBold", 13.0)
        case .caption: return ("Pretendard-Regular", 13.0)
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            return
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    public static func registerFonts() {
        [
            "Pretendard-Regular",
            "Pretendard-SemiBold",
            "Pretendard-Bold"
        ].forEach {
            self.registerFont(bundle: .msDesignSystem, fontName: $0, fontExtension: "otf")
        }
    }
    
}

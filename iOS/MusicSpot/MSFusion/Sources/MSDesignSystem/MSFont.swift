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

    // MARK: Public

    public static func registerFonts() {
        [
            "Pretendard-Regular",
            "Pretendard-SemiBold",
            "Pretendard-Bold",
        ].forEach {
            registerFont(bundle: .msDesignSystem, fontName: $0, fontExtension: "otf")
        }
    }

    // MARK: Package

    // MARK: - Functions

    package var fontDetails: (fontName: String, size: CGFloat) {
        switch self {
        case .superTitle: ("Pretendard-Bold", 34.0)
        case .duperTitle: ("Pretendard-Bold", 28.0)
        case .headerTitle: ("Pretendard-Bold", 22.0)
        case .subtitle: ("Pretendard-Bold", 20.0)
        case .buttonTitle: ("Pretendard-SemiBold", 20.0)
        case .paragraph: ("Pretendard-Regular", 17.0)
        case .boldCaption: ("Pretendard-SemiBold", 13.0)
        case .caption: ("Pretendard-Regular", 13.0)
        }
    }

    // MARK: Fileprivate

    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard
            let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider)
        else {
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }

}

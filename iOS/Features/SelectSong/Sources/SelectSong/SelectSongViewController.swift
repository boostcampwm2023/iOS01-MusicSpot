//
//  SelectSongViewController.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.03.
//

import UIKit

import MSUIKit

public final class SelectSongViewController: BaseViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let title = "음악 검색"
        
    }
    
    // MARK: - UI Components
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    // MARK: - UI Configuration
    
    public override func configureStyle() {
        super.configureStyle()
        
        self.title = Typo.title
    }
    
    public override func configureLayout() {
        
    }
    
}

// MARK: - Preview

#if DEBUG
import MSDesignSystem

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    
    let selectSongViewController = SelectSongViewController()
    return selectSongViewController
}
#endif

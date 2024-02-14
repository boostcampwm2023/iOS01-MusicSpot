//
//  VersionViewController.swift
//  Version
//
//  Created by 이창준 on 2024.02.13.
//

import SwiftUI

public final class VersionViewController: UIHostingController<VersionView> {
    
    // MARK: - Initializer
    
    public override init(rootView: VersionView = VersionView()) {
        super.init(rootView: rootView)
    }
    
    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

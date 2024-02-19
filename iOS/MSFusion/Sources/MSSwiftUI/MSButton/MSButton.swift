//
//  SwiftUIView.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.19.
//

import SwiftUI

import MSDesignSystem

struct MSButton: View {
    
    // MARK: - Constants
    
    private enum Metric {
        static let height: CGFloat = 60.0
        static let horizontalEdgeInsets: CGFloat = 58.0
        static let verticalEdgeInsets: CGFloat = 10.0
        static let imagePadding: CGFloat = 8.0
    }
    
    // MARK: - Properties
    
    private var title: String?
    private var image: Image?
    private let action: (() -> Void)?
    
    // MARK: - Initializer
    
    public init(title: String? = nil,
                image: Image? = nil,
                action: (() -> Void)? = nil) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button {
            self.action?()
        } label: {
            HStack(spacing: Metric.imagePadding) {
                if let image = self.image {
                    image
                }
                if let title = self.title {
                    Text(title)
                }
            }
            .padding(.horizontal, Metric.horizontalEdgeInsets)
            .padding(.vertical, Metric.verticalEdgeInsets)
        }
        .font(.msFont(.buttonTitle))
        .frame(height: Metric.height)
    }
    
}

#Preview {
    let button = MSButton(title: "버튼",
                          image: .msIcon(.check)) {
        print("Hello World!")
    }
    return button
}

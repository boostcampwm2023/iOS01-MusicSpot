//
//  ConfirmTitleAlertViewController.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import UIKit

import MSUIKit

final class ConfirmTitleAlertViewController: MSAlertViewController {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let horizontalInset: CGFloat = 12.0
        
    }
    
    // MARK: - UI Components
    
    private let textField: MSTextField = {
        let textField = MSTextField()
        textField.imageStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        textField.placeholder = "Placeholder"
        return textField
    }()
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButtonActions()
    }
    
    // MARK: - Helpers
    
    override func dismissBottomSheet() {
        super.dismissBottomSheet()
        self.textField.resignFirstResponder()
    }
    
    private func configureButtonActions() {
        self.cancelButtonAction = UIAction { _ in
            self.dismissBottomSheet()
        }
        
        self.doneButtonAction = UIAction { _ in
            print("TODO: 완료 로직 구현!!")
        }
    }
    
    // MARK: - UI Configuration
    
    override func configureLayout() {
        super.configureLayout()
        
        self.containerView.addSubview(self.textField)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textField.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                    constant: Metric.horizontalInset),
            self.textField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                     constant: -Metric.horizontalInset)
        ])
    }
    
}

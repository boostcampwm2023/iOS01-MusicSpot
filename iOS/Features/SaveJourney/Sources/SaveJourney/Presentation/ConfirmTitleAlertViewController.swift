//
//  ConfirmTitleAlertViewController.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import Combine
import UIKit

import CombineCocoa
import MSUIKit

protocol AlertViewControllerDelegate: AnyObject {
    
    func titleDidConfirmed(_ title: String)
    
}

final class ConfirmTitleAlertViewController: MSAlertViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let title = "여정 이름"
        static let placeholder = "마지막으로 여정의 이름을 정해주세요."
        
    }
    
    private enum Metric {
        
        static let horizontalInset: CGFloat = 12.0
        static let textFieldCenterOffset: CGFloat = 15.0
        
    }
    
    // MARK: - UI Components
    
    private let textField: MSTextField = {
        let textField = MSTextField()
        textField.imageStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        textField.placeholder = Typo.placeholder
        return textField
    }()
    
    // MARK: - Properties
    
    weak var delegate: AlertViewControllerDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButtonActions()
        self.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.textField.textPublisher
            .receive(on: DispatchQueue.main)
            .map { $0.isEmpty }
            .removeDuplicates()
            .sink { [weak self] isTextEmpty in
                self?.updateDoneButton(isEnabled: !isTextEmpty)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Helpers
    
    override func dismissBottomSheet() {
        super.dismissBottomSheet()
        self.textField.resignFirstResponder()
    }
    
    private func configureButtonActions() {
        self.cancelButtonAction = UIAction { [weak self] _ in
            self?.dismissBottomSheet()
        }
        
        self.doneButtonAction = UIAction { [weak self] _ in
            guard let title = self?.textField.text else { return }
            self?.dismissBottomSheet()
            self?.delegate?.titleDidConfirmed(title)
        }
    }
    
    // MARK: - UI Configuration
    
    override func configureStyles() {
        super.configureStyles()
        
        self.updateTitle(Typo.title)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        self.containerView.addSubview(self.textField)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textField.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor,
                                                    constant: -Metric.textFieldCenterOffset),
            self.textField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                    constant: Metric.horizontalInset),
            self.textField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                     constant: -Metric.horizontalInset)
        ])
    }
    
}

//
//  FLTextField.swift
//  eVote
//
//  Created by Danylo Manko on 17.04.2021.
//

import UIKit

final class FLTextField: UIView {
    
    private let textField = UITextField()
    private let fieldNameLabel = UILabel()
    private let symbolsLeftLabel = UILabel()
    
    let symbolsMaxCount: Int
    
    var onDone: VoidClosure?
    var onText: StringClosure?
    
    var placeholder: String? {
        didSet {
            self.textField.placeholder = self.placeholder
        }
    }
    
    var title: String? {
        didSet {
            self.fieldNameLabel.text = self.title
        }
    }
    
    init(symbolsMaxCount: Int) {
        self.symbolsMaxCount = symbolsMaxCount
        super.init(frame: .zero)
        
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.fieldNameLabel.font = .preferredFont(forTextStyle: .headline)
        self.fieldNameLabel.textColor = .systemBlue
        self.fieldNameLabel.textAlignment = .left
        
        self.textField.font = .preferredFont(forTextStyle: .body)
        self.textField.textColor = .label
        self.textField.delegate = self
        
        let separatorView = UIView()
        separatorView.backgroundColor = .separator
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.symbolsLeftLabel.font = .preferredFont(forTextStyle: .caption2)
        self.symbolsLeftLabel.textColor = .secondaryLabel
        self.symbolsLeftLabel.text = "\(self.symbolsMaxCount)"
        
        let symbolsLeftStackView = UIStackView(arrangedSubviews: [UIView(), self.symbolsLeftLabel])
        symbolsLeftStackView.axis = .horizontal
        
        let stackView = UIStackView(arrangedSubviews: [self.fieldNameLabel, self.textField, separatorView, symbolsLeftStackView])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.setCustomSpacing(0, after: self.textField)
        
        self.fl_addSubview(stackView)
    }
    
    func resignActive() {
        self.textField.resignFirstResponder()
    }
    
    func becomeActive(){
        self.textField.becomeFirstResponder()
    }
    
    func setText(_ text: String?) {
        self.textField.text = text
        
        let symbolsLeft = self.symbolsMaxCount - (text?.count ?? 0)
        self.symbolsLeftLabel.text = "\(symbolsLeft)"
    }
}

extension FLTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            guard updatedText.count <= self.symbolsMaxCount else { return false }
            
            let symbolsLeft = self.symbolsMaxCount - updatedText.count
            self.symbolsLeftLabel.text = "\(symbolsLeft)"
            
            self.onText?(updatedText)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onDone?()
        return true
    }
}

//
//  AlertTextFieldPlugin.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public class AlertTextFieldPlugin: AlertBasePlugin {

    private let textField: UITextField
    private let placeholder: String
    private var textChangedCallback: ((String) -> Void)?

    public init(placeholder: String = "请输入...",
                font: UIFont = UIFont.systemFont(ofSize: 16),
                textColor: UIColor = UIColor.label,
                backgroundColor: UIColor = UIColor.secondarySystemFill,
                onTextChanged: ((String) -> Void)? = nil) {
        self.placeholder = placeholder
        self.textChangedCallback = onTextChanged
        self.textField = UITextField()
        super.init(spacing: 16)
        setupTextField(font: font, textColor: textColor, backgroundColor: backgroundColor)
    }

    override public func setupContent() {
        containerView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupTextField(font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        textField.placeholder = placeholder
        textField.font = font
        textField.textColor = textColor
        textField.backgroundColor = backgroundColor
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.separator.cgColor

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always

        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidEndOnExit), for: .editingDidEndOnExit)

        setupAccessibility(for: textField, label: placeholder, traits: .none)
        textField.accessibilityHint = "双击编辑文本"
    }

    @objc private func textFieldDidChange() {
        textChangedCallback?(textField.text ?? "")
    }

    @objc private func textFieldDidEndOnExit() {
        textField.resignFirstResponder()
    }

    public func getText() -> String {
        return textField.text ?? ""
    }

    public func setText(_ text: String) {
        textField.text = text
    }

    public func setEnabled(_ enabled: Bool) {
        textField.isEnabled = enabled
        textField.alpha = enabled ? 1.0 : 0.6
    }

    @discardableResult
    public func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    @discardableResult
    public func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    public func updatePlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
        textField.accessibilityLabel = placeholder
    }

    override public func pluginWillAppear() {
        textField.alpha = 0
        textField.transform = CGAffineTransform(translationX: 0, y: 15).scaledBy(x: 0.95, y: 0.95)
    }

    override public func pluginDidAppear() {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            self.textField.alpha = 1
            self.textField.transform = .identity
        }
    }

    override public func pluginWillDisappear() {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.textField.alpha = 0.3
            self.textField.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    override public func pluginDidDisappear() {
        textField.alpha = 1
        textField.transform = .identity
    }
}

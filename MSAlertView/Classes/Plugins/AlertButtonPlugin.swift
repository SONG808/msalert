//
//  AlertButtonPlugin.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public class AlertButtonPlugin: AlertBasePlugin {

    public enum ButtonStyle {
        case `default`
        case destructive
        case cancel
        case primary
    }

    override public var pluginType: AlertPluginType { .button }

    private let button: UIButton
    private let style: ButtonStyle
    private let action: (@escaping ((() -> Void)?) -> Void) -> Void

    public init(title: String, style: ButtonStyle = .default, action: @escaping (@escaping ((() -> Void)?) -> Void) -> Void) {
        self.style = style
        self.action = action
        self.button = UIButton(type: .system)
        super.init(spacing: 8)
        setupButton(title: title)
    }

    override public func setupContent() {
        containerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    private func setupButton(title: String) {
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        applyStyle()
        setupAccessibility(for: button, label: title, traits: .button)
        addTouchEffects(to: button)
    }

    private func applyStyle() {
        switch style {
        case .default:
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        case .destructive:
            button.setTitleColor(.systemRed, for: .normal)
            button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
        case .cancel:
            button.setTitleColor(.secondaryLabel, for: .normal)
            button.backgroundColor = UIColor.secondarySystemFill
            button.layer.borderWidth = 0
        case .primary:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.borderWidth = 0
        }
    }

    @objc private func buttonTapped() {
        triggerHapticFeedback()
        action { [weak self] completion in
            self?.dismissAlert(completion: completion)
        }
    }

    public func updateTitle(_ title: String) {
        button.setTitle(title, for: .normal)
        button.accessibilityLabel = title
    }

    public func setEnabled(_ enabled: Bool) {
        button.isEnabled = enabled
        button.alpha = enabled ? 1.0 : 0.5
    }

    override public func pluginWillAppear() {
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.9, y: 0.9)
    }

    override public func pluginDidAppear() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4, options: .curveEaseOut) {
            self.button.alpha = 1
            self.button.transform = .identity
        }
    }

    override public func pluginWillDisappear() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn) {
            self.button.alpha = 0.2
            self.button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override public func pluginDidDisappear() {
        button.alpha = 1
        button.transform = .identity
    }
}

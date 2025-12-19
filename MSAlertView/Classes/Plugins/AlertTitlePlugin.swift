//
//  AlertTitlePlugin.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public class AlertTitlePlugin: AlertBasePlugin {

    override public var pluginType: AlertPluginType { .title }

    private let titleLabel: UILabel

    public init(text: String,
                font: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold),
                textColor: UIColor = UIColor.label,
                textAlignment: NSTextAlignment = .center) {
        self.titleLabel = UILabel()
        super.init(spacing: 20)
        setupLabel(text: text, font: font, textColor: textColor, textAlignment: textAlignment)
    }

    override public func setupContent() {
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func setupLabel(text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        titleLabel.text = text
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = textAlignment
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        setupAccessibility(for: titleLabel, label: text, traits: .header)
    }

    public func updateText(_ text: String) {
        titleLabel.text = text
        titleLabel.accessibilityLabel = text
    }

    public func updateFont(_ font: UIFont) {
        titleLabel.font = font
    }

    public func updateTextColor(_ color: UIColor) {
        titleLabel.textColor = color
    }

    public func updateTextAlignment(_ alignment: NSTextAlignment) {
        titleLabel.textAlignment = alignment
    }

    override public func pluginWillAppear() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -15).scaledBy(x: 0.95, y: 0.95)
    }

    override public func pluginDidAppear() {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
    }

    override public func pluginWillDisappear() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.titleLabel.alpha = 0.5
        }
    }

    override public func pluginDidDisappear() {
        titleLabel.alpha = 1
        titleLabel.transform = .identity
    }
}

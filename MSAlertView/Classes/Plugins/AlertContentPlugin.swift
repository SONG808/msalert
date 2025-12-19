//
//  AlertContentPlugin.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public class AlertContentPlugin: AlertBasePlugin {

    override public var pluginType: AlertPluginType { .content }

    private let contentLabel: UILabel

    public init(text: String,
                font: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular),
                textColor: UIColor = UIColor.secondaryLabel,
                textAlignment: NSTextAlignment = .center) {
        self.contentLabel = UILabel()
        super.init(spacing: 24)
        setupLabel(text: text, font: font, textColor: textColor, textAlignment: textAlignment)
    }

    override public func setupContent() {
        containerView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func setupLabel(text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        contentLabel.text = text
        contentLabel.font = font
        contentLabel.textColor = textColor
        contentLabel.textAlignment = textAlignment
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        contentLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        setupAccessibility(for: contentLabel, label: text, traits: .staticText)
    }

    public func updateText(_ text: String) {
        contentLabel.text = text
        contentLabel.accessibilityLabel = text
    }

    public func updateFont(_ font: UIFont) {
        contentLabel.font = font
    }

    public func updateTextColor(_ color: UIColor) {
        contentLabel.textColor = color
    }

    public func updateTextAlignment(_ alignment: NSTextAlignment) {
        contentLabel.textAlignment = alignment
    }

    override public func pluginWillAppear() {
        contentLabel.alpha = 0
        contentLabel.transform = CGAffineTransform(translationX: 0, y: -10).scaledBy(x: 0.98, y: 0.98)
    }

    override public func pluginDidAppear() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.2, options: .curveEaseOut) {
            self.contentLabel.alpha = 1
            self.contentLabel.transform = .identity
        }
    }

    override public func pluginWillDisappear() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.contentLabel.alpha = 0.3
        }
    }

    override public func pluginDidDisappear() {
        contentLabel.alpha = 1
        contentLabel.transform = .identity
    }
}

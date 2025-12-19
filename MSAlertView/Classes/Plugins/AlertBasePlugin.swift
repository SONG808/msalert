//
//  AlertBasePlugin.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

open class AlertBasePlugin: AlertPlugin {

    open var pluginView: UIView { containerView }
    open var preferredSpacing: CGFloat
    open var pluginType: AlertPluginType { .custom }

    public let containerView: UIView
    public weak var alertViewController: AlertViewController?

    public init(spacing: CGFloat = 16) {
        self.containerView = UIView()
        self.preferredSpacing = spacing
        setupContainerView()
        setupContent()
    }

    public convenience init(spacing: CGFloat = 16,
                            setup: @escaping (_ container: UIView, _ plugin: AlertBasePlugin) -> Void) {
        self.init(spacing: spacing)
        setup(containerView, self)
    }

    open func setupContent() {}

    private func setupContainerView() {
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    open func pluginWillAppear() {}
    open func pluginDidAppear() {}
    open func pluginWillDisappear() {}
    open func pluginDidDisappear() {}

    public func setAlertViewController(_ controller: AlertViewController) {
        self.alertViewController = controller
    }

    public func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    public func dismissAlert(completion: (() -> Void)? = nil) {
        alertViewController?.dismiss(completion: completion)
    }

    public func addTouchEffects(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.8
        }
    }

    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }

    public func setupAccessibility(for view: UIView, label: String, traits: UIAccessibilityTraits) {
        view.isAccessibilityElement = true
        view.accessibilityLabel = label
        view.accessibilityTraits = traits
    }
}

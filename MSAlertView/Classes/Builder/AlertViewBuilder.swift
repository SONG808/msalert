//
//  AlertViewBuilder.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public class AlertViewBuilder {

    private var alertType: AlertPresentationType = .alert
    private var plugins: [AlertPlugin] = []
    private var dismissCallback: (() -> Void)?
    private var contentLayoutMargins: UIEdgeInsets?
    private var dismissOnBackgroundTap: Bool = true
    private var dismissOnSwipeDown: Bool = true
    private var backgroundAlpha: CGFloat = 0.5
    private var alertMaxWidth: CGFloat = 320
    private var alertMinEdgeSpacing: CGFloat = 32
    private var alertCornerRadius: CGFloat = 16
    private var sheetCornerRadius: CGFloat = 16
    private var sheetMinTopSpacing: CGFloat = 100

    public init() {}

    @discardableResult
    public func type(_ type: AlertPresentationType) -> AlertViewBuilder {
        self.alertType = type
        return self
    }

    @discardableResult
    public func addPlugin(_ plugin: AlertPlugin) -> AlertViewBuilder {
        self.plugins.append(plugin)
        return self
    }

    @discardableResult
    public func onDismiss(_ callback: @escaping () -> Void) -> AlertViewBuilder {
        self.dismissCallback = callback
        return self
    }

    @discardableResult
    public func contentMargins(_ margins: UIEdgeInsets) -> AlertViewBuilder {
        self.contentLayoutMargins = margins
        return self
    }

    @discardableResult
    public func contentMargins(top: CGFloat = 24, left: CGFloat = 24, bottom: CGFloat = 24, right: CGFloat = 24) -> AlertViewBuilder {
        self.contentLayoutMargins = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    @discardableResult
    public func backgroundDismiss(_ enabled: Bool) -> AlertViewBuilder {
        self.dismissOnBackgroundTap = enabled
        return self
    }

    @discardableResult
    public func swipeDismiss(_ enabled: Bool) -> AlertViewBuilder {
        self.dismissOnSwipeDown = enabled
        return self
    }

    @discardableResult
    public func backgroundOpacity(_ alpha: CGFloat) -> AlertViewBuilder {
        self.backgroundAlpha = max(0, min(1, alpha))
        return self
    }

    @discardableResult
    public func maxWidth(_ width: CGFloat) -> AlertViewBuilder {
        self.alertMaxWidth = max(200, width)
        return self
    }

    @discardableResult
    public func edgeSpacing(_ spacing: CGFloat) -> AlertViewBuilder {
        self.alertMinEdgeSpacing = max(0, spacing)
        return self
    }

    @discardableResult
    public func cornerRadius(alert: CGFloat? = nil, sheet: CGFloat? = nil) -> AlertViewBuilder {
        if let alert = alert { self.alertCornerRadius = max(0, alert) }
        if let sheet = sheet { self.sheetCornerRadius = max(0, sheet) }
        return self
    }

    @discardableResult
    public func sheetTopSpacing(_ spacing: CGFloat) -> AlertViewBuilder {
        self.sheetMinTopSpacing = max(50, spacing)
        return self
    }

    @discardableResult
    public func title(_ text: String,
                      font: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold),
                      textColor: UIColor = UIColor.label,
                      textAlignment: NSTextAlignment = .center) -> AlertViewBuilder {
        let titlePlugin = AlertTitlePlugin(text: text, font: font, textColor: textColor, textAlignment: textAlignment)
        return addPlugin(titlePlugin)
    }

    @discardableResult
    public func content(_ text: String,
                        font: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular),
                        textColor: UIColor = UIColor.secondaryLabel,
                        textAlignment: NSTextAlignment = .center) -> AlertViewBuilder {
        let contentPlugin = AlertContentPlugin(text: text, font: font, textColor: textColor, textAlignment: textAlignment)
        return addPlugin(contentPlugin)
    }

    @discardableResult
    public func button(_ title: String,
                       style: AlertButtonPlugin.ButtonStyle = .default,
                       action: @escaping (@escaping ((() -> Void)?) -> Void) -> Void) -> AlertViewBuilder {
        let buttonPlugin = AlertButtonPlugin(title: title, style: style, action: action)
        return addPlugin(buttonPlugin)
    }

    @discardableResult
    public func textField(_ placeholder: String = "请输入...",
                          font: UIFont = UIFont.systemFont(ofSize: 16),
                          textColor: UIColor = UIColor.label,
                          backgroundColor: UIColor = UIColor.secondarySystemFill,
                          onTextChanged: ((String) -> Void)? = nil) -> AlertViewBuilder {
        let textFieldPlugin = AlertTextFieldPlugin(
            placeholder: placeholder,
            font: font,
            textColor: textColor,
            backgroundColor: backgroundColor,
            onTextChanged: onTextChanged
        )
        return addPlugin(textFieldPlugin)
    }

    @discardableResult
    public func customView(spacing: CGFloat = 16,
                           setup: @escaping (_ container: UIView, _ plugin: AlertBasePlugin) -> Void) -> AlertViewBuilder {
        let customPlugin = AlertBasePlugin(spacing: spacing, setup: setup)
        return addPlugin(customPlugin)
    }

    public func build() -> AlertViewController {
        guard !plugins.isEmpty else {
            fatalError("AlertViewBuilder: 至少需要添加一个插件")
        }

        let alertVC = AlertViewController(type: alertType)

        if let margins = contentLayoutMargins {
            alertVC.contentLayoutMargins = margins
        }
        alertVC.dismissOnBackgroundTap = dismissOnBackgroundTap
        alertVC.dismissOnSwipeDown = dismissOnSwipeDown
        alertVC.backgroundAlpha = backgroundAlpha
        alertVC.alertMaxWidth = alertMaxWidth
        alertVC.alertMinEdgeSpacing = alertMinEdgeSpacing
        alertVC.alertCornerRadius = alertCornerRadius
        alertVC.sheetCornerRadius = sheetCornerRadius
        alertVC.sheetMinTopSpacing = sheetMinTopSpacing

        plugins.forEach { alertVC.addPlugin($0) }

        if let callback = dismissCallback {
            var observerToken: NSObjectProtocol?
            observerToken = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("AlertViewDismissed"),
                object: alertVC,
                queue: .main
            ) { _ in
                callback()
                if let token = observerToken {
                    NotificationCenter.default.removeObserver(token)
                    observerToken = nil
                }
            }
        }

        return alertVC
    }

    public func present(from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let alertVC = build()
        viewController.present(alertVC, animated: false, completion: completion)
    }
}

public extension AlertViewController {

    static func builder() -> AlertViewBuilder {
        return AlertViewBuilder()
    }

    static func alert(title: String? = nil, message: String? = nil) -> AlertViewBuilder {
        var builder = AlertViewBuilder().type(.alert)
        if let title = title { builder = builder.title(title) }
        if let message = message { builder = builder.content(message) }
        return builder
    }

    static func sheet(title: String? = nil, message: String? = nil) -> AlertViewBuilder {
        var builder = AlertViewBuilder().type(.sheet)
        if let title = title { builder = builder.title(title) }
        if let message = message { builder = builder.content(message) }
        return builder
    }
}

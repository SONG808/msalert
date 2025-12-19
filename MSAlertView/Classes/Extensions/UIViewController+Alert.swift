//
//  UIViewController+Alert.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public extension UIViewController {    
    func showActionAlert(title: String? = nil,
                         message: String? = nil,
                         actions: [(title: String, style: AlertButtonPlugin.ButtonStyle, action: (() -> Void)?)],
                         cancelTitle: String? = nil,
                         cancelAction: (() -> Void)? = nil) {
        var builder = AlertViewController.alert(title: title, message: message)
        for actionInfo in actions {
            builder = builder.button(actionInfo.title, style: actionInfo.style) { dismiss in
                dismiss { actionInfo.action?() }
            }
        }
        if let cancelTitle {
            builder = builder.button(cancelTitle, style: .cancel) { dismiss in
                dismiss { cancelAction?() }
            }
        }
        builder.present(from: self)
    }

    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         actions: [(title: String, style: AlertButtonPlugin.ButtonStyle, action: (() -> Void)?)],
                         cancelTitle: String = "取消",
                         cancelAction: (() -> Void)? = nil) {
        var builder = AlertViewController.sheet(title: title, message: message)
        for actionInfo in actions {
            builder = builder.button(actionInfo.title, style: actionInfo.style) { dismiss in
                dismiss { actionInfo.action?() }
            }
        }
        builder = builder.button(cancelTitle, style: .cancel) { dismiss in
            dismiss { cancelAction?() }
        }
        builder.present(from: self)
    }
}

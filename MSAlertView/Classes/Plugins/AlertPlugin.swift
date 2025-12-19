//
//  AlertPlugin.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public protocol AlertPlugin: AnyObject {
    var pluginView: UIView { get }
    var preferredSpacing: CGFloat { get }
    var pluginType: AlertPluginType { get }

    func pluginWillAppear()
    func pluginDidAppear()
    func pluginWillDisappear()
    func pluginDidDisappear()
}

public enum AlertPluginType: String, CaseIterable {
    case title = "title"
    case content = "content"
    case button = "button"
    case custom = "custom"
}

public extension AlertPlugin {
    var preferredSpacing: CGFloat { 16 }

    func pluginWillAppear() {}
    func pluginDidAppear() {}
    func pluginWillDisappear() {}
    func pluginDidDisappear() {}
}

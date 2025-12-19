//
//  AlertViewController.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit

public enum AlertPresentationType {
    case alert
    case sheet
}

open class AlertViewController: UIViewController {

    open var contentLayoutMargins: UIEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24) {
        didSet {
            if isViewLoaded {
                contentContainerView.layoutMargins = contentLayoutMargins
            }
        }
    }

    open var dismissOnBackgroundTap: Bool = true {
        didSet {
            backgroundTapGesture?.isEnabled = dismissOnBackgroundTap
        }
    }

    open var dismissOnSwipeDown: Bool = true

    open var backgroundAlpha: CGFloat = 0.5 {
        didSet {
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        }
    }

    open var alertMaxWidth: CGFloat = 320
    open var alertMinEdgeSpacing: CGFloat = 32

    open var alertCornerRadius: CGFloat = 16 {
        didSet {
            if isViewLoaded && presentationType == .alert {
                contentContainerView.layer.cornerRadius = alertCornerRadius
            }
        }
    }

    open var sheetCornerRadius: CGFloat = 16 {
        didSet {
            if isViewLoaded && presentationType == .sheet {
                contentContainerView.layer.cornerRadius = sheetCornerRadius
            }
        }
    }

    open var sheetMinTopSpacing: CGFloat = 100

    public let presentationType: AlertPresentationType
    public private(set) var plugins: [AlertPlugin] = []

    private var backgroundTapGesture: UITapGestureRecognizer?
    private var keyboardConstraint: NSLayoutConstraint?

    public lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        view.alpha = 0
        return view
    }()

    public lazy var contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layoutMargins = contentLayoutMargins
        return view
    }()

    public lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()

    public init(type: AlertPresentationType = .alert) {
        self.presentationType = type
        super.init(nibName: nil, bundle: nil)
        setupModalPresentation()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        clearAllPlugins()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPlugins()
        setupKeyboardObservers()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWithAnimation()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if presentationType == .sheet {
            updateSheetBottomMargin()
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        plugins.forEach { $0.pluginDidDisappear() }
        NotificationCenter.default.removeObserver(self)
    }

    open func addPlugin(_ plugin: AlertPlugin) {
        plugins.append(plugin)
        if isViewLoaded {
            addPluginToStackView(plugin)
            updateLayout()
        }
    }

    open func removePlugin(_ plugin: AlertPlugin) {
        if let index = plugins.firstIndex(where: { $0 === plugin }) {
            plugins.remove(at: index)
            plugin.pluginView.removeFromSuperview()
            updateLayout()
        }
    }

    open func clearAllPlugins() {
        plugins.forEach { $0.pluginView.removeFromSuperview() }
        plugins.removeAll()
    }

    open func addPluginToStackView(_ plugin: AlertPlugin) {
        stackView.addArrangedSubview(plugin.pluginView)
        if let basePlugin = plugin as? AlertBasePlugin {
            basePlugin.setAlertViewController(self)
        }
    }

    open func updateLayout() {
        applyPluginSpacing()
    }

    private func applyPluginSpacing() {
        guard plugins.count > 1 else { return }
        for i in 0..<(plugins.count - 1) {
            let currentPlugin = plugins[i]
            stackView.setCustomSpacing(currentPlugin.preferredSpacing, after: currentPlugin.pluginView)
        }
    }

    private func setupModalPresentation() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    open func setupUI() {
        view.backgroundColor = UIColor.clear
        view.addSubview(backgroundView)
        view.addSubview(contentContainerView)
        contentContainerView.addSubview(stackView)
        setupContainerStyle()
        setupBackgroundTapGesture()
        if presentationType == .sheet {
            setupSwipeDownGesture()
        }
    }

    open func setupBackgroundTapGesture() {
        backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundTapGesture?.isEnabled = dismissOnBackgroundTap
        backgroundView.addGestureRecognizer(backgroundTapGesture!)
    }

    open func setupSwipeDownGesture() {
        guard dismissOnSwipeDown else { return }
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        contentContainerView.addGestureRecognizer(swipeGesture)
    }

    open func setupContainerStyle() {
        switch presentationType {
        case .alert:
            contentContainerView.layer.cornerRadius = alertCornerRadius
            contentContainerView.layer.shadowColor = UIColor.black.cgColor
            contentContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
            contentContainerView.layer.shadowOpacity = 0.2
            contentContainerView.layer.shadowRadius = 16
        case .sheet:
            contentContainerView.layer.cornerRadius = sheetCornerRadius
            contentContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            updateSheetBottomMargin()
        }
    }

    open func updateSheetBottomMargin() {
        guard presentationType == .sheet else { return }
        let bottomSafeArea = view.safeAreaInsets.bottom
        contentLayoutMargins.bottom = max(contentLayoutMargins.bottom, bottomSafeArea + 8)
        contentContainerView.layoutMargins = contentLayoutMargins
    }

    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupContentContainerConstraints()

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentContainerView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    open func setupContentContainerConstraints() {
        switch presentationType {
        case .alert:
            let centerYConstraint = contentContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            keyboardConstraint = centerYConstraint

            let preferredWidthConstraint = contentContainerView.widthAnchor.constraint(equalToConstant: alertMaxWidth)
            preferredWidthConstraint.priority = .defaultHigh

            NSLayoutConstraint.activate([
                contentContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                centerYConstraint,
                contentContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: alertMinEdgeSpacing),
                contentContainerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -alertMinEdgeSpacing),
                contentContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: alertMaxWidth),
                preferredWidthConstraint
            ])

        case .sheet:
            let bottomConstraint = contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            keyboardConstraint = bottomConstraint

            NSLayoutConstraint.activate([
                contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomConstraint,
                contentContainerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: sheetMinTopSpacing)
            ])
        }
    }

    private func setupPlugins() {
        plugins.forEach { addPluginToStackView($0) }
        updateLayout()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let keyboardHeight = keyboardFrame.height

        switch presentationType {
        case .alert:
            keyboardConstraint?.constant = -keyboardHeight / 2
        case .sheet:
            keyboardConstraint?.constant = -keyboardHeight
        }

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        keyboardConstraint?.constant = 0

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
            self.view.layoutIfNeeded()
        }
    }

    open func presentWithAnimation() {
        setupContainerInitialState()
        plugins.forEach { $0.pluginWillAppear() }
        executeContainerPresentation()
        coordinatePluginsAppearance()
    }

    open func setupContainerInitialState() {
        switch presentationType {
        case .alert:
            contentContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            contentContainerView.alpha = 0
        case .sheet:
            contentContainerView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        }
    }

    open func executeContainerPresentation() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.backgroundView.alpha = 1
            self.contentContainerView.transform = .identity
            self.contentContainerView.alpha = 1
        }
    }

    open func coordinatePluginsAppearance() {
        for (index, plugin) in plugins.enumerated() {
            let delay = 0.15 + Double(index) * 0.08
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                plugin.pluginDidAppear()
            }
        }
    }

    open func dismissWithAnimation(completion: @escaping () -> Void) {
        coordinatePluginsDisappearance()

        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            switch self.presentationType {
            case .alert:
                self.contentContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.contentContainerView.alpha = 0
            case .sheet:
                self.contentContainerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            }
        }, completion: { _ in
            completion()
        })
    }

    open func coordinatePluginsDisappearance() {
        let reversedPlugins = plugins.reversed()
        for (index, plugin) in reversedPlugins.enumerated() {
            let delay = Double(index) * 0.04
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                plugin.pluginWillDisappear()
            }
        }
    }

    @objc private func backgroundTapped() {
        if isKeyboardVisible() {
            dismissKeyboard()
        } else {
            dismiss()
        }
    }

    private func isKeyboardVisible() -> Bool {
        return findFirstResponder(in: view) != nil
    }

    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder { return view }
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        return nil
    }

    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func handleSwipeDown(_ gesture: UIPanGestureRecognizer) {
        guard presentationType == .sheet, dismissOnSwipeDown else { return }

        let translation = gesture.translation(in: contentContainerView)
        let velocity = gesture.velocity(in: contentContainerView)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                contentContainerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended, .cancelled:
            let shouldDismiss = translation.y > 100 || velocity.y > 500
            if shouldDismiss {
                if isKeyboardVisible() {
                    dismissKeyboard()
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                        self.contentContainerView.transform = .identity
                    }
                } else {
                    dismiss()
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                    self.contentContainerView.transform = .identity
                }
            }
        default:
            break
        }
    }

    open func dismiss(completion: (() -> Void)? = nil) {
        dismissWithAnimation { [weak self] in
            NotificationCenter.default.post(name: NSNotification.Name("AlertViewDismissed"), object: self)
            self?.dismiss(animated: false) {
                completion?()
            }
        }
    }
}

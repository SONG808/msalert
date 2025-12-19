//
//  ViewController.swift
//  MSAlertView
//
//  Created by sanmu on 12/18/2025.
//  Copyright (c) 2025 sanmu. All rights reserved.
//

import UIKit
import MSAlertView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "MSAlertView Demo"

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        // 添加测试按钮
        let buttons: [(String, Selector)] = [
            ("基础 Alert", #selector(showBasicAlert)),
            ("确认对话框", #selector(showConfirmDialog)),
            ("Action Sheet", #selector(showTestActionSheet)),
            ("自定义样式", #selector(showCustomAlert)),
            ("超长内容", #selector(showLongContentAlert)),
            ("Sheet 测试", #selector(showSheetTests)),
            ("边界情况", #selector(showEdgeCases)),
            ("输入框测试", #selector(showInputAlert)),
            ("多输入框 Sheet", #selector(showMultiInputSheet)),
            ("自定义视图", #selector(showCustomViewAlert))
        ]

        for (title, action) in buttons {
            let button = createButton(title: title, action: action)
            stackView.addArrangedSubview(button)
        }
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }

    // MARK: - Alert 测试方法

    @objc private func showBasicAlert() {
        showAlert(title: "基础提示",
                 message: "这是一个基础的 AlertView 示例，使用了默认的样式和动画。") {
            print("用户点击了确定按钮")
        }
    }

    @objc private func showConfirmDialog() {
        showConfirmDialog(title: "确认操作",
                         message: "您确定要执行此操作吗？此操作不可撤销。",
                         confirmAction: {
                             print("用户确认了操作")
                         }, cancelAction: {
                             print("用户取消了操作")
                         })
    }

    @objc private func showTestActionSheet() {
        let actions: [(title: String, style: AlertButtonPlugin.ButtonStyle, action: () -> Void)] = [
            ("编辑", .default, { print("选择了编辑") }),
            ("分享", .default, { print("选择了分享") }),
            ("删除", .destructive, { print("选择了删除") })
        ]

        showActionSheet(title: "选择操作",
                       message: "请选择您要执行的操作",
                       actions: actions) {
            print("用户取消了操作")
        }
    }

    @objc private func showCustomAlert() {
        AlertViewController.builder()
            .type(.alert)
            .title("自定义弹窗", font: UIFont.systemFont(ofSize: 20, weight: .bold), textColor: .systemPurple)
            .content("这是一个完全自定义的弹窗示例。\n\n✨ 自定义了标题颜色\n🎨 使用 Builder 模式\n🚀 灵活的配置方式", textAlignment: .left)
            .button("太棒了！", style: .primary) { dismiss in
                print("用户觉得很棒")
                dismiss(nil)
            }
            .button("关闭", style: .cancel) { dismiss in
                print("用户关闭了弹窗")
                dismiss(nil)
            }
            .onDismiss {
                print("弹窗已关闭")
            }
            .present(from: self)
    }

    @objc private func showLongContentAlert() {
        let longContent = """
        这是一段超长的内容文本，用来测试 AlertView 组件库的内容适配能力。

        🔍 测试内容包括：
        • 自动换行处理
        • 边距自适应

        📱 适配场景：
        1. iPhone SE 小屏幕设备
        2. iPhone 14 Pro Max 大屏幕
        3. iPad 平板设备

        💡 技术特点：
        - 使用 UIStackView 管理布局
        - setCustomSpacing 精确控制间距
        - 插件化架构设计
        """

        AlertViewController.builder()
            .type(.alert)
            .title("长内容测试")
            .content(longContent, textAlignment: .left)
            .button("了解了", style: .primary) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    @objc private func showSheetTests() {
        showActionSheet(title: "Sheet 模式测试",
                       message: "选择要测试的 Sheet 场景",
                       actions: [
                           ("基础 Sheet", .default, { self.showBasicSheet() }),
                           ("长内容 Sheet", .default, { self.showLongContentSheet() }),
                           ("多按钮 Sheet", .default, { self.showMultiButtonSheet() })
                       ])
    }

    private func showBasicSheet() {
        AlertViewController.builder()
            .type(.sheet)
            .title("Sheet 弹窗")
            .content("这是从底部滑入的 Sheet 样式弹窗，适合展示操作选项和详细信息。")
            .button("主要操作", style: .primary) { dismiss in
                print("主要操作")
                dismiss(nil)
            }
            .button("取消", style: .cancel) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    private func showLongContentSheet() {
        let content = """
        Sheet 模式长内容测试

        📋 Sheet 的特点：
        • 从底部滑入动画
        • 更适合移动端操作
        • 可以容纳更多内容
        • 支持滚动显示

        🎨 设计理念：
        遵循 iOS 人机界面指南，提供符合用户习惯的交互体验。
        """

        AlertViewController.builder()
            .type(.sheet)
            .title("长内容 Sheet 测试")
            .content(content, textAlignment: .left)
            .button("明白了", style: .primary) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    private func showMultiButtonSheet() {
        AlertViewController.builder()
            .type(.sheet)
            .title("多按钮操作")
            .content("这个 Sheet 包含多个操作按钮。")
            .button("编辑", style: .default) { dismiss in
                print("编辑")
                dismiss(nil)
            }
            .button("复制", style: .default) { dismiss in
                print("复制")
                dismiss(nil)
            }
            .button("删除", style: .destructive) { dismiss in
                print("删除")
                dismiss(nil)
            }
            .button("取消", style: .cancel) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    @objc private func showEdgeCases() {
        showActionSheet(title: "边界情况测试",
                       message: "测试各种特殊情况",
                       actions: [
                           ("只有标题", .default, { self.showTitleOnlyAlert() }),
                           ("只有内容", .default, { self.showContentOnlyAlert() }),
                           ("只有按钮", .default, { self.showButtonOnlyAlert() })
                       ])
    }

    private func showTitleOnlyAlert() {
        AlertViewController.builder()
            .type(.alert)
            .title("只有标题的弹窗")
            .button("确定", style: .primary) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    private func showContentOnlyAlert() {
        AlertViewController.builder()
            .type(.alert)
            .content("这个弹窗只有内容，没有标题。")
            .button("确定", style: .primary) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    private func showButtonOnlyAlert() {
        AlertViewController.builder()
            .type(.alert)
            .button("单独按钮", style: .primary) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    @objc private func showInputAlert() {
        var inputText = ""

        AlertViewController.builder()
            .type(.alert)
            .title("输入信息")
            .content("请输入您的姓名:")
            .textField("请输入姓名...", onTextChanged: { text in
                inputText = text
            })
            .button("确定", style: .primary) { dismiss in
                if inputText.isEmpty {
                    print("用户未输入任何内容")
                } else {
                    print("用户输入了: \(inputText)")
                }
                dismiss(nil)
            }
            .button("取消", style: .cancel) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    @objc private func showMultiInputSheet() {
        var nameInput = ""
        var emailInput = ""

        AlertViewController.builder()
            .type(.sheet)
            .title("用户注册")
            .content("请填写以下信息完成注册:")
            .textField("请输入用户名...", onTextChanged: { text in
                nameInput = text
            })
            .textField("请输入邮箱...", onTextChanged: { text in
                emailInput = text
            })
            .button("注册", style: .primary) { dismiss in
                if nameInput.isEmpty || emailInput.isEmpty {
                    print("请填写完整信息")
                } else {
                    print("注册信息 - 用户名: \(nameInput), 邮箱: \(emailInput)")
                }
                dismiss(nil)
            }
            .button("取消", style: .cancel) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }

    @objc private func showCustomViewAlert() {
        AlertViewController.builder()
            .type(.alert)
            .customView(spacing: 20) { container, _ in
                let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
                imageView.tintColor = .systemGreen
                imageView.contentMode = .scaleAspectFit
                container.addSubview(imageView)

                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: container.topAnchor),
                    imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: 60),
                    imageView.heightAnchor.constraint(equalToConstant: 60),
                    imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
                ])
            }
            .title("操作成功")
            .content("您的操作已成功完成！")
            .button("好的", style: .primary) { dismiss in
                dismiss(nil)
            }
            .present(from: self)
    }
}

extension ViewController {
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   confirmTitle: String = "确定",
                   confirmAction: (() -> Void)? = nil) {
        showActionAlert(title: title,
                        message: message,
                        actions: [(confirmTitle, .primary, confirmAction)])
    }

    func showConfirmDialog(title: String? = nil,
                           message: String? = nil,
                           confirmTitle: String = "确定",
                           cancelTitle: String = "取消",
                           confirmAction: (() -> Void)? = nil,
                           cancelAction: (() -> Void)? = nil) {
        showActionAlert(title: title,
                        message: message,
                        actions: [(cancelTitle, .cancel, cancelAction),
                                  (confirmTitle, .primary, confirmAction)])
    }

    func showDestructiveDialog(title: String? = nil,
                               message: String? = nil,
                               destructiveTitle: String = "删除",
                               cancelTitle: String = "取消",
                               destructiveAction: (() -> Void)? = nil,
                               cancelAction: (() -> Void)? = nil) {
        showActionAlert(title: title,
                        message: message,
                        actions: [(cancelTitle, .cancel, cancelAction),
                                  (destructiveTitle, .destructive, destructiveAction)])
    }
    
    func showSuccessAlert(message: String, confirmTitle: String = "好的", confirmAction: (() -> Void)? = nil) {
        showAlert(title: "成功", message: message, confirmTitle: confirmTitle, confirmAction: confirmAction)
    }

    func showErrorAlert(message: String, confirmTitle: String = "我知道了", confirmAction: (() -> Void)? = nil) {
        showAlert(title: "错误", message: message, confirmTitle: confirmTitle, confirmAction: confirmAction)
    }

    func showWarningAlert(message: String, confirmTitle: String = "我知道了", confirmAction: (() -> Void)? = nil) {
        showAlert(title: "警告", message: message, confirmTitle: confirmTitle, confirmAction: confirmAction)
    }
}

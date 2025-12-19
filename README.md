# MSAlertView

[![Version](https://img.shields.io/cocoapods/v/MSAlertView.svg?style=flat)](https://cocoapods.org/pods/MSAlertView)
[![License](https://img.shields.io/cocoapods/l/MSAlertView.svg?style=flat)](https://cocoapods.org/pods/MSAlertView)
[![Platform](https://img.shields.io/cocoapods/p/MSAlertView.svg?style=flat)](https://cocoapods.org/pods/MSAlertView)

一个灵活的插件化 AlertView 组件库，支持 Alert 和 Sheet 两种展示模式，提供 Builder 模式进行链式配置。

## 特性

- 插件化架构，易于扩展
- 支持 Alert（居中弹窗）和 Sheet（底部滑入）两种模式
- Builder 模式，链式调用配置
- 支持自定义标题、内容、按钮、输入框
- 支持自定义视图插件
- 流畅的弹簧动画效果
- 键盘自动适配
- 背景点击关闭、下滑手势关闭
- 触感反馈（Haptic Feedback）

## 要求

- iOS 13.0+
- Swift 5.0+

## 安装

MSAlertView 可通过 [CocoaPods](https://cocoapods.org) 安装，在 Podfile 中添加：

```ruby
pod 'MSAlertView'
```

然后执行：

```bash
pod install
```

## 使用方法

### 导入模块

```swift
import MSAlertView
```

### 基础 Alert

```swift
AlertViewController.alert(title: "提示", message: "这是一条提示信息")
    .button("确定", style: .primary) { dismiss in
        print("用户点击了确定")
        dismiss(nil)
    }
    .present(from: self)
```

### 确认对话框

```swift
AlertViewController.alert(title: "确认操作", message: "您确定要执行此操作吗？")
    .button("取消", style: .cancel) { dismiss in
        dismiss(nil)
    }
    .button("确定", style: .primary) { dismiss in
        print("用户确认了操作")
        dismiss(nil)
    }
    .present(from: self)
```

### Action Sheet

```swift
AlertViewController.sheet(title: "选择操作", message: "请选择您要执行的操作")
    .button("编辑", style: .default) { dismiss in
        print("选择了编辑")
        dismiss(nil)
    }
    .button("分享", style: .default) { dismiss in
        print("选择了分享")
        dismiss(nil)
    }
    .button("删除", style: .destructive) { dismiss in
        print("选择了删除")
        dismiss(nil)
    }
    .button("取消", style: .cancel) { dismiss in
        dismiss(nil)
    }
    .present(from: self)
```

### 带输入框的 Alert

```swift
var inputText = ""

AlertViewController.builder()
    .type(.alert)
    .title("输入信息")
    .content("请输入您的姓名:")
    .textField("请输入姓名...", onTextChanged: { text in
        inputText = text
    })
    .button("确定", style: .primary) { dismiss in
        print("用户输入了: \(inputText)")
        dismiss(nil)
    }
    .button("取消", style: .cancel) { dismiss in
        dismiss(nil)
    }
    .present(from: self)
```

### 多输入框 Sheet

```swift
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
        print("用户名: \(nameInput), 邮箱: \(emailInput)")
        dismiss(nil)
    }
    .button("取消", style: .cancel) { dismiss in
        dismiss(nil)
    }
    .present(from: self)
```

### 自定义视图

```swift
AlertViewController.builder()
    .type(.alert)
    .customView(spacing: 20) { container, plugin in
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
```

### 自定义样式

```swift
AlertViewController.builder()
    .type(.alert)
    .title("自定义标题", font: .systemFont(ofSize: 20, weight: .bold), textColor: .systemPurple)
    .content("自定义内容文本", font: .systemFont(ofSize: 14), textColor: .secondaryLabel, textAlignment: .left)
    .contentMargins(top: 30, left: 20, bottom: 30, right: 20)
    .cornerRadius(alert: 20)
    .backgroundOpacity(0.6)
    .backgroundDismiss(true)
    .button("确定", style: .primary) { dismiss in
        dismiss(nil)
    }
    .onDismiss {
        print("弹窗已关闭")
    }
    .present(from: self)
```

## 按钮样式

| 样式 | 说明 | 外观 |
|------|------|------|
| `.default` | 默认样式 | 蓝色文字 + 蓝色边框 |
| `.primary` | 主要操作 | 白色文字 + 蓝色背景 |
| `.destructive` | 危险操作 | 红色文字 + 红色边框 |
| `.cancel` | 取消操作 | 灰色文字 + 灰色背景 |

## Builder 配置项

| 方法 | 说明 | 默认值 |
|------|------|--------|
| `type(_:)` | 设置展示类型 (.alert / .sheet) | .alert |
| `title(_:font:textColor:textAlignment:)` | 添加标题 | - |
| `content(_:font:textColor:textAlignment:)` | 添加内容 | - |
| `button(_:style:action:)` | 添加按钮 | - |
| `textField(_:font:textColor:backgroundColor:onTextChanged:)` | 添加输入框 | - |
| `customView(spacing:setup:)` | 添加自定义视图 | - |
| `contentMargins(_:)` | 设置内容边距 | (24, 24, 24, 24) |
| `backgroundDismiss(_:)` | 点击背景是否关闭 | true |
| `swipeDismiss(_:)` | 下滑是否关闭 (Sheet) | true |
| `backgroundOpacity(_:)` | 背景遮罩透明度 | 0.5 |
| `maxWidth(_:)` | Alert 最大宽度 | 320 |
| `edgeSpacing(_:)` | Alert 边缘间距 | 32 |
| `cornerRadius(alert:sheet:)` | 圆角半径 | 16 |
| `sheetTopSpacing(_:)` | Sheet 顶部最小间距 | 100 |
| `onDismiss(_:)` | 关闭回调 | - |

## 插件架构

MSAlertView 采用插件化架构，所有 UI 组件都是插件：

- `AlertTitlePlugin` - 标题插件
- `AlertContentPlugin` - 内容插件
- `AlertButtonPlugin` - 按钮插件
- `AlertTextFieldPlugin` - 输入框插件
- `AlertBasePlugin` - 自定义插件基类

### 创建自定义插件

继承 `AlertBasePlugin` 创建自定义插件：

```swift
class MyCustomPlugin: AlertBasePlugin {

    override var pluginType: AlertPluginType { .custom }

    override func setupContent() {
        // 在 containerView 中添加自定义内容
        let label = UILabel()
        label.text = "自定义内容"
        containerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    override func pluginDidAppear() {
        // 插件显示后的动画
    }
}

// 使用自定义插件
AlertViewController.builder()
    .addPlugin(MyCustomPlugin())
    .button("确定", style: .primary) { dismiss in
        dismiss(nil)
    }
    .present(from: self)
```

## 示例项目

克隆仓库后，在 Example 目录下执行 `pod install`，然后运行示例项目查看更多用法。

```bash
cd Example
pod install
open MSAlertView.xcworkspace
```

## 作者

sanmu

## 许可证

MSAlertView 基于 MIT 许可证开源，详见 LICENSE 文件。

#
# Be sure to run `pod lib lint MSAlertView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSAlertView'
  s.version          = '0.1.0'
  s.summary          = '一个灵活的插件化 AlertView 组件库'

  s.description      = <<-DESC
MSAlertView 是一个基于插件化架构设计的 iOS AlertView 组件库。
支持 Alert 和 Sheet 两种展示模式，提供 Builder 模式进行链式配置。
特性：
- 插件化架构，易于扩展
- 支持自定义标题、内容、按钮、输入框等
- 支持自定义视图插件
- 流畅的动画效果
- 键盘自动适配
                       DESC

  s.homepage         = 'https://github.com/SONG808/msalert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'sanmu'
  s.source           = { :git => 'https://github.com/SONG808/msalert.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.0']

  s.source_files = 'MSAlertView/Classes/**/*'

  s.frameworks = 'UIKit'
end

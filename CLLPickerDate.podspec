#
#  Be sure to run `pod spec lint CLLPickerDate.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "CLLPickerDate"
  s.version      = "1.0.0"
  s.summary      = "CLLPickerDate"
  s.description  = <<-DESC
  模仿钉钉的一个日期时间选择器，可根据需求选择显示的components
                   DESC
  s.homepage     = "https://github.com/leocll/CLLPickerDate.git"
  s.license      = "MIT"
  s.author             = { "leocll" => "leocll@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/leocll/CLLPickerDate.git", :tag => "1.0.0" }
  s.source_files  = "CLLPickerDateDemo/CLLPickerDateDemo/CLLPickerDate/*"
  s.requires_arc = true
  s.frameworks = "UIKit"
end

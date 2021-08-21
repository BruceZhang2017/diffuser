source 'https://cdn.cocoapods.org/'
source 'https://github.com/TuyaInc/TuyaPublicSpecs.git'
use_modular_headers!
inhibit_all_warnings!
use_frameworks!

target 'TuyaAppSDKSample-iOS-Swift' do
  pod 'SVProgressHUD'
  pod 'TuyaSmartHomeKit'
  pod 'Then'
  pod 'SnapKit'
  pod 'Toaster'
  pod 'IQKeyboardManagerSwift'
  pod 'XCGLogger'
  pod "McPicker"
end

post_install do |installer|
  `cd TuyaAppSDKSample-iOS-Swift; [[ -f AppKey.swift ]] || cp AppKey.swift.default AppKey.swift;`
end


platform :ios, '10.0'
use_frameworks!
target 'DFApiDemo' do
  
  # 网络
  pod 'Moya', '~> 14.0'
  # 解析
  pod 'HandyJSON'
  # loading
  pod 'MBProgressHUD'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['SWIFT_VERSION'] = '5'
      end
    end
  end
  
end

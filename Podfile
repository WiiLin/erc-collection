# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'erc-collection' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire',              '5.2'
  pod "PromiseKit",             '8.1.1'
  pod 'SVProgressHUD',          '2.2.5'
  pod 'Kingfisher',             '7.6.2'
  pod 'SVGKit',                 '3.8.2'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end
  end
end

platform :ios, '13.0'
use_frameworks!

target 'MovieList' do

  pod 'AFDateHelper', '4.3.0'
  pod 'Shakuro.CommonTypes'

end

# Post Install "error: IB Designables: Failed to render and update auto layout ..." fix
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end

end
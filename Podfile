source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:SRGSSR/srgpodspecs-ios.git'

platform :ios, '8.0'
inhibit_all_warnings!

workspace 'SRGIntegrationLayerDataProvider'

# Will be inherited by all targets below
pod 'SRGIntegrationLayerDataProvider', :path => '.'
pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
pod 'SRGIntegrationLayerDataProvider/MediaPlayer/Analytics', :path => '.'

target 'SRGIntegrationLayerDataProvider' do
  target 'SRGIntegrationLayerDataProviderTests' do
    # Test target, inherit search paths only, not linking
    # For more information, see http://blog.cocoapods.org/CocoaPods-1.0-Migration-Guide/
    inherit! :search_paths

    # Target-specific dependencies
    pod 'OCMock', '~> 3.3.0'
    pod 'SRGIntegrationLayerDataProvider/Core', :path => '.'
    pod 'SRGIntegrationLayerDataProvider/MediaPlayer', :path => '.'
  end

  xcodeproj 'SRGIntegrationLayerDataProvider.xcodeproj'
end

target 'SRGIntegrationLayerDataProvider Demo' do
  pod 'SDWebImage', '~> 3.8.0'

  target 'SRGIntegrationLayerDataProvider DemoTests' do
    # Test target, inherit search paths only, not linking
    # For more information, see http://blog.cocoapods.org/CocoaPods-1.0-Migration-Guide/
    inherit! :search_paths

    # Target-specific dependencies
    pod 'KIF', '~> 3.4.0'
  end

  xcodeproj 'SRGIntegrationLayerDataProvider Demo/SRGIntegrationLayerDataProvider Demo'
end

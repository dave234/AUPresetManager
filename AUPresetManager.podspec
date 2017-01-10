#
# Be sure to run `pod lib lint AUPresetManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AUPresetManager'
  s.version          = '0.1.1'
  s.summary          = 'A class used to create presets for core audio\'s AUSampler'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Apple's esoteric format for the AUSampler audioUnit usually has to be created on a Mac.  Edited on the mac, with file references and all, then imported into an iOS project in the app bundle.  This class uses a skeleton file (created on a Mac), then is able to dynamically generate the AUPreset dictionary so that files can be loaded on the fly.
                       DESC

  s.homepage         = 'https://github.com/dave234/AUPresetManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dave234' => 'dave234@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/dave234/AUPresetManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AUPresetManager/Classes/**/*'
  
  s.resource_bundles = {
    'AUPresetManager' => ['AUPresetManager/Assets/*.aupreset']
  }
  s.frameworks = 'AudioToolbox'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

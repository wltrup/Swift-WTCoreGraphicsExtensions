#
# Be sure to run `pod lib lint WTCoreGraphicsExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WTCoreGraphicsExtensions'
  s.version          = '1.0.0'
  s.summary          = 'Useful extensions to CGPoint, CGVector, and CGGradient.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    A collection of useful extensions to CGPoint, CGVector, and CGGradient.
    If you need 2-dimensional vectors then you'll want this. Why? Because
    WTCoreGraphicsExtensions is a comprehensive suite of methods for two-dimensional
    vector manipulations, everything from addition of a vector to a point, to dot and
    cross products, to rotations, to finding projections, all extensively tested.
                       DESC

  s.homepage         = 'https://github.com/wltrup/Swift-WTCoreGraphicsExtensions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wagner Truppel' => 'trupwl@gmail.com' }
  s.source           = { :git => 'https://github.com/wltrup/Swift-WTCoreGraphicsExtensions.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WTCoreGraphicsExtensions/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WTCoreGraphicsExtensions' => ['WTCoreGraphicsExtensions/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'WTBinaryFloatingPointExtensions'
  s.dependency 'WTUIColorExtensions'
end

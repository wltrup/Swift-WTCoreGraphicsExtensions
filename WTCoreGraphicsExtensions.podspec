Pod::Spec.new do |s|
  s.name        = 'WTCoreGraphicsExtensions'
  s.version     = '1.0.2'
  s.summary     = 'Useful extensions to CGPoint, CGVector, and CGGradient.'
  s.description = <<-DESC
    A collection of useful extensions to CGPoint, CGVector, and CGGradient.
    If you need 2-dimensional vectors then you'll want this. Why? Because
    WTCoreGraphicsExtensions is a comprehensive suite of methods for two-dimensional
    vector manipulations, everything from addition of a vector to a point, to dot and
    cross products, to rotations, to finding projections, all extensively tested.
                       DESC
  s.homepage    = 'https://github.com/wltrup/Swift-WTCoreGraphicsExtensions'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.author      = { 'Wagner Truppel' => 'trupwl@gmail.com' }
  s.source      = { :git => 'https://github.com/wltrup/Swift-WTCoreGraphicsExtensions.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'WTCoreGraphicsExtensions/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'WTBinaryFloatingPointExtensions'
  s.dependency 'WTUIColorExtensions'
end

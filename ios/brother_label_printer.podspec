#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint brother_label_printer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'brother_label_printer'
  s.version          = '0.0.1'
  s.summary          = 'Brother label printing plugin by Bridges'
  s.description      = <<-DESC
Brother label printing plugin by Bridges
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.preserve_paths = 'BRLMPrinterKit.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework BRLMPrinterKit' }
  s.vendored_frameworks = 'BRLMPrinterKit.framework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

#
# Be sure to run `pod lib lint OttuCheckout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OttuCheckout'
  s.version          = '0.1.1'
  s.summary          = 'OttuCheckout it`s a simple apple pay integration SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'OttuCheckout is an awesome pod aimed to make your life easier aroud Apple Pay'
                       DESC

  s.homepage         = 'https://gitlab.com/yanenkopetr1481/ottucheckout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yanenko Petr' => 'yanenkopetr1841@gmail.com' }
  s.source           = { :git => 'https://gitlab.com/yanenkopetr1481/ottucheckout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.platforms = {
      "ios": "13.0"
  }

  s.source_files = 'Source/**/*.swift'
end

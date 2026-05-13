#
# Be sure to run `pod lib lint PodLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PodLib'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PodLib.'

  s.description      = 'Add long description of the pod here.'
  s.homepage         = 'https://codeup.aliyun.com/6038a3e4d4d1946203776b3c/CleanLibs/PodLib'
  # s.homepage         = 'https://github.com/${USER_NAME}/PodLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  # s.source           = { :git => 'https://github.com/${USER_NAME}/PodLib.git', :tag => s.version.to_s }
  s.source           = { :git => 'https://codeup.aliyun.com/6038a3e4d4d1946203776b3c/CleanLibs/PodLib.git', :tag => s.version.to_s }
  
  s.static_framework = true
  s.requires_arc = true
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9']

  s.source_files = 'Source/**/*.swift'
  
  # s.default_subspec = 'Main'
  # s.subspec 'Base' do |sp|
  #   sp.source_files = 'Source/Base/*.swift'
  # end
  # s.subspec 'Main' do |sp|
  #   sp.dependency 'PodLib/Base'
  #   sp.source_files = 'Source/Main/*.swift'
  # end
  
  s.resource_bundles = {
    'PodLib' => ['Source/Resource/**/*']
  }

  # s.public_header_files = 'Source/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'Alamofire', '~> 2.3'
end

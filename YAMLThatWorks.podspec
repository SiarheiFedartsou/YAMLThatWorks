#
# Be sure to run `pod lib lint YAMLThatWorks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "YAMLThatWorks"
  s.version          = "0.0.2"
  s.summary          = "Objective C wrapper around yaml-cpp"
  s.description      = "Objective C YAML Parser implemented as a wrapper around yaml-cpp"

  s.homepage         = "https://github.com/SiarheiFedartsou/YAMLThatWorks"
  s.license          = 'MIT'
  s.author           = { "Siarhei Fiedartsou" => "siarhei.fedartsou@gmail.com" }
  s.source           = { :git => "https://github.com/SiarheiFedartsou/YAMLThatWorks.git", :tag => s.version.to_s, :submodules => true  }

  s.ios.deployment_target = '7.0'

  s.source_files = 'YAMLThatWorks/Classes/**/*{.cpp,.h,.m,.mm}'
  s.exclude_files = ['YAMLThatWorks/Classes/yaml-cpp/test/**/*', 'YAMLThatWorks/Classes/yaml-cpp/util/**/*']
  s.library = 'c++'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/YAMLThatWorks/yaml-cpp/include"' }
  s.header_mappings_dir = 'YAMLThatWorks/Classes/yaml-cpp/include'

  s.public_header_files = 'YAMLThatWorks/Classes/YATWSerialization.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

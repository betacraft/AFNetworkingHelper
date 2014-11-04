#
# Be sure to run `pod lib lint AFNetworkingHelper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "AFNetworkingHelper"
s.version          = "0.1.1"
s.summary          = "A short wrapper written over AFNetworking library."
s.description      = <<-DESC
This is a custom wrapper over the most amazing networking library for objective C, AFNetworking that we use extensively inside RainingClouds.
DESC
s.homepage         = "https://github.com/RainingClouds/AFNetworkingHelper"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "Akshay Deo" => "akshay@rainingclouds.com" }
s.source           = { :git => "https://github.com/RainingClouds/AFNetworkingHelper.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/akshay_deo'

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'Pod/Classes'
#s.resources = 'Pod/Assets/*.png'

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'AFNetworking'
s.dependency 'MBProgressHUD'
s.dependency 'Reachability'

end
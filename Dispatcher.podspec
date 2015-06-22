#
# Be sure to run `pod lib lint Dispatcher.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Dispatcher"
  s.version          = "0.1.1"
  s.summary          = "Facebook Flux' Dispatcher rewritten in Swift"
  s.description      = <<-DESC
                       Facebook Flux' Dispatcher rewritten in Swift.
                       DESC
  s.homepage         = "https://github.com/mikker/Dispatcher"
  s.license          = 'MIT'
  s.author           = { "Mikkel Malmberg" => "mikkel@brnbw.com" }
  s.source           = { :git => "https://github.com/mikker/Dispatcher.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mikker'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Dispatcher' => ['Pod/Assets/*.png']
  }
end

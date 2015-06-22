Pod::Spec.new do |s|
  s.name             = "Dispatcher"
  s.version          = "0.1.1"
  s.license          = 'MIT'
  s.summary          = "Facebook Flux' Dispatcher rewritten in Swift"
  s.homepage         = "https://github.com/mikker/Dispatcher"
  s.authors          = { "Mikkel Malmberg" => "mikkel@brnbw.com" }
  s.source           = { :git => "https://github.com/mikker/Dispatcher.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mikker'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Pod/Classes/**/*'
  s.requires_arc = true
end

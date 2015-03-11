Pod::Spec.new do |s|

s.name     = 'SoundCloudAPI'

s.version  = '1.0'

s.summary  = 'SoundCloud API'

s.platform     = :ios

s.ios.deployment_target = '8.0'

s.license      = { :type => 'Apache License', :file => 'LICENSE' }

s.source_files = 'Sources/SoundCloudAPI/*.{h,m}'

s.source       = { :git => "https://github.com/antoninbiret/CocoaSoundCloudAPI.git", :tag => "1.0" }

s.requires_arc = false

s.framework  = "Foundation"

s.author   = { 'Soundcloud - Antonin Biret' => 'haprock@gmail.com' }

s.social_media_url   = "https://twitter.com/Antonin_brt"

s.homepage   = "https://github.com/antoninbiret/CocoaSoundCloudAPI"

s.dependency 'NXOAuth2Client', '~> 1.2'

end
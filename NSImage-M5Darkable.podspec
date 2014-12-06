Pod::Spec.new do |s|
  s.name = 'NSImage+M5Darkable'
  s.version = '1.0.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Adds choice to have particular NSImage draw in inverted colors when OS X is in the new Yosemite "dark mode."'
  s.description = 'Adds choice to have particular NSImage draw in inverted colors when OS X is in the new Yosemite "dark mode."'
  s.homepage = 'https://github.com/mhuusko5/NSImage-M5Darkable'
  s.social_media_url = 'https://twitter.com/mhuusko5'
  s.authors = { 'Mathew Huusko V' => 'mhuusko5@gmail.com' }
  s.source = { :git => 'https://github.com/mhuusko5/NSImage-M5Darkable.git', :tag => s.version.to_s }

  s.platform = :osx
  s.ios.deployment_target = '10.8'
  s.requires_arc = true
  s.frameworks = 'Cocoa', 'QuartzCore'
  
  s.source_files = '*.{h,m}'
end
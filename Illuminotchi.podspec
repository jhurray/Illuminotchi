Pod::Spec.new do |spec|
    spec.name             = 'Illuminotchi'
    spec.version          = '0.0.1'
    spec.license          = { :type => 'MIT' }
    spec.homepage         = 'https://github.com/jhurray/Illuminotchi'
    spec.authors          = { 'Jeff Hurray' => 'jhurray33@gmail.com' }
    spec.summary          = 'Theyre Watching'
    spec.source           = { :git => 'https://github.com/jhurray/Illuminotchi.git', :tag => spec.version.to_s }
    spec.source_files     = 'Illuminotchi/**'
    spec.social_media_url = 'https://twitter.com/jeffhurray'
    spec.platform     = :ios, '11.0'
    spec.requires_arc = true
    spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    spec.requires_arc     = true
end
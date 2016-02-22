Pod::Spec.new do |s|
  s.name             = 'FBAnnotationClustering'
  s.version          = '0.2.1'
  s.summary          = 'Clustering library for GoogleMaps iOS SDK maps'
  s.homepage         = 'https://github.com/ansinyutin/FBAnnotationClustering'
  s.screenshots      = 'https://raw.githubusercontent.com/infinum/FBAnnotationClustering/master/Images/example.png'
  s.license          = 'MIT'
  s.author           = { 'Filip Beć' => 'filip.bec@gmail.com' }
  s.source           = { :git => 'https://github.com/infinum/FBAnnotationClustering.git', :tag => '0.2.1' }
  s.social_media_url = 'https://twitter.com/FilipBec'
  s.requires_arc     = true

  s.platform                = :ios, '6.0'
  s.ios.deployment_target   = '6.0'
  s.source_files            = 'FBAnnotationClustering'
  s.public_header_files     = 'FBAnnotationClustering/*.h'

  s.frameworks = 'CoreLocation', 'MapKit'
end

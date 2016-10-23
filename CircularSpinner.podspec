Pod::Spec.new do |s|

  s.name         = 'CircularSpinner'
  s.version      = '1.2.0'
  s.summary      = 'A Beautiful fullscreen Circular Spinner, very useful for determinate or indeterminate task.'
  s.description  = <<-DESC
  A Beautiful fullscreen Circular Spinner, very useful for determinate or indeterminate task. You can use it as activity indicator during loading.
                   DESC
  s.homepage     = "https://github.com/taglia3/CircularSpinner"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source_files = 'CircularSpinner/**/*' 
  s.resource_bundles = {
    'CircularSpinner' => ['CircularSpinner/Assets/*.png']
  }
  s.author           = { "taglia3" => "the.taglia3@gmail.com" }
  s.source       = { :git => "https://github.com/taglia3/CircularSpinner.git", :tag => "#{s.version}" }
  s.social_media_url = 'https://twitter.com/taglia3'
  s.frameworks        = 'UIKit'
  s.ios.deployment_target = '8.0'
end

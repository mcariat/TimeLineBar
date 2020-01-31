Pod::Spec.new do |s|
  s.name             = 'TimeLineBar'
  s.version          = '0.1.3'
  s.summary          = 'Time line bar to seek in scroll view with waveform.'
 
  s.description      = <<-DESC
Time line bar to seek in scroll view with waveform. Used to replace basic seek bar.
                       DESC
 
  s.homepage         = 'https://github.com/mcariat/TimeLineBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mCariat' => 'matthieu.cariat@imerir.com' }
  s.source           = { :git => 'https://github.com/mcariat/TimeLineBar.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'TimeLineBar/TimeLineBar.swift'
 
end
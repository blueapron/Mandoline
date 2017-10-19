Pod::Spec.new do |s|
  s.name             = 'Mandoline'
  s.version          = '0.1.0'
  s.summary          = 'A scrolling horizontal picker view.'

  s.description      = <<-DESC
    The HorizontalScrollingPickerView is a UIview that provides a smooth "picking" interface.
    In order to get the most out of it, a cell should implement the Selectable protocol that dictates whether a cell `isSelectable`.
                       DESC

  s.homepage         = 'https://github.com/blueapron/Mandoline'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ag' => 'anat.gilboa@blueapron.com' }
  s.source           = { :git => 'https://github.com/blueapron/Mandoline.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Mandoline/Classes/**/*'

  s.dependency 'SnapKit', '~> 3.2.0'
end

Pod::Spec.new do |s|
  s.name         = "YKFile"
  s.version      = "0.0.1"
  s.summary      = "Library to deal the file-path as an object"
  s.license      = { :type => 'WTFPL', :file => 'LICENSE' }
  s.homepage     = "https://github.com/GeneralD/YKFile.git"
  s.source       = { :git => "https://github.com/GeneralD/YKFile.git", :tag => "0.0.1" }
  s.author       = { "yumenosuke-k" => "yumejustice@gmail.com" }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
end

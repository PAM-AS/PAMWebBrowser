Pod::Spec.new do |s|
  s.name         = 'PAMWebBrowser'
  s.version      = '0.1.18'
  s.license      =  'MIT'
  s.homepage     = 'https://github.com/PAM-AS/PAMWebBrowser'
  s.authors      =  {'Thomas S. Nielsen' => 'thomas@pam.no'}
  s.summary      = 'Web browser with address bar'

# Source Info
  s.platform     =  :ios, '7.0'
  s.source       =  {:git => 'https://github.com/PAM-AS/PAMWebBrowser.git', :tag => '#{s.version}' }
  s.source_files = 'Classes/*.{h,m}'
  s.resources    = 'assets/*.storyboard' 

  s.requires_arc = true
  
# Pod 

  s.dependency 'SAMCategories'
  
end

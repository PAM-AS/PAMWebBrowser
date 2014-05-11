Pod::Spec.new do |s|
  s.name         = 'PAMWebBrowser'
  s.version      = '0.1.11'
  s.license      =  'MIT'
  s.homepage     = 'https://github.com/PAM-AS/WebBrowser'
  s.authors      =  {'Thomas S. Nielsen' => 'thomas@pam.no'}
  s.summary      = 'Web browser with address bar'

# Source Info
  s.platform     =  :ios, '7.0'
  s.source       =  {:git => 'https://github.com/PAM-AS/WebBrowser', :tag => 'v#{s.version}' }
  s.source_files = 'Classes/*.{h,m}'
  s.resources    = 'assets/*.storyboard' 

  s.requires_arc = true
  
# Pod 

  s.dependency 'SAMCategories'
  
end
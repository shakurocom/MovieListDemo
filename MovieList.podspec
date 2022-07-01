#
#

Pod::Spec.new do |s|
    s.name             = 'MovieList'
    s.version          = '1.0.0'
    s.summary          = 'UI component for iOS'
    s.homepage         = 'https://github.com/shakurocom/MovieListDemo'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.authors          = {'Vlad Onipchenko' => 'vonipchenko@shakuro.com'}
    s.source           = { :git => 'https://github.com/shakurocom/MovieListDemo.git', :tag => s.version }
    s.source_files     = 'MovieListControl/Source/**/**'
    s.resource_bundles = {'MovieList' => ['MovieListControl/Resources/**/*']}

    s.swift_version    = '5.0'
    s.ios.deployment_target = '13.0'

    s.dependency 'Shakuro.CommonTypes', '~>1.1.0'
    s.dependency 'AFDateHelper', '~>4.3.0'

end


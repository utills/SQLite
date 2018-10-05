#
# Be sure to run `pod lib lint SQLite.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SQLite'
    s.version          = '0.1.7'
    s.summary          = 'A framework for SQLite database written in Swift '

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    'A framework to facilitate developers to use SQLite database with convenience'
                       DESC

    s.homepage         = 'https://github.com/ervivek40/SQLite'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Vivek Kumar' => 'ervivek40@gmail.com' }
    s.source           = { :git => 'https://github.com/ervivek40/SQLite.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    s.source_files = 'SQLite/Classes/**/*'

    ###Targets###
    s.watchos.deployment_target = '2.0'
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.13'
    s.tvos.deployment_target = '9.0'

    s.swift_version = '4.0'

end

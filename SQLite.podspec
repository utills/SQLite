#
# Be sure to run `pod lib lint SQLite.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SQLite'
    s.version          = '0.1.3'
    s.summary          = 'A wrapper to facilitate developers to use SQLite database in swift easily'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    'A wrapper to facilitate developers to use SQLite database in swift with ready to use class'
                       DESC

    s.homepage         = 'https://github.com/ervivek40/SQLite'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Vivek Kumar' => 'ervivek40@gmail.com' }
    s.source           = { :git => 'https://github.com/ervivek40/SQLite.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.source_files = 'SQLite/Classes/**/*'

    # s.resource_bundles = {
    #   'SQLite' => ['SQLite/Assets/*.png']
    # }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
end

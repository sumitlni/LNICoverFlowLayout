#
# Be sure to run `pod lib lint LNICoverFlowLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LNICoverFlowLayout"
  s.version          = "1.0.0"
  s.summary          = "Swift-only implementation of YRCoverFlowLayout. Also supports CocoaPods."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Re-implemented YRCoverFlowLayout in Swift 3.

Supports CocoaPods. You can also drag & drop the single Swift file but using CocoaPods is recommended.
                       DESC

  s.homepage         = "https://github.com/sumitlni/LNICoverFlowLayout"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Sumit Chawla" => "sumit@loudnoiseinc.com" }
  s.source           = { :git => "https://github.com/sumitlni/LNICoverFlowLayout.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/LoudNoiseInc'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LNICoverFlowLayout/Classes/**/*'

  s.frameworks = 'UIKit'
end

#
# Be sure to run `pod lib lint iPicUploader.podspec' to validate before submitting.
#
# Podspec Syntax Reference http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iPicUploader'
  s.version          = '1.1.0'
  s.summary          = 'iPicUploader could help you to upload images by iPic on macOS.'
  s.description      = <<-DESC
iPic could automatically upload images and save Markdown links on macOS.

- Upload images by drag & drop.
- Upload images by services with shortcut [Command + U].
- Upload copied images with shortcut [Shift + Command + U].
- Support Imgur, Flickr, Amazon S3 and other image hosts.
- Support image link of Markdown format.

Video introduction: http://toolinbox.net/en/iPic/

In the same time, iPic open the ability to upload images. It means if your App also needs to upload images, you don't need to build from scratch. Just use iPicUploader, your App could also upload images to Imgur, Flickr, Amazon S3 and other image hosts.

iPicUploader also includes a full example. It shows how to use iPicUploader to upload images by drag and drop, by selecting image files, and by paste to upload images. You will feel easy to start.
                       DESC

  s.homepage         = 'https://github.com/toolinbox/iPicUploader.git'
  s.screenshots     = 'https://farm9.staticflickr.com/8109/28818056193_11bb44d5e0_o.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jason' => 'iToolinbox@gmail.com' }
  s.source           = { :git => 'https://github.com/toolinbox/iPicUploader.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hereisjason'

  s.osx.deployment_target = "10.9"

  s.source_files = 'iPicUploader/Classes/**/*'
end

# iPic

![](https://farm8.staticflickr.com/7322/28018346695_f1461c7a09_o.jpg)

iPic could automatically upload images and save Markdown links on macOS.

- Upload images by drag & drop.
- Upload images by services with shortcut [Command + U].
- Upload copied images with shortcut [Shift + Command + U].
- Support Imgur, Flickr, Amazon S3 and other image hosts.
- Support image link of Markdown format.
- [Video introduction](http://toolinbox.net/en/iPic/)

[Download iPic](https://itunes.apple.com/app/id1101244278?ls=1&mt=12) and have a try.

# iPicUploader

iPic opens the ability to upload images. It means if your App also needs to upload images, no need to build from scratch. Just use iPicUploader, your App could also upload images to Imgur, Flickr, Amazon S3 and other image hosts.

## iPicUploader Usage

Upload image file:

```swift
let imageFilePath = "/Path/to/the/pic.jpg"

iPic.uploadImage(imageFilePath, handler: { (imageLink, error) in    
	if let imageLink = imageLink {
		// Image uploaded        
	   
	} else if let error = error {
		// Some error happened
	}
})

```

Upload image data:

```swift
let imageFilePath = "/Path/to/the/pic.jpg"
let imageData = NSData(contentsOfFile: imageFilePath)!

iPic.uploadImage(imageData, handler: { (imageLink, error) in    
	if let imageLink = imageLink {
		// Image uploaded        
	   
	} else if let error = error {
		// Some error happened
	}
})

```

Upload NSImage:

```swift
let imageFilePath = "/Path/to/the/pic.jpg"
let image = NSImage(contentsOfFile: imageFilePath)

iPic.uploadImage(image, handler: { (imageLink, error) in    
	if let imageLink = imageLink {
		// Image uploaded        
	   
	} else if let error = error {
		// Some error happened
	}
})

```


## iPicUploader Example

iPicUploader also includes a full example. You will feel easy to start. To run the example project, just clone current repository and open *iPicUploader.xcworkspace*.

Note: 

- As the demo needs to upload images by iPic, you need to [download iPic](http://toolinbox.net/html/DownloadiPicWithService.html) at first. 
- No worry, you will also be guided to download iPic in the example.
- The example already dealt with these cases:
  - If iPic wasn't installed, guide user to download.
  - If iPic wasn't running, launch iPic automatically.
  - If iPic is running but not compatible, guide user to download latest version.

Now, let's have a look how the example upload images.

### 1. Upload Images by Drag & Drop

![](https://farm9.staticflickr.com/8085/29362952261_29d4282e7d_o.gif)

As you can see, iPicUploader supports upload of multiple images at a time.

### 2. Upload Images by Select Images Files

![](https://farm9.staticflickr.com/8437/29408369616_bd961fc777_o.gif)

### 3. Upload Images by Copy Image and Paste

![](https://farm9.staticflickr.com/8533/29408372976_7b39f9898f_o.gif)

Beside copy image files, you can also copy the image in other Apps to upload.

## Requirements

As iPic runs on macOS 10.11 and newer version, iPicUploader also needs macOS 10.11+

## Installation

iPicUploader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "iPicUploader"
```

## License

iPicUploader is available under the MIT license.



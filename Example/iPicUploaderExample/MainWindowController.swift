//
//  MainWindowController.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa
import iPicUploader

class MainWindowController: NSWindowController {
  
  @IBOutlet weak var imageView: iPicImageView!
  
  dynamic var uploadResultString: NSMutableAttributedString = NSMutableAttributedString(string: "")
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    setWindowOnTop(true)
    
    imageView.state = .Normal
    imageView.uploadHandler = uploadHandler
    
//    NSOperationQueue.mainQueue().addOperationWithBlock { 
//      
//      //    let imag3FilePath = "/Users/jason/Downloads/avatar.jpeg"
//      let imageURL = NSURL(string: "https://www.bitgab.com/en/dashboard/img/av2.png")!
//      if let image = NSImage(contentsOfURL: imageURL) {
//        //    if let image = NSImage(contentsOfFile: imageFilePath) {
//        self.imageView.image = image
//      }
//    }

//    test()
  }
  
  // MARK: Helper
  
  private func uploadHandler(imageLink: String?, error: NSError?) {
    NSOperationQueue.mainQueue().addOperationWithBlock {
      if let imageLink = imageLink {
        self.appendLink(imageLink)
        
      } else if let error = error {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Failed to Upload", comment: "Title")
        alert.informativeText = error.localizedDescription
        
        if let window = self.window {
          alert.beginSheetModalForWindow(window, completionHandler: nil)
        }
      }
    }
  }
  
  private func appendLink(link: String) {
    let fontAttr = [NSFontAttributeName: NSFont.systemFontOfSize(NSFont.systemFontSize() - 2)]
    let resultStr = NSMutableAttributedString(string: link, attributes: fontAttr)
    let attrs = [NSLinkAttributeName: NSString(string: link)]
    resultStr.addAttributes(attrs, range: NSRange(0..<resultStr.length))
    
    // TODO Update the logic to refresh NSTextView
    let copiedString = NSMutableAttributedString(string: "")
    copiedString.appendAttributedString(uploadResultString)
    copiedString.appendAttributedString(resultStr)
    copiedString.appendAttributedString(NSAttributedString(string: "\n"))
    uploadResultString = copiedString
  }
  
  private func test() {
    let fileList = [
      "/Users/jason/Downloads/1.jpg",
      //      "/Users/jason/Downloads/TestSource/中文.jpg",
      //      "/Users/jason/Downloads/TestSource/中文ファ한국~!@#$%^&*()_+`=[]{}|;,.&%< >'.jpg",
      //      "/Users/jason/Downloads/TestSource/Big.png",
    ]
    for imageFilePath in fileList {
      iPic.uploadImage(imageFilePath) { (imageLink, error) in
        var result = (NSURL(string: imageFilePath)?.lastPathComponent ?? imageFilePath) + " "
        if let imageLink = imageLink {
          result += imageLink
        } else if let error = error {
          result += error.localizedDescription
        }
        print(result)
      }
    }
  }
  
  private func setWindowOnTop(onTop: Bool) {
    NSApp.activateIgnoringOtherApps(onTop)
    window?.hidesOnDeactivate = !onTop
    
    let level = onTop ? CGWindowLevelKey.FloatingWindowLevelKey : CGWindowLevelKey.BaseWindowLevelKey
    window?.level = Int(CGWindowLevelForKey(level))
  }
}
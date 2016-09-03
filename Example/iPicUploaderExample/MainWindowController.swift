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
  @IBOutlet var resultTextView: NSTextView!
  
  var uploadedIndex = 0
  
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    //setWindowOnTop(true)
    
    imageView.state = .Normal
    imageView.uploadHandler = uploadHandler
    
    let attrString = NSAttributedString(string: NSLocalizedString("Image Links:", comment: "Title"))
    resultTextView.textStorage?.appendAttributedString(attrString)
  }
  
  // MARK: Action
  
  @IBAction func selectImageFiles(sender: NSButton!) {
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    openPanel.allowsMultipleSelection = true
    openPanel.prompt = NSLocalizedString("Select", comment: "Open Panel")
    
    openPanel.beginSheetModalForWindow(self.window!) { (response) in
      if response == NSFileHandlingPanelOKButton {
        for url in openPanel.URLs {
          if let imageFilePath = url.path {
            NSOperationQueue.mainQueue().addOperationWithBlock {
              self.imageView.state = .Uploading
            }
            iPic.uploadImage(imageFilePath, handler: self.uploadHandler)
          }
        }
      }
    }
  }
  
  @IBAction func pasteImages(sender: NSButton!) {
    let imageList = iPicUploadHelper.generateImageDataListFrom(NSPasteboard.generalPasteboard())
    guard !imageList.isEmpty else {
      let message = NSLocalizedString("Failed to Upload", comment: "Title")
      let information = "No image in pasteboard."
      self.showAlert(message, information: information)
      
      return
    }
    
    for imageData in imageList {
      self.imageView.state = .Uploading
      iPic.uploadImage(imageData, handler: uploadHandler)
    }
  }
  
  // MARK: Helper
  
  private func uploadHandler(imageLink: String?, error: NSError?) {
    NSOperationQueue.mainQueue().addOperationWithBlock {
      if let imageLink = imageLink {
        self.imageView.state = .Uploaded
        if let imageURL = NSURL(string: imageLink) {
          self.imageView.image = NSImage(contentsOfURL: imageURL)
        }
        
        self.appendLink(imageLink)        
        
      } else if let error = error {
        self.imageView.state = .Normal
        
        let message = NSLocalizedString("Failed to Upload", comment: "Title")
        let information = error.localizedDescription
        
        if error == iPicUploadError.iPicNotInstalled || error == iPicUploadError.iPicIncompatible {
          let alert = NSAlert()
          alert.messageText = message
          alert.informativeText = information
          
          alert.addButtonWithTitle(NSLocalizedString("Download iPic", comment: "Title"))
          alert.addButtonWithTitle(NSLocalizedString("Cancel", comment: "Title"))
          
          alert.beginSheetModalForWindow(self.window!, completionHandler: { (response) in
            if response == NSAlertFirstButtonReturn {
              if let url = NSURL(string: iPic.iPicDownloadLink) {
                NSWorkspace.sharedWorkspace().openURL(url)
              }
            }
          })
        } else {
          self.showAlert(message, information: information)
        }
      }
    }
  }
  
  private func appendLink(link: String) {
    let fontAttr = [NSFontAttributeName: NSFont.systemFontOfSize(NSFont.systemFontSize() - 2)]
    let resultStr = NSMutableAttributedString(string: link, attributes: fontAttr)
    let attrs = [NSLinkAttributeName: NSString(string: link)]
    resultStr.addAttributes(attrs, range: NSRange(0..<resultStr.length))
    
    uploadedIndex += 1
    resultTextView.textStorage?.appendAttributedString(NSAttributedString(string: "\n\(uploadedIndex): "))
    resultTextView.textStorage?.appendAttributedString(resultStr)
    resultTextView.scrollToEndOfDocument(self)
  }
  
  private func showAlert(message: String, information: String) {
    let alert = NSAlert()
    alert.messageText = message
    alert.informativeText = information
    
    if let window = self.window {
      alert.beginSheetModalForWindow(window, completionHandler: nil)
    }
  }
  
  private func setWindowOnTop(onTop: Bool) {
    NSApp.activateIgnoringOtherApps(onTop)
    window?.hidesOnDeactivate = !onTop
    
    let level = onTop ? CGWindowLevelKey.FloatingWindowLevelKey : CGWindowLevelKey.BaseWindowLevelKey
    window?.level = Int(CGWindowLevelForKey(level))
  }
}
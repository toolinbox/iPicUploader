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
    
    imageView.state = .Normal
    imageView.uploadHandler = uploadHandler
    
    let attrString = NSAttributedString(string: NSLocalizedString("Image Links:", comment: "Title"))
    resultTextView.textStorage?.append(attrString)
  }
  
  // MARK: Action
  
  @IBAction func selectImageFiles(_ sender: NSButton!) {
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    openPanel.allowsMultipleSelection = true
    openPanel.prompt = NSLocalizedString("Select", comment: "Open Panel")
    
    openPanel.beginSheetModal(for: self.window!) { (response) in
      if response.rawValue == NSFileHandlingPanelOKButton {
        for url in openPanel.urls {
          OperationQueue.main.addOperation {
            self.imageView.state = .Uploading
          }
          iPic.uploadImage(imageFilePath: url.path, handler: self.uploadHandler)
        }
      }
    }
  }
  
  @IBAction func pasteImages(_ sender: NSButton!) {
    let imageList = iPicUploadHelper.generateImageDataListFrom(NSPasteboard.general)
    guard !imageList.isEmpty else {
      let message = NSLocalizedString("Failed to Upload", comment: "Title")
      let information = "No image in pasteboard."
      self.showAlert(message, information: information)
      
      return
    }
    
    for imageData in imageList {
      self.imageView.state = .Uploading
      iPic.uploadImage(imageData: imageData, handler: uploadHandler)
    }
  }
  
  // MARK: Helper
  
  fileprivate func uploadHandler(_ imageLink: String?, error: NSError?) {
    OperationQueue.main.addOperation {
      if let imageLink = imageLink {
        self.imageView.state = .Uploaded
        if let imageURL = URL(string: imageLink) {
          self.imageView.image = NSImage(contentsOf: imageURL)
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
          
          alert.addButton(withTitle: NSLocalizedString("Download iPic", comment: "Title"))
          alert.addButton(withTitle: NSLocalizedString("Cancel", comment: "Title"))
          
          alert.beginSheetModal(for: self.window!, completionHandler: { (response) in
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
              if let url = URL(string: iPic.iPicDownloadLink) {
                NSWorkspace.shared.open(url)
              }
            }
          })
        } else {
          self.showAlert(message, information: information)
        }
      }
    }
  }
  
  fileprivate func appendLink(_ link: String) {
    let fontAttr = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: NSFont.systemFontSize - 2)]
    let resultStr = NSMutableAttributedString(string: link, attributes: fontAttr)
    let attrs = [NSAttributedString.Key.link: NSString(string: link)]
    resultStr.addAttributes(attrs, range: NSRange(0..<resultStr.length))
    
    uploadedIndex += 1
    resultTextView.textStorage?.append(NSAttributedString(string: "\n\(uploadedIndex): "))
    resultTextView.textStorage?.append(resultStr)
    resultTextView.scrollToEndOfDocument(self)
  }
  
  fileprivate func showAlert(_ message: String, information: String) {
    let alert = NSAlert()
    alert.messageText = message
    alert.informativeText = information
    
    if let window = self.window {
      alert.beginSheetModal(for: window, completionHandler: nil)
    }
  }
}

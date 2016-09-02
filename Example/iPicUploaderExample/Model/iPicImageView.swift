//
//  iPicImageView.swift
//  iPicUploader
//
//  Created by Jason Zheng on 9/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Cocoa
import iPicUploader

enum iPicImageViewState: String {
  case Normal = "NormalStateIcon"
  case Dragging = "DraggingStateIcon"
  case Uploading = "UploadingStateIcon"
  case Uploaded = "UploadedStateIcon"
}

class iPicImageView: NSImageView {
  
  var state: iPicImageViewState = .Normal {
    didSet {
      switch state {
      case .Normal,
           .Dragging,
           .Uploading:
        self.image = NSImage(named: state.rawValue)
        
      case .Uploaded:
        break
      }
    }
  }
  
  var uploadHandler: iPicUploadHandler?
  
  // MARK: - NSDraggingDestination
  
  override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
    if NSImage.canInitWithPasteboard(sender.draggingPasteboard()) {
      state = .Dragging
      return .Copy
    }
    
    return .None
  }
  
  override func draggingExited(sender: NSDraggingInfo?) {
    state = .Normal
  }
  
  override func performDragOperation(sender: NSDraggingInfo) -> Bool {
    for image in generateImageFromPasteboard(sender.draggingPasteboard()) {
      self.state = .Uploading
      
      iPic.uploadImage(image, handler: { (imageLink, error) in
        if imageLink != nil {
          self.state = .Uploaded
          self.image = image
          
        } else {
          self.state = .Normal
        }
        
        self.uploadHandler?(imageLink: imageLink, error: error)
      })
    }
    
    return true
  }
  
  // MARK: Helper
  
  private func generateImageFromPasteboard(pasteboard: NSPasteboard) -> [NSImage] {
    var images = [NSImage]()
    
    if let pasteboardItems = pasteboard.pasteboardItems {
      for pasteboardItem in pasteboardItems {
        if let image = generateImageFromPasteboardItem(pasteboardItem) {
          images.append(image)
        }
      }
    }
    
    return images
  }
  
  private func generateImageFromPasteboardItem(pasteboardItem: NSPasteboardItem) -> NSImage? {
    for type in pasteboardItem.types {
      if let data = pasteboardItem.dataForType(type) {        
        if type == String(kUTTypeFileURL) {
          let url = NSURL(dataRepresentation: data, relativeToURL: nil)
          return NSImage(byReferencingURL: url)
          
        } else if let image = NSImage(data: data) {
          return image
        }
      }
    }
    
    return nil
  }
}

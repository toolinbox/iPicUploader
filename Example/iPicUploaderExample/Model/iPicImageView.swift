//
//  iPicImageView.swift
//  iPicUploader
//
//  Created by Jason Zheng on 9/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Cocoa
import iPicUploader

// TODO Add different image for different states
enum iPicImageViewState: String {
  case Normal = "NSTrashEmpty" //"NormalStateIcon"
  case Dragging = "NSTrashFull" //"DraggingStateIcon"
  case Uploading = "NSSynchronize" //"NSSynchronize"
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
  
  // MARK: Init
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    commonInit()
  }
  
  private func commonInit() {
    let types = [
      NSPasteboardTypePDF,
      NSPasteboardTypeTIFF,
      NSPasteboardTypePNG,
      NSPasteboardTypeRTF,
      NSPasteboardTypeRTFD,
      NSPasteboardTypeHTML,
    ]
    self.registerForDraggedTypes(types)
  }
  
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
    if let image = NSImage(pasteboard: sender.draggingPasteboard()) {
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
      
    } else {
      // Should not happen, as already use NSImage.canInitWithPasteboard in draggingEntered.
    }
    
    return true
  }
}

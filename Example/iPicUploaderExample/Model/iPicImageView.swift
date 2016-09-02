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
    for image in iPicUploadHelper.generateImagesFromPasteboard(sender.draggingPasteboard()) {
      NSOperationQueue.mainQueue().addOperationWithBlock {
        self.state = .Uploading
      }
      
      iPic.uploadImage(image, handler: { (imageLink, error) in
        self.uploadHandler?(imageLink: imageLink, error: error)
      })
    }
    
    return true
  }
}

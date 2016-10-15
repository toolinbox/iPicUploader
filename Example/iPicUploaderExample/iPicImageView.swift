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
  
  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    if NSImage.canInit(with: sender.draggingPasteboard()) {
      state = .Dragging
      return .copy
    }
    
    return NSDragOperation()
  }
  
  override func draggingExited(_ sender: NSDraggingInfo?) {
    state = .Normal
  }
  
  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    for imageData in iPicUploadHelper.generateImageDataListFrom(sender.draggingPasteboard()) {
      OperationQueue.main.addOperation {
        self.state = .Uploading
      }
      
      iPic.uploadImage(imageData: imageData, handler: { (imageLink, error) in
        self.uploadHandler?(imageLink, error)
      })
    }
    
    return true
  }
}

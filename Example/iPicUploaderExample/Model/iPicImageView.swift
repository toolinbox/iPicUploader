//
//  iPicImageView.swift
//  iPicUploader
//
//  Created by Jason Zheng on 9/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Cocoa

class iPicImageView: NSImageView {
  
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
//    if let source = sender.draggingSource() as? DiceView {
//      if source == self {
//        return .None
//      } else {
//        // Backup the source's intValue.
//        dragSourceIntValue = source.intValue
//        
//        source.intValue = self.intValue
//        source.highlightForDrag = false
//      }
//    }
    
    return sender.draggingSourceOperationMask()
  }
  
  override func draggingExited(sender: NSDraggingInfo?) {
//    if let source = sender?.draggingSource() as? DiceView {
//      if source != self {
//        highlightForDrag = false
//        
//        // Restore the source's intValue.
//        source.intValue = dragSourceIntValue
//        source.highlightForDrag = true
//      }
//    }
  }
  
  override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
    return true
  }
  
  override func performDragOperation(sender: NSDraggingInfo) -> Bool {
    if let image = NSImage(pasteboard: sender.draggingPasteboard()) {
      self.image = image
    } else {
      NSLog("Not image file")
    }
    
    return true
  }
  
  override func concludeDragOperation(sender: NSDraggingInfo?) {
    
  }
}

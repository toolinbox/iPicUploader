//
//  iPicPasteboardHelper.swift
//  iPic
//
//  Created by Jason Zheng on 8/19/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public typealias iPicPasteboardHandler = ((NSPasteboard) -> Void)

public class iPicPasteboardHelper {
  
  private let pasteboard = NSPasteboard.generalPasteboard()
  
  private weak var pasteboardObservingTimer: NSTimer?
  private var pasteboardObservingTimerInterval: NSTimeInterval = 0.75
  private var pasteboardChangedCount = 0
  
  public var handler: iPicPasteboardHandler?
  
  private let iPicUploadPasteboardType = "net.toolinbox.ipic.pasteboard.upload.request"
  private let iPicUploadResultPasteboardType = "net.toolinbox.ipic.pasteboard.upload.result"
  
  // MARK: Public Method
  
  public func startObserving() {
    guard pasteboardObservingTimer == nil else {
      return
    }
    
    pasteboardObservingTimer = NSTimer.scheduledTimerWithTimeInterval(
      pasteboardObservingTimerInterval,
      target: self,
      selector: #selector(iPicPasteboardHelper.observePasteboard),
      userInfo: nil,
      repeats: true)
    pasteboardObservingTimer?.tolerance = pasteboardObservingTimerInterval * 0.3    
    pasteboardObservingTimer?.fire()
  }
  
  public func stopObserving() {
    pasteboardObservingTimer?.invalidate()
    pasteboardObservingTimer = nil
  }
  
  public func writeiPicImage(image: iPicImage) -> Bool {
    clearPasteboardContents()
    
    let pasteboardItem = parseiPicImageToPasteboardItem(image)
    return pasteboard.writeObjects([pasteboardItem])
  }
  
  public func parseUploadResult(pasteboard: NSPasteboard) -> iPicUploadResult? {
    if let type = pasteboard.availableTypeFromArray([iPicUploadResultPasteboardType]) {
      if let data = pasteboard.dataForType(type) {
        NSKeyedUnarchiver.setClass(iPicUploadResult.self, forClassName: iPicUploadResult.sharedClassName)
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? iPicUploadResult
      }
    }
    
    return nil
  }
  
  // MARK: Helper
  
  @objc private func observePasteboard() {
    let count = pasteboard.changeCount
    if pasteboardChangedCount < count {
      pasteboardChangedCount = count
      
      handler?(pasteboard)
    }
  }
  
  private func parseiPicImageToPasteboardItem(image: iPicImage) -> NSPasteboardItem {
    let pasteboardItem = NSPasteboardItem()
    
    NSKeyedArchiver.setClassName(iPicImage.sharedClassName, forClass: iPicImage.self)
    let data = NSKeyedArchiver.archivedDataWithRootObject(image)
    pasteboardItem.setData(data, forType: iPicUploadPasteboardType)
    
    return pasteboardItem
  }
  
  private func clearPasteboardContents() {
    pasteboard.clearContents()
  }
}

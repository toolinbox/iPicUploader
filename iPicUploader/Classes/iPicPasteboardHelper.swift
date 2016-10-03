//
//  iPicPasteboardHelper.swift
//  iPic
//
//  Created by Jason Zheng on 8/19/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public typealias iPicPasteboardHandler = ((NSPasteboard) -> Void)

public let iPicPasteboardName = "net.toolinbox.ipic.pasteboard"
public let PasteboardTypeiPicImage = "net.toolinbox.ipic.pasteboard.iPicImage"
public let PasteboardTypeiPicUploadResult = "net.toolinbox.ipic.pasteboard.iPicUploadResult"
public let PasteboardTypeiPicUploaderVersion = "net.toolinbox.ipic.pasteboard.iPicUploaderVersion"
public let PasteboardTypeiPicUploaderVersionResult = "net.toolinbox.ipic.pasteboard.iPicUploaderVersionResult"

let iPicPasteboard = iPicPasteboardHelper.sharedInstance

open class iPicPasteboardHelper {
  // Singleton
  static let sharedInstance = iPicPasteboardHelper()
  fileprivate init() {}
  
  fileprivate let pasteboard = NSPasteboard(name: iPicPasteboardName)
  
  fileprivate weak var pasteboardObservingTimer: Timer?
  fileprivate var pasteboardObservingTimerInterval: TimeInterval = 0.75
  fileprivate var pasteboardChangedCount = 0
  
  open var handler: iPicPasteboardHandler?
  
  // MARK: Public Method
  
  open func startObserving() {
    guard pasteboardObservingTimer == nil else {
      return
    }
    
    pasteboardObservingTimer = Timer.scheduledTimer(
      timeInterval: pasteboardObservingTimerInterval,
      target: self,
      selector: #selector(iPicPasteboardHelper.observePasteboard),
      userInfo: nil,
      repeats: true)
    pasteboardObservingTimer?.tolerance = pasteboardObservingTimerInterval * 0.3    
    pasteboardObservingTimer?.fire()
  }
  
  open func stopObserving() {
    pasteboardObservingTimer?.invalidate()
    pasteboardObservingTimer = nil
  }
  
  open func writeiPicImage(_ image: iPicImage) -> Bool {
    clearPasteboardContents()
    
    let pasteboardItem = parseiPicImageToPasteboardItem(image)
    return pasteboard.writeObjects([pasteboardItem])
  }
  
  open func writeiPicUploaderVersionRequest() -> Bool {
    clearPasteboardContents()
    
    let pasteboardItem = NSPasteboardItem()
    pasteboardItem.setString("", forType: PasteboardTypeiPicUploaderVersion)
    
    return pasteboard.writeObjects([pasteboardItem])
  }
  
  open func parseUploadResult(_ pasteboard: NSPasteboard) -> iPicUploadResult? {
    if let type = pasteboard.availableType(from: [PasteboardTypeiPicUploadResult]) {
      if let data = pasteboard.data(forType: type) {
        NSKeyedUnarchiver.setClass(iPicUploadResult.self, forClassName: iPicUploadResult.sharedClassName)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? iPicUploadResult
      }
    }
    
    return nil
  }
  
  open func parseiPicUploaderVersionResult(_ pasteboard: NSPasteboard) -> Int? {
    if let versionString = pasteboard.string(forType: PasteboardTypeiPicUploaderVersionResult) {
      return Int(versionString)
    }
    
    return nil
  }
  
  // MARK: Helper
  
  @objc fileprivate func observePasteboard() {
    let count = pasteboard.changeCount
    if pasteboardChangedCount < count {
      pasteboardChangedCount = count
      
      handler?(pasteboard)
    }
  }
  
  fileprivate func parseiPicImageToPasteboardItem(_ image: iPicImage) -> NSPasteboardItem {
    let pasteboardItem = NSPasteboardItem()
    
    NSKeyedArchiver.setClassName(iPicImage.sharedClassName, for: iPicImage.self)
    let data = NSKeyedArchiver.archivedData(withRootObject: image)
    pasteboardItem.setData(data, forType: PasteboardTypeiPicImage)
    
    return pasteboardItem
  }
  
  fileprivate func clearPasteboardContents() {
    pasteboard.clearContents()
  }
}

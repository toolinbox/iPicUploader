//
//  iPicPasteboardHelper.swift
//  iPic
//
//  Created by Jason Zheng on 8/19/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

internal typealias iPicPasteboardHandler = ((NSPasteboard) -> Void)

internal let iPicPasteboardName = "net.toolinbox.ipic.pasteboard"
internal let PasteboardTypeiPicImage = "net.toolinbox.ipic.pasteboard.iPicImage"
internal let PasteboardTypeiPicUploadResult = "net.toolinbox.ipic.pasteboard.iPicUploadResult"
internal let PasteboardTypeiPicUploaderVersion = "net.toolinbox.ipic.pasteboard.iPicUploaderVersion"
internal let PasteboardTypeiPicUploaderVersionResult = "net.toolinbox.ipic.pasteboard.iPicUploaderVersionResult"

internal let iPicPasteboard = iPicPasteboardHelper.sharedInstance

internal class iPicPasteboardHelper {
  // Singleton
  internal static let sharedInstance = iPicPasteboardHelper()
  private init() {}
  
  private let pasteboard = NSPasteboard(name: iPicPasteboardName)
  
  private weak var pasteboardObservingTimer: Timer?
  private var pasteboardObservingTimerInterval: TimeInterval = 0.75
  private var pasteboardChangedCount = 0
  
  internal var handler: iPicPasteboardHandler?
  
  // MARK: Internal Method
  
  internal func startObserving() {
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
  
  internal func stopObserving() {
    pasteboardObservingTimer?.invalidate()
    pasteboardObservingTimer = nil
  }
  
  internal func writeiPicImage(_ image: iPicImage) -> Bool {
    clearPasteboardContents()
    
    let pasteboardItem = parseiPicImageToPasteboardItem(image)
    return pasteboard.writeObjects([pasteboardItem])
  }
  
  internal func writeiPicUploaderVersionRequest() -> Bool {
    clearPasteboardContents()
    
    let pasteboardItem = NSPasteboardItem()
    pasteboardItem.setString("", forType: PasteboardTypeiPicUploaderVersion)
    
    return pasteboard.writeObjects([pasteboardItem])
  }
  
  internal func parseUploadResult(_ pasteboard: NSPasteboard) -> iPicUploadResult? {
    if let type = pasteboard.availableType(from: [PasteboardTypeiPicUploadResult]) {
      if let data = pasteboard.data(forType: type) {
        NSKeyedUnarchiver.setClass(iPicUploadResult.self, forClassName: iPicUploadResult.sharedClassName)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? iPicUploadResult
      }
    }
    
    return nil
  }
  
  internal func parseiPicUploaderVersionResult(_ pasteboard: NSPasteboard) -> Int? {
    if let versionString = pasteboard.string(forType: PasteboardTypeiPicUploaderVersionResult) {
      return Int(versionString)
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
  
  private func parseiPicImageToPasteboardItem(_ image: iPicImage) -> NSPasteboardItem {
    let pasteboardItem = NSPasteboardItem()
    
    NSKeyedArchiver.setClassName(iPicImage.sharedClassName, for: iPicImage.self)
    let data = NSKeyedArchiver.archivedData(withRootObject: image)
    pasteboardItem.setData(data, forType: PasteboardTypeiPicImage)
    
    return pasteboardItem
  }
  
  private func clearPasteboardContents() {
    pasteboard.clearContents()
  }
}

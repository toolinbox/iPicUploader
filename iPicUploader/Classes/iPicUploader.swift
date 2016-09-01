//
//  iPicUploader.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public let iPic = iPicUploader.sharedInstance

public class iPicUploader {
  // Singleton
  public static let sharedInstance = iPicUploader()
  private init() {
    pasteboardHelper.handler = dealWithUploadResult
  }
  
  private var pendingImages = [String: iPicImage]()
  private let pendingImagesLocker = NSRecursiveLock()
  
  private var pasteboardHelper = iPicPasteboardHelper()
  
  // TODO Change it back to 30 after debug.
  private let uploadTimeoutSeconds: NSTimeInterval = 300
  
  // MARK: Public Method
  
  public func uploadImage(imageFilePath: String, handler: iPicUploadHandler) {
    
    // Generate iPicImage.
    let (theImage, error) = iPicUploadHelper.generateiPicImage(imageFilePath)
    guard let image = theImage else {
      handler(imageLink: nil, error: error)
      return
    }
    
    // Launch iPic if it's not running.
    guard iPicUploadHelper.launchiPic() else {
      handler(imageLink: nil, error: iPicUploadError.CanNotLaunchiPic)
      return
    }
    
    // Store iPicImage with handler.
    image.handler = handler
    lock {
      self.pendingImages[image.id] = image
    }
    
    // Start observing pasteboard.
    pasteboardHelper.startObserving()
    
    // Start upload.
    uploadPendingImages()
    
    // Remove iPicImage after timeout.
    iPicUploadHelper.delay(uploadTimeoutSeconds) {
      let uploadResult = iPicUploadResult(imageLink: nil, error: iPicUploadError.TimeOut)
      uploadResult.id = image.id
      self.finishUploadImage(uploadResult)
    }
  }
  
  // MARK: Helper
  
  private func uploadPendingImages() {
    // NOTE: If write pasteboard too frequently, iPic may miss some image. So upload one by one.
    var image: iPicImage?
    
    lock {
      if let (_, pendingImage) = self.pendingImages.first {
        image = pendingImage
      }
    }
    
    if let image = image {
      pasteboardHelper.writeiPicImage(image)
    }
  }
  
  private func finishUploadImage(uploadResult: iPicUploadResult) {
    var image: iPicImage?
    var hasNoPendingImages = false
    
    lock {
      image = self.pendingImages[uploadResult.id]
      
      self.pendingImages[uploadResult.id] = nil
      hasNoPendingImages = self.pendingImages.isEmpty
    }
    
    // Callback handler in main operate queue.
    if image != nil {
      NSOperationQueue.mainQueue().addOperationWithBlock({ 
        image?.handler?(imageLink: uploadResult.imageLink, error: uploadResult.error)
      })
    }
    
    if hasNoPendingImages {
      // Stop pasteboard observing if has not pending images.
      pasteboardHelper.stopObserving()
    } else {
      // Continue to upload other pending images.
      uploadPendingImages()
    }
  }
  
  private func dealWithUploadResult(pasteboard: NSPasteboard) {
    if let uploadResult = pasteboardHelper.parseUploadResult(pasteboard) {
      finishUploadImage(uploadResult)
    }
  }
  
  private func lock(closure:()->()) {
    pendingImagesLocker.lock()
    closure()
    pendingImagesLocker.unlock()
  }
}
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
    iPicPasteboard.handler = dealWithUploadResult
  }
  
  public let version = 1
  private var versionIniPic: Int?
  
  private var pendingImages = [String: iPicImage]()
  private let pendingImagesLocker = NSRecursiveLock()
  
  private let uploadTimeoutSeconds: NSTimeInterval = 30
  private let requestVersionTimeoutSeconds: NSTimeInterval = 3
  
  // TODO Change it normal download link after latest iPic is online.
  public let iPicDownloadLink = "http://toolinbox.net/html/DownloadiPicWithService.html"
  
  // MARK: Public Method
  
  public func uploadImage(imageFilePath: String, handler: iPicUploadHandler) {
    
    let (theImage, error) = iPicUploadHelper.generateiPicImage(imageFilePath)
    guard let image = theImage else {
      handler(imageLink: nil, error: error)
      return
    }
    
    doUploadImage(image, handler: handler)
  }
  
  public func uploadImage(image: NSImage, handler: iPicUploadHandler) {
    
    let (theImage, error) = iPicUploadHelper.generateiPicImage(image)
    guard let image = theImage else {
      handler(imageLink: nil, error: error)
      return
    }
    
    doUploadImage(image, handler: handler)
  }
  
  public func uploadImage(imageData: NSData, handler: iPicUploadHandler) {    
    let image = iPicImage(imageData: imageData)
    doUploadImage(image, handler: handler)
  }
  
  // MARK: Helper
  
  private func doUploadImage(image: iPicImage, handler: iPicUploadHandler) {
    
    // Launch iPic.
    if let error = iPicUploadHelper.launchiPic() {
      handler(imageLink: nil, error: error)
      return
    }
    
    // Store iPicImage with handler.
    image.handler = handler
    lock {
      self.pendingImages[image.id] = image
    }
    
    // Start observing pasteboard.
    iPicPasteboard.startObserving()
    
    // Check iPicUploader version in iPic
    if let versionIniPic = versionIniPic {
      doUploadImage(image, handler: handler, versionIniPic: versionIniPic)
      
    } else {
      // Request iPicUploader version in iPic
      requestiPicUploaderVersionIniPic()
      
      // Remove iPicImage after timeout.
      iPicUploadHelper.delay(requestVersionTimeoutSeconds) {
        if let versionIniPic = self.versionIniPic {
          self.doUploadImage(image, handler: handler, versionIniPic: versionIniPic)
          
        } else {
          self.finishUploadImage(image.id, error: iPicUploadError.iPicIncompatible)
        }
      }
    }
  }
  
  private func doUploadImage(image: iPicImage, handler: iPicUploadHandler, versionIniPic: Int) {
    if versionIniPic >= version {
      // Start upload.
      uploadPendingImages()
      
      // Remove iPicImage after timeout.
      iPicUploadHelper.delay(uploadTimeoutSeconds) {
        self.finishUploadImage(image.id, error: iPicUploadError.TimeOut)
      }
      
    } else {
      self.finishUploadImage(image.id, error: iPicUploadError.iPicIncompatible)
    }
  }
  
  private func uploadPendingImages() {
    // NOTE: If write pasteboard too frequently, iPic may miss some images. So upload one by one.
    var image: iPicImage?
    
    lock {
      if let (_, pendingImage) = self.pendingImages.first {
        image = pendingImage
      }
    }
    
    if let image = image {
      iPicPasteboard.writeiPicImage(image)
    }
  }
  
  private func finishUploadImage(id: String, error: NSError) {
    let uploadResult = iPicUploadResult(imageLink: nil, error: error)
    uploadResult.id = id
    finishUploadImage(uploadResult)
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
      iPicPasteboard.stopObserving()
    } else {
      // Continue to upload other pending images.
      uploadPendingImages()
    }
  }
  
  private func dealWithUploadResult(pasteboard: NSPasteboard) {
    if let uploadResult = iPicPasteboard.parseUploadResult(pasteboard) {
      finishUploadImage(uploadResult)
    } else if let version = iPicPasteboard.parseiPicUploaderVersionResult(pasteboard) {
      versionIniPic = version
    }
  }
  
  private func requestiPicUploaderVersionIniPic() {
    iPicPasteboard.writeiPicUploaderVersionRequest()
  }
  
  private func lock(closure:()->()) {
    pendingImagesLocker.lock()
    closure()
    pendingImagesLocker.unlock()
  }
}
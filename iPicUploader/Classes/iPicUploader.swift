//
//  iPicUploader.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public let iPic = iPicUploader.sharedInstance

open class iPicUploader {
  // Singleton
  open static let sharedInstance = iPicUploader()
  fileprivate init() {
    iPicPasteboard.handler = dealWithUploadResult
  }
  
  open let version = 1
  fileprivate var versionIniPic: Int?
  
  fileprivate var pendingImages = [String: iPicImage]()
  fileprivate let pendingImagesLocker = NSRecursiveLock()
  
  fileprivate let uploadTimeoutSeconds: TimeInterval = 30
  fileprivate let requestVersionTimeoutSeconds: TimeInterval = 3
  
  // TODO Change it normal download link after latest iPic is online.
  open let iPicDownloadLink = "http://toolinbox.net/html/DownloadiPicWithService.html"
  
  // MARK: Public Method
  
  open func uploadImage(_ imageFilePath: String, handler: @escaping iPicUploadHandler) {
    
    let (theImage, error) = iPicUploadHelper.generateiPicImage(imageFilePath)
    guard let image = theImage else {
      handler(nil, error)
      return
    }
    
    doUploadImage(image, handler: handler)
  }
  
  open func uploadImage(_ image: NSImage, handler: @escaping iPicUploadHandler) {
    
    let (theImage, error) = iPicUploadHelper.generateiPicImage(image)
    guard let image = theImage else {
      handler(nil, error)
      return
    }
    
    doUploadImage(image, handler: handler)
  }
  
  open func uploadImage(_ imageData: Data, handler: @escaping iPicUploadHandler) {
    let image = iPicImage(imageData: imageData)
    doUploadImage(image, handler: handler)
  }
  
  // MARK: Helper
  
  fileprivate func doUploadImage(_ image: iPicImage, handler: @escaping iPicUploadHandler) {
    
    // Launch iPic.
    if let error = iPicUploadHelper.launchiPic() {
      handler(nil, error)
      return
    }
    
    // Store iPicImage with its handler.
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
  
  fileprivate func doUploadImage(_ image: iPicImage, handler: iPicUploadHandler, versionIniPic: Int) {
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
  
  fileprivate func uploadPendingImages() {
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
  
  fileprivate func finishUploadImage(_ id: String, error: NSError) {
    let uploadResult = iPicUploadResult(imageLink: nil, error: error)
    uploadResult.id = id
    finishUploadImage(uploadResult)
  }
  
  fileprivate func finishUploadImage(_ uploadResult: iPicUploadResult) {
    var image: iPicImage?
    var hasNoPendingImages = false
    
    lock {
      image = self.pendingImages[uploadResult.id]
      
      self.pendingImages[uploadResult.id] = nil
      hasNoPendingImages = self.pendingImages.isEmpty
    }
    
    // Callback the handler.
    if image != nil {
        image?.handler?(uploadResult.imageLink, uploadResult.error)
    }
    
    if hasNoPendingImages {
      // Stop pasteboard observing if has not pending images.
      iPicPasteboard.stopObserving()
    } else {
      // Continue to upload other pending images.
      uploadPendingImages()
    }
  }
  
  fileprivate func dealWithUploadResult(_ pasteboard: NSPasteboard) {
    if let uploadResult = iPicPasteboard.parseUploadResult(pasteboard) {
      finishUploadImage(uploadResult)
    } else if let version = iPicPasteboard.parseiPicUploaderVersionResult(pasteboard) {
      versionIniPic = version
    }
  }
  
  fileprivate func requestiPicUploaderVersionIniPic() {
    iPicPasteboard.writeiPicUploaderVersionRequest()
  }
  
  fileprivate func lock(_ closure:()->()) {
    pendingImagesLocker.lock()
    closure()
    pendingImagesLocker.unlock()
  }
}

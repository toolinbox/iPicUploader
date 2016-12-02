//
//  iPicUploader.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public let iPic = iPicUploader.sharedInstance

public typealias iPicUploadHandler = (_ imageLink: String?, _ error: NSError?) -> ()

@objc public class iPicUploader: NSObject {
  // Singleton
  internal static let sharedInstance = iPicUploader()
  private override init() {
    super.init()
    
    iPicPasteboard.handler = dealWithUploadResult
  }
  
  public let version = 1
  private var versionIniPic: Int?
  
  private var pendingImages = [String: iPicImage]()
  private let pendingImagesLocker = NSRecursiveLock()
  
  private let uploadTimeoutSeconds: TimeInterval = 30
  private let requestVersionTimeoutSeconds: TimeInterval = 2
  
  public let iPicDownloadLink = "macappstore://itunes.apple.com/app/id1101244278"
  
  // MARK: Public Method
  
  /* Validate if macOS is compatible and iPic is installed. Launch iPic if both are yes. */
  public func validate() -> NSError? {
    if !iPicUploadHelper.ismacOSCompatible() {
      return iPicUploadError.macOSIncompatible
    }
    
    return iPicUploadHelper.launchiPic()
  }
  
  public func uploadImage(imageFilePath: String, handler: @escaping iPicUploadHandler) {
    
    let (theImage, error) = iPicUploadHelper.generateiPicImage(imageFilePath)
    guard let image = theImage else {
      handler(nil, error)
      return
    }
    
    doUploadImage(image, handler: handler)
  }
  
  public func uploadImage(image: NSImage, handler: @escaping iPicUploadHandler) {
    
    let (theImage, error) = iPicUploadHelper.generateiPicImage(image)
    guard let image = theImage else {
      handler(nil, error)
      return
    }
    
    doUploadImage(image, handler: handler)
  }
  
  public func uploadImage(imageData: Data, handler: @escaping iPicUploadHandler) {
    let image = iPicImage(imageData: imageData)
    doUploadImage(image, handler: handler)
  }
  
  // MARK: Helper
  
  private func doUploadImage(_ image: iPicImage, handler: @escaping iPicUploadHandler) {
    
    // Validate and launch iPic.
    if let error = validate() {
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
  
  private func doUploadImage(_ image: iPicImage, handler: iPicUploadHandler, versionIniPic: Int) {
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
  
  private func finishUploadImage(_ id: String, error: NSError) {
    let uploadResult = iPicUploadResult(imageLink: nil, error: error)
    uploadResult.id = id
    finishUploadImage(uploadResult)
  }
  
  private func finishUploadImage(_ uploadResult: iPicUploadResult) {
    var image: iPicImage?
    
    lock {
      image = self.pendingImages[uploadResult.id]
      self.pendingImages[uploadResult.id] = nil
      
      if self.pendingImages.isEmpty {
        iPicPasteboard.stopObserving()
      }
    }
    
    // Callback the handler.
    image?.handler?(uploadResult.imageLink, uploadResult.error)
    
    // Continue to upload other pending images.
    uploadPendingImages()
  }
  
  private func dealWithUploadResult(_ pasteboard: NSPasteboard) {
    if let uploadResult = iPicPasteboard.parseUploadResult(pasteboard) {
      finishUploadImage(uploadResult)
    } else if let version = iPicPasteboard.parseiPicUploaderVersionResult(pasteboard) {
      versionIniPic = version
    }
  }
  
  private func requestiPicUploaderVersionIniPic() {
    iPicPasteboard.writeiPicUploaderVersionRequest()
  }
  
  private func lock(_ closure:()->()) {
    pendingImagesLocker.lock()
    closure()
    pendingImagesLocker.unlock()
  }
}

//
//  iPicUploadResult.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

open class iPicUploadResult: NSObject, NSCoding {
  open static let sharedClassName: String = "net.toolinbox.iPic.iPicUploadResult"
  
  fileprivate static let idKey = "id"
  fileprivate static let imageLinkKey = "imageLink"
  fileprivate static let errorKey = "error"
  
  fileprivate static let versionKey = "version"
  fileprivate static let jsonKey = "json"
  
  open var id = UUID().uuidString
  open var imageLink: String?
  open var error: NSError?
  
  open var version = 1
  open var json: AnyObject?
  
  public init(imageLink: String?, error: NSError?) {
    super.init()
    
    self.imageLink = imageLink
    self.error = error
  }
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObject(forKey: iPicUploadResult.idKey) as? String) ?? ""
    imageLink = aDecoder.decodeObject(forKey: iPicUploadResult.imageLinkKey) as? String
    error = aDecoder.decodeObject(forKey: iPicUploadResult.errorKey) as? NSError
    
    version = aDecoder.decodeInteger(forKey: iPicUploadResult.versionKey)
    json = aDecoder.decodeObject(forKey: iPicUploadResult.jsonKey) as AnyObject?
  }
  
  open func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: iPicUploadResult.idKey)
    aCoder.encode(imageLink, forKey: iPicUploadResult.imageLinkKey)
    aCoder.encode(error, forKey: iPicUploadResult.errorKey)
    
    aCoder.encode(version, forKey: iPicUploadResult.versionKey)
    aCoder.encode(json, forKey: iPicUploadResult.jsonKey)
  }
}

public struct iPicUploadError {
  
  public static let Unknown             = iPicUploadError.create(-1, "Unknown error.")
  public static let iPicNotInstalled    = iPicUploadError.create(-11, "iPic wasn't installed.")
  public static let iPicIncompatible    = iPicUploadError.create(-12, "iPic isn't compatible.")
  public static let FileInaccessable    = iPicUploadError.create(-21, "The file isn't accessable.")
  public static let InvalidImageFile    = iPicUploadError.create(-22, "Invalid image file.")
  public static let InvalidImageHost    = iPicUploadError.create(-31, "Invalid image host.")
  public static let FailedToUpload      = iPicUploadError.create(-32, "Failed to upload.")
  public static let TimeOut             = iPicUploadError.create(-41, "Time out.")
  
  fileprivate static let iPicUploaderDomain = "net.toolinbox.ipic.uploader"
  
  fileprivate static func create(_ code: Int, _ description: String) -> NSError {
    return NSError(domain: iPicUploaderDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
  }
}

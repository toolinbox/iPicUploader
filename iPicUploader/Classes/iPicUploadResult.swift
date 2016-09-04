//
//  iPicUploadResult.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

public class iPicUploadResult: NSObject, NSCoding {
  public static let sharedClassName: String = "net.toolinbox.iPic.iPicUploadResult"
  
  private static let idKey = "id"
  private static let imageLinkKey = "imageLink"
  private static let errorKey = "error"
  
  private static let versionKey = "version"
  private static let jsonKey = "json"
  
  public var id = NSUUID().UUIDString
  public var imageLink: String?
  public var error: NSError?
  
  public var version = 1
  public var json: AnyObject?
  
  public init(imageLink: String?, error: NSError?) {
    super.init()
    
    self.imageLink = imageLink
    self.error = error
  }
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObjectForKey(iPicUploadResult.idKey) as? String) ?? ""
    imageLink = aDecoder.decodeObjectForKey(iPicUploadResult.imageLinkKey) as? String
    error = aDecoder.decodeObjectForKey(iPicUploadResult.errorKey) as? NSError
    
    version = aDecoder.decodeIntegerForKey(iPicUploadResult.versionKey)
    json = aDecoder.decodeObjectForKey(iPicUploadResult.jsonKey)
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(id, forKey: iPicUploadResult.idKey)
    aCoder.encodeObject(imageLink, forKey: iPicUploadResult.imageLinkKey)
    aCoder.encodeObject(error, forKey: iPicUploadResult.errorKey)
    
    aCoder.encodeInteger(version, forKey: iPicUploadResult.versionKey)
    aCoder.encodeObject(json, forKey: iPicUploadResult.jsonKey)
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
  
  private static let iPicUploaderDomain = "net.toolinbox.ipic.uploader"
  
  private static func create(code: Int, _ description: String) -> NSError {
    return NSError(domain: iPicUploaderDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
  }
}

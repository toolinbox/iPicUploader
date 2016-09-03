//
//  iPicImage.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

public typealias iPicUploadHandler = (imageLink: String?, error: NSError?) -> ()

public class iPicImage: NSObject, NSCoding {
  public static let sharedClassName: String = "net.toolinbox.iPic.iPicImage"
  
  private static let idKey = "id"
  private static let imageFilePathKey = "imageFilePath"
  private static let imageDataKey = "imageData"
  
  private static let versionKey = "version"
  private static let jsonKey = "json"
  
  public var id = NSUUID().UUIDString
  public var imageFilePath: String?
  public var imageData: NSData?
  
  public var version = 1
  public var json: AnyObject?
  
  var handler: iPicUploadHandler?
  
  public init(imageFilePath: String) {
    super.init()
    
    self.imageFilePath = imageFilePath
  }
  
  public init(imageData: NSData) {
    super.init()
    
    self.imageData = imageData
  }
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObjectForKey(iPicImage.idKey) as? String) ?? ""
    imageFilePath = aDecoder.decodeObjectForKey(iPicImage.imageFilePathKey) as? String
    imageData = aDecoder.decodeObjectForKey(iPicImage.imageDataKey) as? NSData
    
    version = aDecoder.decodeIntegerForKey(iPicImage.versionKey)
    json = aDecoder.decodeObjectForKey(iPicImage.jsonKey)
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(id, forKey: iPicImage.idKey)
    aCoder.encodeObject(imageFilePath, forKey: iPicImage.imageFilePathKey)
    aCoder.encodeObject(imageData, forKey: iPicImage.imageDataKey)
    
    aCoder.encodeInteger(version, forKey: iPicImage.versionKey)
    aCoder.encodeObject(json, forKey: iPicImage.jsonKey)
  }
}

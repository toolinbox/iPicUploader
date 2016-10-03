//
//  iPicImage.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

public class iPicImage: NSObject, NSCoding {
  internal static let sharedClassName: String = "net.toolinbox.iPic.iPicImage"
  
  private static let idKey = "id"
  private static let imageFilePathKey = "imageFilePath"
  private static let imageDataKey = "imageData"
  
  private static let versionKey = "version"
  private static let jsonKey = "json"
  
  internal var id = UUID().uuidString
  internal var imageFilePath: String?
  internal var imageData: Data?
  
  internal var version = 1
  internal var json: AnyObject?
  
  internal var handler: iPicUploadHandler?
  
  internal init(imageFilePath: String) {
    super.init()
    
    self.imageFilePath = imageFilePath
  }
  
  internal init(imageData: Data) {
    super.init()
    
    self.imageData = imageData
  }
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObject(forKey: iPicImage.idKey) as? String) ?? ""
    imageFilePath = aDecoder.decodeObject(forKey: iPicImage.imageFilePathKey) as? String
    imageData = aDecoder.decodeObject(forKey: iPicImage.imageDataKey) as? Data
    
    version = aDecoder.decodeInteger(forKey: iPicImage.versionKey)
    json = aDecoder.decodeObject(forKey: iPicImage.jsonKey) as AnyObject?
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: iPicImage.idKey)
    aCoder.encode(imageFilePath, forKey: iPicImage.imageFilePathKey)
    aCoder.encode(imageData, forKey: iPicImage.imageDataKey)
    
    aCoder.encode(version, forKey: iPicImage.versionKey)
    aCoder.encode(json, forKey: iPicImage.jsonKey)
  }
}

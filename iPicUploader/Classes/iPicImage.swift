//
//  iPicImage.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

public typealias iPicUploadHandler = (_ imageLink: String?, _ error: NSError?) -> ()

open class iPicImage: NSObject, NSCoding {
  open static let sharedClassName: String = "net.toolinbox.iPic.iPicImage"
  
  fileprivate static let idKey = "id"
  fileprivate static let imageFilePathKey = "imageFilePath"
  fileprivate static let imageDataKey = "imageData"
  
  fileprivate static let versionKey = "version"
  fileprivate static let jsonKey = "json"
  
  open var id = UUID().uuidString
  open var imageFilePath: String?
  open var imageData: Data?
  
  open var version = 1
  open var json: AnyObject?
  
  var handler: iPicUploadHandler?
  
  public init(imageFilePath: String) {
    super.init()
    
    self.imageFilePath = imageFilePath
  }
  
  public init(imageData: Data) {
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
  
  open func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: iPicImage.idKey)
    aCoder.encode(imageFilePath, forKey: iPicImage.imageFilePathKey)
    aCoder.encode(imageData, forKey: iPicImage.imageDataKey)
    
    aCoder.encode(version, forKey: iPicImage.versionKey)
    aCoder.encode(json, forKey: iPicImage.jsonKey)
  }
}

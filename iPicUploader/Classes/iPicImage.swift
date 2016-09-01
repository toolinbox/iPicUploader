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
  
  public var id = NSUUID().UUIDString
  public var imageFilePath = ""
  public var imageData: NSData?
  var handler: iPicUploadHandler?
  
  public init(imageFilePath: String) {
    super.init()
    
    self.imageFilePath = imageFilePath
  }
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObjectForKey(iPicImage.idKey) as? String) ?? ""
    imageFilePath = (aDecoder.decodeObjectForKey(iPicImage.imageFilePathKey) as? String) ?? ""
    imageData = (aDecoder.decodeObjectForKey(iPicImage.imageDataKey) as? NSData) ?? nil
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(id, forKey: iPicImage.idKey)
    aCoder.encodeObject(imageFilePath, forKey: iPicImage.imageFilePathKey)
    aCoder.encodeObject(imageData, forKey: iPicImage.imageDataKey)
  }
}

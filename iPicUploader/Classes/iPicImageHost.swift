//
//  iPicImageHost.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 12/16/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

public class iPicImageHost: NSObject, NSCoding {
  public static let sharedClassName: String = "net.toolinbox.iPic.iPicImageHost"
  
  private static let idKey = "id"
  private static let titleKey = "title"
  private static let iconKey = "icon"
  
  public var id = ""
  public var title = ""
  public var icon: NSImage?
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObject(forKey: iPicImageHost.idKey) as? String) ?? ""
    title = (aDecoder.decodeObject(forKey: iPicImageHost.titleKey) as? String) ?? ""
    icon = aDecoder.decodeObject(forKey: iPicImageHost.iconKey) as? NSImage
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: iPicImageHost.idKey)
    aCoder.encode(title, forKey: iPicImageHost.titleKey)
    aCoder.encode(icon, forKey: iPicImageHost.iconKey)
  }
}

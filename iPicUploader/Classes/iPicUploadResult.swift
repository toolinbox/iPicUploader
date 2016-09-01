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
  
  public var id = NSUUID().UUIDString
  public var imageLink: String?
  public var error: NSError?
  
  public init(imageLink: String?, error: NSError?) {
    super.init()
    
    self.imageLink = imageLink
    self.error = error
  }
  
  // MARK: - NSCoding
  
  public required init?(coder aDecoder: NSCoder) {
    super.init()
    
    id = (aDecoder.decodeObjectForKey(iPicUploadResult.idKey) as? String) ?? ""
    imageLink = (aDecoder.decodeObjectForKey(iPicUploadResult.imageLinkKey) as? String) ?? ""
    error = (aDecoder.decodeObjectForKey(iPicUploadResult.errorKey) as? NSError) ?? nil
  }
  
  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(id, forKey: iPicUploadResult.idKey)
    aCoder.encodeObject(imageLink, forKey: iPicUploadResult.imageLinkKey)
    aCoder.encodeObject(error, forKey: iPicUploadResult.errorKey)
  }
}

public struct iPicUploadError {
  private static let CommonDomain = "net.toolinbox.ipic"
  private static let WeiboDomain = CommonDomain + ".Weibo"
  private static let QiniuDomain = CommonDomain + ".Qiniu"
  private static let UpYunDomain = CommonDomain + ".UpYun"
  private static let AliOSSDomain = CommonDomain + ".AliOSS"
  private static let ImgurDomain = CommonDomain + ".Imgur"
  private static let FlickrDomain = CommonDomain + ".Flickr"
  private static let S3Domain = CommonDomain + ".S3"
  
  public static let Unknown  = iPicUploadError.create(CommonDomain, 0, NSLocalizedString("Unknown error.", comment: "Error"))
  public static let CanNotLaunchiPic  = iPicUploadError.create(CommonDomain, -1, NSLocalizedString("Can't launch iPic.", comment: "Error"))
  public static let FileInaccessable  = iPicUploadError.create(CommonDomain, -2, NSLocalizedString("File is inaccessable.", comment: "Error"))
  public static let NotImageFile  = iPicUploadError.create(CommonDomain, -3, NSLocalizedString("Not image file.", comment: "Error"))
  public static let TimeOut  = iPicUploadError.create(CommonDomain, -4, NSLocalizedString("Time out.", comment: "Error"))
  
  // http://developer.qiniu.com/article/developer/response-body.html
  public static let QiniuInvalidToken   = iPicUploadError.create(QiniuDomain, 401, NSLocalizedString("Invalid token.", comment: "Error"))
  public static let QiniuBucketNotExist = iPicUploadError.create(QiniuDomain, 631, NSLocalizedString("Bucket doesn't exist.", comment: "Error"))
  
  // http://docs.upyun.com/api/errno/
  public static let UpYunAuthorizationFailed  = iPicUploadError.create(UpYunDomain, 40100005, NSLocalizedString("Authorization failed.", comment: "Error"))
  public static let UpYunBucketNotExist       = iPicUploadError.create(UpYunDomain, 40100012, NSLocalizedString("Bucket doesn't exist.", comment: "Error"))
  public static let UpYunUserNotExist         = iPicUploadError.create(UpYunDomain, 40100006, NSLocalizedString("Operator doesn't exist.", comment: "Error"))
  public static let UpYunUserNeedPermission   = iPicUploadError.create(UpYunDomain, 40100017, NSLocalizedString("Operator needs permission.", comment: "Error"))
  
  // https://help.aliyun.com/knowledge_detail/39597.html
  public static let AliOSSAccessDenied     = iPicUploadError.create(AliOSSDomain, 403, NSLocalizedString("No Permission.", comment: "Error"))
  public static let AliOSSInvalidAccessKey = iPicUploadError.create(AliOSSDomain, 403, NSLocalizedString("Invalid access key.", comment: "Error"))
  public static let AliOSSNoSuchBucket     = iPicUploadError.create(AliOSSDomain, 404, NSLocalizedString("Bucket doesn't exist.", comment: "Error"))
  
  // https://api.imgur.com/errorhandling
  public static let ImgurInvalidToken   = iPicUploadError.create(ImgurDomain, 403, NSLocalizedString("Invalid token.", comment: "Error"))
  
  // https://www.flickr.com/services/api/upload.api.html
  public static let FlickrInvalidToken   = iPicUploadError.create(FlickrDomain, 98, NSLocalizedString("Invalid token.", comment: "Error"))
  
  // http://docs.aws.amazon.com/AmazonS3/latest/API/ErrorResponses.html
  public static let S3AccessDenied     = iPicUploadError.create(S3Domain, 403, NSLocalizedString("No Permission.", comment: "Error"))
  public static let S3InvalidAccessKey = iPicUploadError.create(S3Domain, 403, NSLocalizedString("Invalid access key.", comment: "Error"))
  
  private static func create(domain: String, _ code: Int, _ description: String) -> NSError {
    return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
  }
}

//
//  iPicUploaderTests.swift
//  iPicUploaderTests
//
//  Created by Jason Zheng on 9/1/16.
//
//

import XCTest
@testable import iPicUploader

class iPicUploadResultTests: XCTestCase {
  
  func testiPicUploadResult() {
    let imageLink = "http://test.com/pic.jpg"
    let error = iPicUploadError.FailedToUpload
    let result1 = iPicUploadResult(imageLink: imageLink, error: error)
    result1.json = UUID().uuidString as AnyObject
    
    XCTAssertTrue(!result1.id.isEmpty)
    XCTAssertEqual(result1.version, 1)
    
    let data = NSKeyedArchiver.archivedData(withRootObject: result1)
    let result2 = NSKeyedUnarchiver.unarchiveObject(with: data) as! iPicUploadResult
    XCTAssertEqual(result1.id, result2.id)
    XCTAssertEqual(result1.imageLink, result2.imageLink)
    XCTAssertEqual(result1.error, result2.error)
    XCTAssertEqual(result1.version, result2.version)
    XCTAssertEqual(result1.json as? String, result2.json as? String)
  }
  
  func testiPicUploadError() {
    XCTAssertEqual(iPicUploadError.Unknown.code, -1)
    XCTAssertEqual(iPicUploadError.iPicNotInstalled.code, -11)
    XCTAssertEqual(iPicUploadError.iPicIncompatible.code, -12)
    XCTAssertEqual(iPicUploadError.FileInaccessable.code, -21)
    XCTAssertEqual(iPicUploadError.InvalidImageFile.code, -22)
    XCTAssertEqual(iPicUploadError.InvalidImageHost.code, -31)
    XCTAssertEqual(iPicUploadError.FailedToUpload.code, -32)
    XCTAssertEqual(iPicUploadError.TimeOut.code, -41)
  }
}

//
//  iPicUploaderTests.swift
//  iPicUploaderTests
//
//  Created by Jason Zheng on 9/1/16.
//
//

import XCTest
@testable import iPicUploader

class iPicImageTests: XCTestCase {
  
  func testiPicImage() {
    let image1 = iPicImage(imageFilePath: UTConstants.imageFilePath)
    XCTAssertTrue(!image1.id.isEmpty)
    XCTAssertEqual(image1.version, 1)
    
    image1.json = NSUUID().UUIDString
    
    let data = NSKeyedArchiver.archivedDataWithRootObject(image1)
    let image2 = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! iPicImage
    XCTAssertEqual(image1.id, image2.id)
    XCTAssertEqual(image1.imageFilePath, image2.imageFilePath)
    XCTAssertEqual(image1.imageData?.length, image2.imageData?.length)
    XCTAssertEqual(image1.version, image2.version)
    XCTAssertEqual(image1.json as? String, image2.json as? String)
  }
}

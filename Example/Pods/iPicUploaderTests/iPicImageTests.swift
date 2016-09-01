//
//  iPicUploaderTests.swift
//  iPicUploaderTests
//
//  Created by Jason Zheng on 9/1/16.
//
//

import XCTest
import iPicUploader

class iPicImageTests: XCTestCase {
  
  func testImageHost() {
    let imageFilePath = "/Users/ipic/Downloads/pic.jpg"
    let image1 = iPicImage(imageFilePath: imageFilePath)
    XCTAssertTrue(!image1.id.isEmpty)
    
    let data = NSKeyedArchiver.archivedDataWithRootObject(image1)
    let image2 = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! iPicImage
    XCTAssertEqual(image1.id, image2.id)
    XCTAssertEqual(image1.imageFilePath, image2.imageFilePath)
    XCTAssertEqual(image1.imageData?.length, image2.imageData?.length)
  }
}

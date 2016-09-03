//
//  iPicUploaderTests.swift
//  iPicUploaderTests
//
//  Created by Jason Zheng on 9/1/16.
//
//

import XCTest
@testable import iPicUploader

class iPicUploaderTests: XCTestCase {
  var exception: XCTestExpectation?
  let waitTime: NSTimeInterval = 15
  var imageFilePath = ""
  
  override func setUp() {
    super.setUp()
    
    let bundle = NSBundle(forClass: self.dynamicType)
    imageFilePath = bundle.pathForResource("iPic", ofType: "png")!
  }
  
  func testUploadImageByFilePath() {
    exception = expectationWithDescription("testUploadImageByFilePath")
    
    iPic.uploadImage(imageFilePath) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testUploadImageByNSImage() {
    exception = expectationWithDescription("testUploadImageByNSImage")
    
    let image = NSImage(contentsOfFile: imageFilePath)
    iPic.uploadImage(image!) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testUploadImageByImageData() {
    exception = expectationWithDescription("testUploadImageByImageData")
    
    let imageData = NSData(contentsOfFile: imageFilePath)
    iPic.uploadImage(imageData!) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
}

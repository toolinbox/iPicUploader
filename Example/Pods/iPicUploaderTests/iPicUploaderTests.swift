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
  
  func testUploadImageByFilePath() {
    exception = expectationWithDescription("testUploadImageByFilePath")
    
    iPic.uploadImage(UTConstants.imageFilePath) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(UTConstants.waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testUploadImageByNSImage() {
    exception = expectationWithDescription("testUploadImageByNSImage")
    
    let image = NSImage(contentsOfFile: UTConstants.imageFilePath)
    iPic.uploadImage(image!) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(UTConstants.waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testUploadImageByImageData() {
    exception = expectationWithDescription("testUploadImageByImageData")
    
    let imageData = NSData(contentsOfFile: UTConstants.imageFilePath)
    iPic.uploadImage(imageData!) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectationsWithTimeout(UTConstants.waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
}

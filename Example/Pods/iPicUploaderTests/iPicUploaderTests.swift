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
    
  func testUploadImageByFilePath() {
    exception = expectationWithDescription("testUploadImageByFilePath")
    
    // TODO Change to app's icon
    let imageFilePath = "/Users/jason/Downloads/avatar.jpeg"
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
    
    //    let image = NSImage(named: "AppIcon")
    let imageFilePath = "/Users/jason/Downloads/avatar.jpeg"
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
    
    // TODO Change to app's icon
    let imageFilePath = "/Users/jason/Downloads/avatar.jpeg"
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

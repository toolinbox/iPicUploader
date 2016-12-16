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
    exception = expectation(description: "testUploadImageByFilePath")
    
    iPic.uploadImage(imageFilePath: UTConstants.imageFilePath) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectations(timeout: UTConstants.waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testUploadImageByNSImage() {
    exception = expectation(description: "testUploadImageByNSImage")
    
    let image = NSImage(contentsOfFile: UTConstants.imageFilePath)
    iPic.uploadImage(image: image!) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectations(timeout: UTConstants.waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
  
  func testUploadImageByImageData() {
    exception = expectation(description: "testUploadImageByImageData")
    
    let imageData = try? Data(contentsOf: URL(fileURLWithPath: UTConstants.imageFilePath))
    iPic.uploadImage(imageData: imageData!) { (imageLink, error) in
      XCTAssertNotNil(imageLink)
      XCTAssertNil(error)
      
      self.exception?.fulfill()
    }
    
    self.waitForExpectations(timeout: UTConstants.waitTime) { (error) in
      XCTAssertNil(error)
    }
  }
}

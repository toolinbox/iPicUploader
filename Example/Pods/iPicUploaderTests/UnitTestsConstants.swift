//
//  ConstantsTests.swift
//  Pods
//
//  Created by Jason Zheng on 9/3/16.
//
//

import XCTest

let UTConstants = UnitTestsConstants.sharedInstance

class UnitTestsConstants {
  // Singleton
  static let sharedInstance = UnitTestsConstants()
  private init() {}
  
  let waitTime: NSTimeInterval = 15
  
  var imageFilePath: String {
    let bundle = NSBundle(forClass: self.dynamicType)
    return bundle.pathForResource("iPic", ofType: "png")!
  }
}

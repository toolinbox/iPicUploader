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
  
  let waitTime: TimeInterval = 15
  
  var imageFilePath: String {
    let bundle = Bundle(for: type(of: self))
    return bundle.path(forResource: "iPic", ofType: "png")!
  }
}

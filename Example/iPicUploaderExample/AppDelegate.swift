//
//  AppDelegate.swift
//  iPicUploaderExample
//
//  Created by Jason Zheng on 9/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var mainWindowController: MainWindowController?

  func applicationDidFinishLaunching(aNotification: Notification) {
      
    let mainWindowController = MainWindowController()
    mainWindowController.showWindow(self)
    
    self.mainWindowController = mainWindowController
  }
}


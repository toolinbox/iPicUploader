//
//  MainWindowController.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa
import iPicUploader

class MainWindowController: NSWindowController {
  override var windowNibName: String? {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    let imageFilePath = "/Users/jason/Downloads/1.jpg"
    iPic.uploadImage(imageFilePath) { (imageLink, error) in
      print(imageLink)
      print(error)
    }
  }
}
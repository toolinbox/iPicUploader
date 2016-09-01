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
    
    let fileList = [
      "/Users/jason/Downloads/1.jpg",
//      "/Users/jason/Downloads/TestSource/中文.jpg",
//      "/Users/jason/Downloads/TestSource/中文ファ한국~!@#$%^&*()_+`=[]{}|;,.&%< >'.jpg",
//      "/Users/jason/Downloads/TestSource/Big.png",
    ]
    for imageFilePath in fileList {
      iPic.uploadImage(imageFilePath) { (imageLink, error) in
        var result = (NSURL(string: imageFilePath)?.lastPathComponent ?? imageFilePath) + " "
        if let imageLink = imageLink {
          result += imageLink
        } else if let error = error {
          result += error.localizedDescription
        }
        print(result)
      }
    }
  }
}
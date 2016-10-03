//
//  iPicUploadHelper.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public class iPicUploadHelper {
  private static let iPicBundleIdentifier = "net.toolinbox.ipic"
  private static let iPicURLScheme = "ipic://"
  
  // MARK: Static Method
  
  internal static func isiPicRunning() -> Bool {
    return !NSRunningApplication.runningApplications(withBundleIdentifier: iPicBundleIdentifier).isEmpty
  }
  
  internal static func launchiPic() -> NSError? {
    guard !isiPicRunning() else {
      return nil
    }
    
    do {
      let schemeURL = URL(string: iPicURLScheme)!
      try NSWorkspace.shared().open(schemeURL, options: .withoutActivation, configuration: [:])
      return nil
    } catch {
      return iPicUploadError.iPicNotInstalled
    }
  }
  
  public static func generateiPicImage(_ imageFilePath: String) -> (iPicImage?, NSError?) {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: imageFilePath)) else {
      return (nil, iPicUploadError.FileInaccessable)
    }
    
    guard let _ = NSImage(data: data) else {
      return (nil, iPicUploadError.InvalidImageFile)
    }
    
    let image = iPicImage(imageFilePath: imageFilePath)
    image.imageData = data
    
    return (image, nil)
  }
  
  public static func generateiPicImage(_ image: NSImage) -> (iPicImage?, NSError?) {
    guard let imageData = imageDataOf(image, type: .JPEG) else {
      return (nil, iPicUploadError.Unknown) // Should not happen
    }
    
    let image = iPicImage(imageData: imageData)
    
    return (image, nil)
  }
  
  public static func generateImageDataListFrom(_ pasteboard: NSPasteboard) -> [Data] {
    var imageDataList = [Data]()
    
    if let pasteboardItems = pasteboard.pasteboardItems {
      for pasteboardItem in pasteboardItems {
        if let imageData = generateImageDataFrom(pasteboardItem) {
          imageDataList.append(imageData)
        }
      }
    }
    
    return imageDataList
  }
  
  private static func generateImageDataFrom(_ pasteboardItem: NSPasteboardItem) -> Data? {
    for type in pasteboardItem.types {
      if let data = pasteboardItem.data(forType: type) {
        if type == String(kUTTypeFileURL) {
          let url = URL(dataRepresentation: data, relativeTo: nil)
          if let imageData = try? Data(contentsOf: url!), let _ = NSImage(data: imageData) {
            return imageData
          }
          
        } else if let _ = NSImage(data: data) {
          return data
        }
      }
    }
    
    return nil
  }
  
  internal static func imageDataOf(_ image: NSImage, type: NSBitmapImageFileType) -> Data? {
    guard let imageData = image.tiffRepresentation else {
      return nil
    }
    
    if type == NSBitmapImageFileType.TIFF {
      return imageData
    }
    
    guard let imageRep = NSBitmapImageRep(data: imageData) else {
      return nil
    }
    
    return imageRep.representation(using: type, properties: [:])
  }
  
  internal static func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
}

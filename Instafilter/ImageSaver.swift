//
//  ImageSaver.swift
//  Instafilter
//
//  Created by 최준영 on 2023/01/05.
//

import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(inputImg: UIImage) {
        UIImageWriteToSavedPhotosAlbum(inputImg, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Something is done")
    }
}

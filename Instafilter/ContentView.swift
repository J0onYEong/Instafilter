//
//  ContentView.swift
//  Instafilter
//
//  Created by 최준영 on 2023/01/01.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var isShowingImagePicker = false
    
    @State private var intensity = 0.0
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let contenxt = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    ZStack {
                        LinearGradient(colors: [.white, .secondary], startPoint: .topLeading, endPoint: .bottomTrailing)
                        Text("Tap to select image")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .zIndex(0)
                    image?
                        .resizable()
                        .scaledToFit()
                        .zIndex(1)
                }
                .frame(height: 200)
                .padding(10)
                .onTapGesture {
                    isShowingImagePicker = true
                }
                
                VStack {
                    Text("intensity")
                    Slider(value: $intensity)
                        .padding([.trailing, .leading], 20)
                        .onChange(of: intensity) { _ in
                            applyingFilter()
                        }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {}
                    Spacer()
                    Button("Save") { save() }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Instafilter")
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(uiImage: $inputImage)
            }
            .onChange(of: inputImage) { _ in
                loadImage()
            }
        }
    }
    
    func save() {
        
    }
    
    func loadImage() {
        guard let inputImg = inputImage else {
            fatalError("Image doesn't exist")
        }
        let ciImg = CIImage(image: inputImg)
        currentFilter.setValue(ciImg, forKey: kCIInputImageKey)
        applyingFilter()
    }
    
    func applyingFilter() {
        currentFilter.setValue(Float(intensity), forKey: kCIInputIntensityKey)
        guard let output = currentFilter.outputImage else {
            return
        }
        if let cgImg = contenxt.createCGImage(output, from: output.extent) {
            let uiImg = UIImage(cgImage: cgImg)
            self.image = Image(uiImage: uiImg)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

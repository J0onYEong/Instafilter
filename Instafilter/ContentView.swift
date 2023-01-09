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
    
    @State private var intensity = 0.01
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterConfirmationDialog = false
    
    @State private var showingEmptyImageAlert = false
    
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
                    Slider(value: $intensity, in: 0.01...1.0)
                        .padding([.trailing, .leading], 20)
                        .onChange(of: intensity) { _ in
                            applyingFilter()
                        }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") { showingFilterConfirmationDialog = true }
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
            .confirmationDialog("Set filter", isPresented: $showingFilterConfirmationDialog) {
                Button("Crystallize") { setFilter(filter: CIFilter.crystallize()) }
                    .disabled(currentFilter.name == CIFilter.crystallize().name)
                Button("Edges") { setFilter(filter: CIFilter.edges()) }
                    .disabled(currentFilter.name == CIFilter.edges().name)
                Button("Gaussian Blur") { setFilter(filter: CIFilter.gaussianBlur()) }
                    .disabled(currentFilter.name == CIFilter.gaussianBlur().name)
                Button("Pixellate") { setFilter(filter: CIFilter.pixellate()) }
                    .disabled(currentFilter.name == CIFilter.pixellate().name)
                Button("Sepia Tone") { setFilter(filter: CIFilter.sepiaTone()) }
                    .disabled(currentFilter.name == CIFilter.sepiaTone().name)
                Button("Unsharp Mask") { setFilter(filter: CIFilter.unsharpMask()) }
                    .disabled(currentFilter.name == CIFilter.unsharpMask().name)
                Button("Vignette") { setFilter(filter: CIFilter.vignette()) }
                    .disabled(currentFilter.name == CIFilter.vignette().name)
                Button("Cancel", role: .cancel) { }
            }
            .alert("Empty Image", isPresented: $showingEmptyImageAlert) {
                Button("Ok") {}
            } message: {
                Text("select image before filtering")
            }
        }
    }
    
    func save() {
        
    }
    
    func setFilter(filter: CIFilter) {
        currentFilter = filter
        intensity = 0.01
        loadImage()
    }
    
    func loadImage() {
        guard let inputImg = inputImage else {
            showingEmptyImageAlert = true
            return
        }
        let ciImg = CIImage(image: inputImg)
        currentFilter.setValue(ciImg, forKey: kCIInputImageKey)
        applyingFilter()
    }
    
    func applyingFilter() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity * 10, forKey: kCIInputScaleKey) }
        
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

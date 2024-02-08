//
//  ContentView.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-07.
//

import SwiftUI

struct PhotoGridView: View {
    @StateObject var mockData = MockUnsplashData()
    
    var frameSizeWidth: Int
    var frameSizeHeight: Int
    
    init() {
        self.frameSizeWidth = Int(UIScreen.main.bounds.width) < Int(UIScreen.main.bounds.height) ? Int(UIScreen.main.bounds.width) : Int(UIScreen.main.bounds.height)
        self.frameSizeHeight = Int(UIScreen.main.bounds.width) < Int(UIScreen.main.bounds.height) ? Int(UIScreen.main.bounds.height) : Int(UIScreen.main.bounds.width)
        
    }
    
    
    var body: some View {
        NavigationView {
            ScrollViewReader { value in
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                        ForEach(mockData.imageArray) { imageObj in
                            let color: Color = Color(hex: imageObj.color!)
                            let w = CGFloat(frameSizeWidth) / 2 - 10;
                            let h = CGFloat((Int(w) * imageObj.height!) / imageObj.width!)

                            NavigationLink(destination: PhotoDetailsView(imageObj: imageObj, w: w, h: h, color: color)) {
                                VStack{
                                    Spacer()
                                    UnsplashImageView(urlString: (imageObj.urls?.thumb)!, color: color, size: CGSize(width: w, height: h))
                                        .aspectRatio(contentMode: .fit)
                                    Spacer()
                                }.background(color.opacity(0.25))
                                
                            }
                        }
                    }.navigationTitle("Grid")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView()
    }
}

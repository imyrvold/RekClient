//
//  PhotoView.swift
//  RekClient (iOS)
//
//  Created by Ivan C Myrvold on 17/05/2021.
//

import SwiftUI

struct PhotoView: View {
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    @ObservedObject var loginHandler: LoginHandler
    private var isButtonDisabled: Bool {
        image == UIImage()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    Button(action: { showPhotoLibrary = true }) {
                        HStack {
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                            
                            Text("Photo library")
                                .font(.headline)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                }
                .sheet(isPresented: $showPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                }
                .navigationTitle("Photos")
                .toolbar {
                    Button(action: {
                        if let data = image.jpegData(compressionQuality: 1) {
                            loginHandler.uploadToS3(image: data)
                        }
                    }, label: {
                        Text("Labels")
                    })
                    .disabled(isButtonDisabled)
                }
                
                ErrorSheetView(isOpen: $loginHandler.error, maxHeight: 250) {
                    VStack {
                        HStack {
                            Image(systemName: "xmark.octagon.fill")
                                .renderingMode(.original)

                            Text("Error!")
                        }
                        .font(.title)
                        .padding([.bottom, .top])

                        Text(loginHandler.errorText)
                            .font(.footnote)
                            .padding()

                        Spacer()
                        
                        Button("Cancel") {
                            loginHandler.cancelError()
                        }
                        .padding(.bottom, 70)
                    }
                }
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)

            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHandler = LoginHandler()
        PhotoView(loginHandler: loginHandler)
    }
}

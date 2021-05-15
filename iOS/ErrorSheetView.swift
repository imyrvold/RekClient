//
//  ErrorSheetView.swift
//  RekClient
//
//  Created by Ivan C Myrvold on 15/05/2021.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
}

struct ErrorSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight //+ 32
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.content
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: self.offset)
        }
        .ignoresSafeArea()
    }
}

struct ErrorSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorSheetView(isOpen: .constant(true), maxHeight: 250) {
            VStack {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                        .renderingMode(.original)
                        .font(.title)

                    Text("Error!")
                        .font(.title)
                }
                .padding([.bottom, .top])

                Text("Your login failed! Some more text. More text. More text.")
                    .font(.headline)

                Spacer()
                
                Button("Cancel") {
                    
                }
                .padding(.bottom)
            }
        }
    }
}

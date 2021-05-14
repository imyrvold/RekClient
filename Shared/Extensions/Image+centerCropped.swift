//
//  Image+centerCropped.swift
//  RekClient
//
//  Created by Ivan C Myrvold on 02/05/2021.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}

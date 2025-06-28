//
//  ErrorSnackBar.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 29/6/2025.
//
import SwiftUI

struct ErrorSnackBar:View {
    var message: String
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                // Left icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                Spacer()
                
                // Error Message text
                Text(message)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
//                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                // Close icon
                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
            }
            .frame(maxWidth: 430, maxHeight: 56)
            .padding()
            .background(Color.red)
            .cornerRadius(20)
            .shadow(radius: 5)
            .transition(.opacity)
            .animation(.easeInOut, value: isVisible)
        }
    }
}

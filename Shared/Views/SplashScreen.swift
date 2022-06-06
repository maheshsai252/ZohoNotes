//
//  SplashScreen.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 05/06/22.
//

import SwiftUI

struct SplashScreen: View {
    @State var degrees: Double = 0
    @Environment(\.colorScheme) var colorScheme
    var imageName: String {
        if colorScheme == .dark {
            return "darksplash"
        } else {
            return "colorsplash"
        }
    }
    var bgColor: Color {
        if colorScheme == .dark {
            return Color.black
        } else {
            return Color.white
        }
    }
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea(.all, edges: .all)
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .padding()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(degrees > 270 ? 0.75 : 1.3)
                        .rotationEffect(.init(degrees: degrees))
                    Spacer()
                }
                Text("Zoho Notes")
                    .foregroundColor(.purple)
                    .bold()
                    .font(.custom("SignPainter", size: 50))
                    .scaleEffect(degrees > 270 ? 0.75 : 1.3)
                Spacer()
            }.onAppear() {
                change()
            }
        }
        
    }
    func change() {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true){ t in
            withAnimation(.easeIn) {
                degrees += 180
            }
            if degrees == 360 {
                t.invalidate()
            }
            
        }
        
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .preferredColorScheme(.dark)
    }
}

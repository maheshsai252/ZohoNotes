//
//  FullPhotoView.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 03/06/22.
//

import Foundation

import SwiftUI

struct FullPhotoView: View {
//    var image: UIImage
    @ObservedObject var notesViewModel: NotesViewModel
    @State var amount: CGFloat = 1
    @GestureState var scale: CGFloat = 1
    @State var degrees: Double = 0
    @Binding var viewFullPhoto: Bool
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Spacer()
                if let data = notesViewModel.selectedNote?.image, let image = UIImage(data: data) {
                Image(uiImage: image)
                    
                    .resizable()
                    .scaledToFit()
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))

                    .scaleEffect(amount)
                    .rotationEffect(Angle(degrees: degrees))
                    .draggable()
                    .gesture(MagnificationGesture()
                                .updating($scale, body: { (value, scale, trans) in
                                    amount = value.magnitude
                                })
                    )
                }
                Spacer()
                HStack {
                    Button {
                        
                        withAnimation(.linear(duration: 0.5)) {
                            notesViewModel.goBack()
                        }
                    } label: {
                        Image(systemName: "arrow.left.square")
                            .resizable()
                            .frame(width: 40 , height: 40, alignment: .center)
                            .disabled(!notesViewModel.canGoBack())
                            
                    }
                    Button {
                        withAnimation {
                            notesViewModel.navigateToOriginal()
                        }
                    } label: {
                        Text("Reset to Selected")
                            .padding()
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(notesViewModel.selectedNote == notesViewModel.temporaryNote ? Color.black : Color.blue, lineWidth: 2)
                                    )
                            .disabled(notesViewModel.selectedNote == notesViewModel.temporaryNote)
                            .padding()
                        
                    }
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            notesViewModel.goFront()
                        }
                    } label: {
                        Image(systemName: "arrow.right.square")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .disabled(!notesViewModel.canGoFront())
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.interactiveSpring()) {
                        viewFullPhoto = false
                    }
                    notesViewModel.clearTemporaryNote()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .clipShape(Circle())
                        
                }
            }
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    withAnimation {
                        degrees = (degrees + 90).truncatingRemainder(dividingBy: 360.0)
                    }
                } label: {
                    Image(systemName: "rotate.left")
                }
                Button {
                    withAnimation {
                        degrees = (degrees - 90).truncatingRemainder(dividingBy: 360.0)
                    }
                } label: {
                    Image(systemName: "rotate.right")
                }
            }
        }
        
    }
}
struct DraggableView: ViewModifier {
    @State var offset = CGPoint(x: 0, y: 0)
    
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let newx = self.offset.x + (value.location.x - value.startLocation.x)
                    let newy = self.offset.y + (value.location.y - value.startLocation.y)

                    if abs(newx) < UIScreen.main.bounds.width && abs(newy) < UIScreen.main.bounds.height/2 {
                        self.offset.x = newx
                        self.offset.y = newy
                    }
                    
            })
            .offset(x: offset.x, y: offset.y)
    }
}
extension View {
    func draggable() -> some View {
        return modifier(DraggableView())
    }
}

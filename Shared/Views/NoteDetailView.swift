//
//  NoteDetailView.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 03/06/22.
//

import SwiftUI

struct NoteDetailView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @State var viewFullPhoto = false
    @Namespace private var animation
    var note: Note? {
        notesViewModel.selectedNote
    }
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { proxy in
            if viewFullPhoto {
                FullPhotoView(notesViewModel: notesViewModel, viewFullPhoto: $viewFullPhoto)
                    .matchedGeometryEffect(id: "Album", in: animation)
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))

            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        if let data = note?.image, let image = UIImage(data: data) {
                            
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: proxy.size.width, height: proxy.size.height/4, alignment: .leading)
                                .matchedGeometryEffect(id: "Album", in: animation)
                                .onTapGesture {
                                        viewFullPhoto = true
                                        notesViewModel.makeTemporaryNote()
                                        notesViewModel.locateNote()
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 25) {
                            Text(note?.title ?? "")
                                .font(.title)
                            Text(note?.createdDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                                .font(.caption)
                            Text(LocalizedStringKey(note?.body ?? ""))
                                .font(.body)
                        }.padding(5)
                            .opacity(viewFullPhoto ? 0 : 1)
                        
                    }
                    
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewFullPhoto {

                    Button {
                        dismiss()
                        notesViewModel.clearSelection()
                    } label: {
                        Image(systemName: "arrow.backward.circle")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .clipShape(Circle())
                            .padding([.top, .trailing])
                            .padding(.bottom,4)
                            .foregroundColor(.primary)
                    }.padding(.bottom)

                }
                }
            }
       
    }
}

//struct NoteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteDetailView()
//    }
//}

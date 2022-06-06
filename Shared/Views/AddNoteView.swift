//
//  AddNoteView.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 02/06/22.
//

import SwiftUI

struct AddNoteView: View {
    enum FocusField: Hashable {
        case field
        case editor
    }
    @State var title = ""
    @State var noteBody = ""
    @State var focussedToField = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State var height: CGFloat = 30
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    @State var backgroudColor: Color = .random
    @State var alertForParameters = false
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack {
                        TextField("Title", text: $title)
                            .font(.title)
                            .padding([.leading,.top])
                        ZStack(alignment: .leading) {
                            if noteBody.isEmpty {
                                VStack {
                                    Text("Write something...")
                                        .padding(.top, 10)
                                        .padding(.leading)
                                        .opacity(1.2)
                                    Spacer()
                                }
                            }
                            
                            TextEditor(text: $noteBody)
                                .frame(maxHeight: .infinity)
                                .opacity(noteBody.isEmpty ? 0.85 : 1)
                                .padding(.leading)
                        }
                    }
                    .frame(minHeight: proxy.size.height)
                    .alert("Title and Body can't be empty", isPresented: $alertForParameters) {
                        Button {
                            alertForParameters = false
                        } label: {
                            Text("OK")
                        }

                    }
                }
                .frame(maxHeight: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(backgroudColor))
                .padding(5)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
            }
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .padding(5)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Add Note")
                        .bold()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                   
                    Button {
                        backgroudColor = Color.random
                    } label: {
                        Circle()
                            .fill(backgroudColor)
                            .frame(width: 25, height: 25, alignment: .center)
                    }

                    Button {
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "paperclip.circle")
                            .foregroundColor(inputImage != nil ? .purple : .primary)
                            .padding(5)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button {
                        do {
                            let color = try NSKeyedArchiver.archivedData(withRootObject: UIColor(backgroudColor), requiringSecureCoding: false)
                            if !title.isEmpty && !noteBody.isEmpty {
                                notesViewModel.addNote(title: title, body: noteBody, image: inputImage, color: color)
                            } else {
                                alertForParameters = true
                            }
                        } catch {
                            print(error)
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                            .foregroundColor(.purple)
                            .padding(6)
                            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                    
                }
            }
            
        }
    }
}

//struct AddNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNoteView()
//    }
//}
extension String {
    func numberOfLines() -> Int {
        return self.numberOfOccurrencesOf(string: "\n") + 1
    }
    
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
    
}

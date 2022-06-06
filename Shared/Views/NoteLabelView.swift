//
//  NoteLabelView.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 02/06/22.
//

import SwiftUI

struct NoteLabelView: View {
    @ObservedObject var note: Note
    @ObservedObject var notesViewModel: NotesViewModel

    var body: some View {
            ZStack {
                if let backgroundColorData = note.backgroundColor {
                    Color.getColour(data: backgroundColorData)
                } else {
                    Color.random
                }
                VStack {
                    Text(note.title ?? "")
                        .lineLimit(nil)
                        .padding()
                    Text(note.createdDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                        .font(.caption)
                }
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .padding([.top, .horizontal])
            .transition(.slide)
            .onTapGesture {
                withAnimation {
                    notesViewModel.selectNote(note: note)
                }
            }

        
        

       
    }
}
//
//struct NoteLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteLabelView(note: Note(context: PersistenceController.shared.container.viewContext))
//    }
//}

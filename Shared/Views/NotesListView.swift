//
//  NotesListView.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 02/06/22.
//

import SwiftUI

struct NotesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var notesViewModel: NotesViewModel
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                NotesGroupGridView(notesViewModel: notesViewModel)
            }
            if notesViewModel.showDetail {
                NavigationLink("", isActive: $notesViewModel.showDetail) {
                    NoteDetailView(notesViewModel: notesViewModel)
                }
            }
        }.navigationTitle(Text("Notes"))
    }
}

//struct NotesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotesListView()
//    }
//}

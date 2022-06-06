//
//  EntryTabView.swift
//  ZohoNotes
//
//  Created by Mahesh sai on 05/06/22.
//

import SwiftUI

struct EntryTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var addNote = false
    @StateObject var notesViewModel = NotesViewModel()
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                NotesListView(notesViewModel: notesViewModel)
                Button {
                    addNote = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(.largeTitle))
                            .frame(width: 70, height: 50)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                }
                .background(Color.purple)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
            }.sheet(isPresented: $addNote) {
                AddNoteView(notesViewModel: notesViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }

}

struct EntryTabView_Previews: PreviewProvider {
    static var previews: some View {
        EntryTabView()
    }
}

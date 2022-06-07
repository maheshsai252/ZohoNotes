//
//  NotesGroupGrid.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 04/06/22.
//

import SwiftUI

//We can make use of new SwiftUI 4 APIs such as Grid and Layout along with Navigation stack announced in WWDC22

struct NotesGroupGridView: View {
    
    @ObservedObject var notesViewModel: NotesViewModel
    var body: some View {
        ForEach(notesViewModel.notesGrid) { currentGroup in
            if currentGroup.group.count != 1 {
                HStack(alignment: .top) {
                    ForEach(currentGroup.group, id: \.self) { columnData in
                        LazyVStack {
                            ForEach(columnData) {data in
                                NoteLabelView(note: data, notesViewModel: notesViewModel)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    ForEach(currentGroup.group, id: \.self) { columnData in
                        NoteLabelView(note: columnData[0], notesViewModel: notesViewModel)
                    }
                }
            }
        }
    }
}

//struct NotesGroupGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        NotesGroupGridView()
//    }
//}

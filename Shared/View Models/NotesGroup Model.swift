//
//  NotesModels.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 04/06/22.
//

import Foundation

struct NotesGroup: Identifiable {
    var id = UUID()
    var columns: Int
    var group: [[Note]] = []
    var currentIndex = 0
    var totalCount = 0
    init(columns: Int) {
        self.columns = columns
        self.group = Array(repeating: [], count: columns)
    }
    /// Add note into notes group
    /// - Parameter note: note
    mutating func insert(note: Note) {
        self.group[currentIndex].append(note)
        if currentIndex == (columns-1) {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
        self.totalCount += 1
    }
    /// Verifies if there is space in current group
    /// - Returns: boolean variable indicating true if group is full
    func isFull() -> Bool {
        if self.totalCount % columns == 0 {
            return true
        }
        return false
    }
    
}

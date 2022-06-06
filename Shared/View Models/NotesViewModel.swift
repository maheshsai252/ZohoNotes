//
//  NotesViewModel.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 03/06/22.
//

import Foundation
import UIKit
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var imageNotes: [Note] = [] // Notes containing images
    var notesCoreDataHandler = NoteCoreDataHandler()
    @Published var selectedNote: Note? // Selected Note
    @Published var showDetail = false // Show details of selected note
    @Published var currentImageIndex: Int? // image of selected note
    @Published var temporaryNote: Note? // temporary variable to reset image
    @Published var notesGrid: [NotesGroup] = [] // Notes Grid
    init() {
        notes = notesCoreDataHandler.fetchAllNotes() // fetches notes from persistent storage
        syncRemoteNotes() // fetches remote notes
//        makeGrid() // make grid
        imageNotes = notes.filter({$0.image != nil }) // make image notes
    }
    /// fetches remote notes
    func syncRemoteNotes() {
        Task {
            do {
                let remoteNotes = try await APIFetcher.fetchNotes()
                print(remoteNotes)
                for remoteNote in remoteNotes {
                    if !self.notes.contains(where: {$0.title == remoteNote.title}) {
                        let newNote = self.notesCoreDataHandler.makeNote(from: remoteNote)
                        print(newNote)
                        DispatchQueue.main.async {
                            self.notes.append(newNote)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.notes = self.notes.sorted(by: {$0.createdDate ?? Date() > $1.createdDate ?? Date()})
                    self.makeGrid()
                    self.imageNotes = self.notes.filter({$0.image != nil })
                }
            } catch {
                print(error)
            }
        }
    }
    /// Add Note using core data
    /// - Parameters:
    ///   - title: title of note
    ///   - body: note body
    ///   - image: image of note
    ///   - color: background color of note
    func addNote(title: String, body: String, image: UIImage?, color: Data) {
        let newNote = NoteCoreDataHandler().addNote(title: title, body: body , image: image, color: color)
        withAnimation {
            notes.insert(newNote, at: 0)
            makeGrid()
            self.imageNotes = self.notes.filter({$0.image != nil })
        }
    }
    /// locate index of current selected note
    func locateNote() {
        if let selectedNote = selectedNote {
            currentImageIndex = imageNotes.firstIndex(of: selectedNote)
        }
    }
    /// move to next image
    func goFront() {
        if let currentImageIndex = currentImageIndex, currentImageIndex+1 < imageNotes.count {
            self.currentImageIndex = currentImageIndex + 1
            self.selectedNote = imageNotes[currentImageIndex+1]
        }
        
    }
    /// move to previous image
    func goBack() {
        if let currentImageIndex = currentImageIndex, currentImageIndex-1 >= 0 {
            self.currentImageIndex = currentImageIndex - 1
            self.selectedNote = imageNotes[currentImageIndex-1]
        }
    }
    /// store current note in temporary variable for reseting image
    func makeTemporaryNote() {
        self.temporaryNote = selectedNote
    }
    /// clear current note from temporary variable
    func clearTemporaryNote() {
        self.temporaryNote = nil
    }
    /// Reset to selected image
    func navigateToOriginal() {
        self.selectedNote = temporaryNote
    }
    /// return if moving to next image possible
    func canGoFront() -> Bool {
        if let currentImageIndex = currentImageIndex, currentImageIndex+1 < imageNotes.count {
            return true
        }
        return false
    }
    ///return if moving to previous image possible
    func canGoBack() -> Bool {
        if let currentImageIndex = currentImageIndex, currentImageIndex-1 >= 0 {
            return true
        }
        return false
    }
    /// select note to show detail
    /// - Parameter note: note
    func selectNote(note: Note) {
            selectedNote = note
            showDetail = true
    }
    func clearSelection() {
        selectedNote = nil
        showDetail = false
    }
    /// make grid array from notes array
    func makeGrid() {
        var list: [NotesGroup] = []
        var currentGroup: NotesGroup?
        var previousGroup:NotesGroup?
        for i in self.notes {
            if i.image == nil {
                // if group already started then add into group
                if let _ = currentGroup {
                    currentGroup?.insert(note: i)
                } else {
//                    print(i.title, previousGroup?.isFull())
                    if !(previousGroup?.isFull() ?? true) {
                        // add to previous group before image row if there is space in it
                        previousGroup?.insert(note: i)
                        if let idx = list.firstIndex(where: {$0.id == previousGroup?.id}) {
                            print("list idx", idx)
                            list[idx].insert(note: i)
                        }
                    } else {
                        //create a new group
                        var columns = 2
                        if !(UIDevice.current.userInterfaceIdiom == .phone) {
                            columns = 3
                        }
                        currentGroup = NotesGroup(columns: columns)
                        currentGroup?.insert(note: i)
                    }
                }
            } else {
                if let current = currentGroup {
                    list.append(current)
                    previousGroup = currentGroup
                    currentGroup = nil

                }
                var ng = NotesGroup(columns: 1)
                ng.insert(note: i)
                list.append(ng)
            }
        }
        if let current = currentGroup, !list.contains(where: {$0.id == currentGroup?.id}) {
            list.append(current)
        }
        self.notesGrid = list
    }
}

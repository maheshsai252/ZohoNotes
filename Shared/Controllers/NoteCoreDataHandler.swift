//
//  NoteCoreDataHandler.swift
//  ZohoNotes (iOS)
//
//  Created by Mahesh sai on 02/06/22.
//

import Foundation
import UIKit
import CoreData

struct NoteCoreDataHandler {
    let context = PersistenceController.shared.container.viewContext
    func addNote(title: String, body: String, image: UIImage?, color: Data) -> Note {
        let newNote = Note(context: context)
        newNote.title = title
        newNote.body = body
//        newNote.image =
        if let image = image, let data = image.jpegData(compressionQuality: 0.5) {
            newNote.image = data
        }
        newNote.createdDate = Date()
        newNote.id = UUID()
        newNote.backgroundColor = color
        save()
        return newNote
    }
    func makeNote(from remoteNote: RemoteNote) -> Note {
        let newNote = Note(context: context)
        newNote.title = remoteNote.title
        newNote.body = remoteNote.body
//        newNote.image =
        if let imageurl = remoteNote.image, let url = URL(string: imageurl), let data = try? Data(contentsOf: url) {
            newNote.image = data
        }
        newNote.createdDate = Date(timeIntervalSince1970: TimeInterval(Int(remoteNote.time) ?? 0))
        newNote.id = UUID()
        save()
        return newNote
    }
    func fetchAllNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        var notes = [Note]()
        do {
            notes = try context.fetch(fetchRequest) as? [Note] ?? []
        }
        catch {
            print(error)
        }
        return notes
    }
    func fetchNotesWithImages() -> [Note] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "image != nil")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        var notes = [Note]()
        do {
            notes = try context.fetch(fetchRequest) as? [Note] ?? []
        }
        catch {
            print(error)
        }
        return notes
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

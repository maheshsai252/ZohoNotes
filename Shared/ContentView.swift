//
//  ContentView.swift
//  Shared
//
//  Created by Mahesh sai on 02/06/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var showSplash = true
    var body: some View {
        ZStack {
            EntryTabView()
            if showSplash == true {
                SplashScreen()
            }
        }.onAppear() {
            stop()
        }
    }
    func stop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut) {
                self.showSplash = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

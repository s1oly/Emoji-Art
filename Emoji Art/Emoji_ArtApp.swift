//
//  Emoji_ArtApp.swift
//  Emoji Art
//
//  Created by S1OLY on 9/28/23.
//

import SwiftUI

@main
struct Emoji_ArtApp: App {
    @State private var defaultDocument = EmojiArtDocument()
    @StateObject private var paletteStore = PaletteStore(named: "Main")
    @StateObject private var paletteStore2 = PaletteStore(named : "Second")
    @StateObject private var paletteStore3 = PaletteStore(named: "Third")
    var body: some Scene {
        WindowGroup {
//            PaletteManager(stores: [paletteStore,paletteStore2, paletteStore3])
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
        }
    }
}

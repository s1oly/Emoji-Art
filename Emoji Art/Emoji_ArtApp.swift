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
    @State private var paletteStore = PaletteStore(named: "Main")
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
                .environment(paletteStore)
        }
    }
}

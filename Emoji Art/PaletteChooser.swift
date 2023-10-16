//
//  PaletteChooser.swift
//  Emoji Art
//
//  Created by S1OLY on 10/7/23.
//

import SwiftUI
import Observation

struct PaletteChooser: View {
    
    @Environment(PaletteStore.self) private var store 
    
    var body: some View {
        HStack{
            chooser
            view(for : store.palettes[store.cursorIndex])
        }
    }
    
    var chooser : some View {
        Button {
            store.cursorIndex = store.cursorIndex + 1
        } label:{
            Image(systemName: "paintpalette")
        }
    }
    
    func view(for palette : Palette) -> some View {
        HStack{
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    PaletteChooser()
        .environment(PaletteStore(named: "Preview"))
}

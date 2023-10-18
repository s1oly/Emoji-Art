//
//  PaletteList.swift
//  Emoji Art
//
//  Created by S1OLY on 10/18/23.
//

import SwiftUI

struct PaletteList: View {
    @EnvironmentObject var store : PaletteStore
    var body: some View {
        NavigationStack{
            List(store.palettes){palette in
                NavigationLink(value: palette){
                    Text(palette.name)
                }
            }
            .navigationDestination(for: Palette.self){palette in
                PaletteView(palette: palette)
            }
            .navigationTitle(Text("\(store.name) Palettes"))
        }
    }
}

struct EditablePaletteList: View {
    @ObservedObject var store : PaletteStore
    
    @State private var showCursorPalette = false
    
    var body: some View {
            List{
                ForEach(store.palettes){palette in
                    NavigationLink(value: palette.id){
                        VStack(alignment : .leading){
                            Text(palette.name)
                            Text(palette.emojis).lineLimit(1)
                        }
                        
                    }
                }
                .onDelete{indexSet in
                    withAnimation{
                        store.palettes.remove(atOffsets: indexSet)
                    }
                }
                .onMove{indexSet, newOffset in
                    withAnimation{
                        store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                    }
                }
            }
            .navigationDestination(for: Palette.ID.self){paletteID in
                if let index = store.palettes.firstIndex(where: {$0.id == paletteID}){
                    PaletteEditor(palette: $store.palettes[index])
                }
            }
            .navigationDestination(isPresented: $showCursorPalette){
                PaletteEditor(palette: $store.palettes[store.cursorIndex])
            }
            .navigationTitle(Text("\(store.name) Palettes"))
            .toolbar{
                Button{
                    store.insert(name: "", emojis: "")
                    showCursorPalette = true
                } label: {
                    Image(systemName : "plus")
                }
            }
    }
}

struct PaletteView : View{
    let palette : Palette
    var body : some View{
        VStack{
            LazyVGrid(columns : [GridItem(.adaptive(minimum: 40))]){
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self){emoji in
                    NavigationLink(value : emoji){
                        Text(emoji)
                    }
                    
                }
            }
            .navigationDestination(for: String.self){emoji in
                Text(emoji).font(.system(size: 300))
            }
            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .navigationTitle(palette.name)
    }
}

#Preview {
    PaletteList()
}

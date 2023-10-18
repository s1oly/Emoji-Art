//
//  SwiftUIView.swift
//  Emoji Art
//
//  Created by S1OLY on 10/17/23.
//

import SwiftUI

struct PaletteEditor: View {
   @Binding var palette : Palette
    private let emojiFont = Font.system(size: 40)
    
    @State private var emojisToAdd : String = " "
    
    enum Focused{
        case name
        case addEmojis
    }
    
    @FocusState private var focused : Focused?
    
    
    var body: some View {
        Form{
            Section(header : Text("Name")){
                TextField("Name", text : $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header : Text("Emojis")){
                TextField("Add Emojis Here", text : $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd, initial: false){emojisToAdd, _ in
                        palette.emojis = (emojisToAdd + palette.emojis)
                            .filter{ $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear{
            if palette.name.isEmpty{
                focused = .name
            }
            else{
                focused = .addEmojis
            }
        }
    }
    
    var removeEmojis : some View{
        VStack(alignment: .trailing){
            Text("Tap to Remove Emojis").font(.caption).foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]){
                ForEach (palette.emojis.uniqued.map(String.init), id : \.self) {emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation{
                                palette.emojis.remove(emoji.first!)
                                emojisToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
}

struct Preview2: View {
    @State private var palette = PaletteStore(named: "Previews").palettes.first!
    var body : some View{
        PaletteEditor(palette: $palette)
    }
}

#Preview {
    Preview2()
}

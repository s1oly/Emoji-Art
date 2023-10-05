//
//  EmojiArtView.swift
//  Emoji Art
//
//  Created by S1OLY on 10/3/23.
//

import SwiftUI
import Observation

struct EmojiArtDocumentView: View {
    
    @Bindable var document : EmojiArtDocument
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    private let palleteEmojiSize : CGFloat = 40
    
    var body: some View {
        VStack(spacing : 0){
            documentBody
            ScrollingEmojis(emojis)
                .font(.system(size: palleteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
        
    }
    
    private var documentBody : some View{
        GeometryReader {geometry in
            ZStack{
                Color.white
                AsyncImage(url: document.background)
                    .position(Emojis.Position.zero.in(geometry))
                ForEach(document.emojis){ emoji in
                    Text(emoji.string)
                        .font(emoji.font)
                        .position(emoji.position.in(geometry))
                }
            }
            .dropDestination(for: URL.self){urls, location in
                return drop(urls, at : location, in : geometry)
            }
        }
    }
    

    private func drop(_ urls : [URL], at location : CGPoint,  in geometry : GeometryProxy) -> Bool{
        if let url = urls.first {
            document.setBackground(url)
            print("set background to \(url)")
            return true;
        }
            return false;
    }
}



struct ScrollingEmojis : View{
    let emojis : [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body : some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(emojis, id : \.self){ emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView(document : EmojiArtDocument())
}

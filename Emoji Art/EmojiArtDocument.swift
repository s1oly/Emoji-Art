//
//  EmojiArtDocument.swift
//  Emoji Art
//
//  Created by S1OLY on 10/3/23.
//

import Foundation
import SwiftUI
import Observation

typealias Emojis = EmojiArt.Emojis

 @Observable class EmojiArtDocument {
    
    private var emojiArt = EmojiArt()
     init(){
         emojiArt.addEmoji("😹", at: .init(x: -200, y: 150), size: 200)
         emojiArt.addEmoji("💀", at: .init(x: 250, y: 100), size: 80)

     }
    
    var emojis : [Emojis] {
        emojiArt.emojis
    }
    
    var background : URL?{
        emojiArt.background
    }
    
    //MARK: - Intent(s)
    
    func setBackground(_ url : URL?){
        emojiArt.background = url
    }
     
    func addEmoji (_ emoji : String, at postition: Emojis.Position, size : CGFloat){
         emojiArt.addEmoji(emoji, at: postition, size: Int(size))
     }
    
}

extension EmojiArt.Emojis {
    var font : Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emojis.Position{
    func `in`(_ geometry : GeometryProxy) -> CGPoint{
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}

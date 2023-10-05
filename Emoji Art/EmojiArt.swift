//
//  EmojiArt.swift
//  Emoji Art
//
//  Created by S1OLY on 10/2/23.
//

import Foundation

struct EmojiArt {
    var background : URL?
    private(set) var emojis = [Emojis]()
    
    private var uniqueEmojiID = 0
    
    mutating func addEmoji (_ emoji : String, at postition: Emojis.Position, size : Int){
        uniqueEmojiID += 1
        emojis.append(Emojis(string: emoji, position: postition, size: size, id: uniqueEmojiID))
    }
    
    struct Emojis : Identifiable {
        let string : String
        var position : Position
        var size : Int
        var id: Int
        
        struct Position{
            var x : Int
            var y : Int
            
            static let zero = Self(x : 0, y: 0)
        }
    }
}


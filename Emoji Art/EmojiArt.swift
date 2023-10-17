//
//  EmojiArt.swift
//  Emoji Art
//
//  Created by S1OLY on 10/2/23.
//

import Foundation

struct EmojiArt : Codable {
    var background: URL?
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    func json() throws -> Data{
        let encoded = try JSONEncoder().encode(self)
        print("EmojiArt = \(String(data : encoded, encoding: .utf8) ?? "nil")")
        return encoded
    }
    
    init(json : Data) throws {
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    init(){
        
    }
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(
            string: emoji,
            position: position,
            size: size,
            id: uniqueEmojiId
        ))
    }
    
    mutating func deleteEmoji(emojiID : Emoji.ID){
        for i in emojis.indices{
                if emojis[i].id == emojiID{
                emojis.remove(at: i)
            }
        }
    }
    
    
    struct Emoji: Identifiable, Codable {
        let string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position : Equatable, Codable{
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}


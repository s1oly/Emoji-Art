//
//  EmojiArtDocument.swift
//  Emoji Art
//
//  Created by S1OLY on 10/3/23.
//

import SwiftUI
import Observation

@Observable class EmojiArtDocument {
    typealias Emoji = EmojiArt.Emoji
    private var emojiArt = EmojiArt(){
        didSet{
            autosave()
        }
    }
    
    private let autoSaveURL : URL = URL.documentsDirectory.appendingPathComponent("AutoSave2.emojiart")
    
    private func autosave(){
        save(to: autoSaveURL)
        print("autosaved to \(autoSaveURL)")
    }
    
    private func save(to url : URL){
        do{
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let error{
            print("EmojiArtDocument : error while saving \(error.localizedDescription)")
        }
    }
    
    init() {
        if let data = try? Data(contentsOf: autoSaveURL),
        let autoSavedEmojiArt = try? EmojiArt(json: data) {
            emojiArt = autoSavedEmojiArt
        }
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
    
    func deleteEmoji(emojiID : Emoji.ID){
        emojiArt.deleteEmoji(emojiID: emojiID)
    }
    
}

extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}

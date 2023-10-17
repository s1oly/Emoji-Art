//
//  PaletteStore.swift
//  Emoji Art
//
//  Created by S1OLY on 10/7/23.
//

import Foundation
import SwiftUI

extension UserDefaults{
    func palette(forKey key : String) -> [Palette]{
        if let jsonData = data(forKey: key),
           let decodeddPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData){
            return decodeddPalettes
        }else{
            return []
        }
    }
    
    func set(_ palettes : [Palette], forKey key : String){
        let data = try? JSONEncoder().encode(palettes)
        set(data, forKey: key)
    }
}

@Observable class PaletteStore{
    let name : String
    
    
    private var userDefaultKey : String {"Pallete Store : " + name}
    
    
    var palettes : [Palette]{
        get{
            UserDefaults.standard.palette(forKey : name)
        }
        set{
            if !newValue.isEmpty    {
                UserDefaults.standard.set(newValue, forKey: name)
            }
           
        }
    }
    
    private var _cursorIndex = 0
    
    var cursorIndex : Int {
        get{checkPaletteIndex(_cursorIndex)}
        set{_cursorIndex = checkPaletteIndex(newValue)}
    }
    
    init(named name : String) {
        self.name = name;
        if palettes.isEmpty{
            self.palettes = Palette.builtins
            if palettes.isEmpty {
                palettes  = [Palette(name : "Warning", emojis: "❌")]
            }
        }
    }
    
    
    private func checkPaletteIndex(_ index : Int) -> Int{
        var index = index % palettes.count
        if index < 0{
            index += palettes.count
        }
        return index
    }
    
    // MARK: - Adding Palettes
    
    // these functions are the recommended way to add Palettes to the PaletteStore
    // since they try to avoid duplication of Identifiable-ly identical Palettes
    // by first removing/replacing any Palette with the same id that is already in palettes
    // it does not "remedy" existing duplication, it just does not "cause" new duplication
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) { // "at" default is cursorIndex
        let insertionIndex = checkPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis), at: index)
    }
    
    func append(_ palette: Palette) { // at end of palettes
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }
    
    func append(name: String, emojis: String) {
        append(Palette(name: name, emojis: emojis))
    }
}

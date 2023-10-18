//
//  PaletteManager.swift
//  Emoji Art
//
//  Created by S1OLY on 10/18/23.
//

import SwiftUI

struct PaletteManager: View {
    let stores : [PaletteStore]
    @State private var selectedStore : PaletteStore?
    
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
                PaletteStoreView(store: store)
                    .tag(store)
            }
        } content: {
            if let selectedStore {
                EditablePaletteList(store: selectedStore)
            }
            Text("Choose a store")
        } detail: {
            Text("Choose a palette")
        }
    }
}

struct PaletteStoreView: View {
    @ObservedObject var store: PaletteStore
    
    var body: some View {
        Text(store.name)
    }
}

//#Preview {
//    PaletteManager()
//}

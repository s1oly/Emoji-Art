//
//  EmojiArtView.swift
//  Emoji Art
//
//  Created by S1OLY on 10/3/23.
//

import SwiftUI
import Combine

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    var document: EmojiArtDocument
    
    
    private let paletteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    
    
    @State private var zoom : CGFloat = 0.5
    @State private var pan : CGOffset = .init(width: 100, height: 100)
    @State private var selected : Set<Int> = []
    @GestureState private var gestureZoom : CGFloat = 1
    @GestureState private var gesturePan : CGOffset = .zero
    
    private var zoomGesture : some Gesture{
        MagnificationGesture()
            .updating($gestureZoom){inMotionPinchScale, gestureZoom, _ in
                gestureZoom *= inMotionPinchScale
            }
            .onEnded{ endingPinchScale in
                zoom *= endingPinchScale
            }
    }
    
    private var panGesture : some Gesture{
        DragGesture()
            .updating($gesturePan){ inMotionOffset, gesturePan, _ in
                gesturePan = inMotionOffset.translation
            }
            .onEnded{value in
                pan += value.translation
            }
    }
        
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View{
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .border(selected.contains(emoji.id) ? Color.green : Color.clear, width : 2)
                .onTapGesture {
                    if selected.contains(emoji.id){
                        selected.remove(emoji.id)
                    }
                    else{
                        selected.insert(emoji.id)
                    }
                }
                .position(emoji.position.in(geometry))
            
        }

    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: paletteEmojiSize / zoom
                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - pan.width)/zoom),
            y: Int(-(location.y - center.y - pan.height)/zoom)
        )
    }
}



#Preview {
    EmojiArtDocumentView(document : EmojiArtDocument())
        .environment(PaletteStore(named: "Preview"))
}

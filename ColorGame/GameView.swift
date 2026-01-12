//
//  GameView.swift
//  ColorGame
//
//  Created by cobsccomp242p-066 on 2026-01-12.
//import SwiftUI
import SwiftUI

struct GameView: View {
    @StateObject private var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty) {
        _engine = StateObject(wrappedValue: GameEngine(difficulty: difficulty))
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack {
                header
                grid
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text("Score: \(engine.score)")
                .font(.title3.bold())

            Spacer()

            Button { engine.setupGrid() } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
        .foregroundColor(.white)
        .padding()
    }

    private var grid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: engine.size)

        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(engine.grid.flatMap { $0 }) { tile in
                TileView(
                    tile: tile,
                    isSelected: engine.selectedTile?.id == tile.id
                )
                .onTapGesture {
                    engine.select(tile: tile)
                }
            }
        }
        .padding()
    }
}
struct TileView: View {
    let tile: Tile
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(tile.color.color.gradient)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .white : .clear, lineWidth: 3)
            }
            .animation(.easeInOut, value: isSelected)
    }
}

#Preview {
    ZStack {
        Color.primaryBackground
        TileView(
            tile: Tile(color: .purple, row: 0, col: 0),
            isSelected: true
        )
        .frame(width: 60)
    }
    .preferredColorScheme(.dark)
}
struct DifficultyButton: View {
    let difficulty: Difficulty

    var body: some View {
        HStack {
            Text(difficulty.rawValue)
                .font(.title3.bold())

            Spacer()

            Text("\(difficulty.gridSize) × \(difficulty.gridSize)")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
        .foregroundColor(.white)
    }
}

#Preview {
    ZStack {
        Color.primaryBackground
        DifficultyButton(difficulty: .medium)
            .padding()
    }
    .preferredColorScheme(.dark)
}


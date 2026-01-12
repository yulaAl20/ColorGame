import SwiftUI
import Combine   

// MARK: - Difficulty

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var gridSize: Int {
        switch self {
        case .easy: return 6
        case .medium: return 8
        case .hard: return 10
        }
    }
}

// MARK: - Tile

enum TileColor: CaseIterable {
    case red, yellow, green, blue, purple

    var color: Color {
        switch self {
        case .red: return .red
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        }
    }
}

struct Tile: Identifiable {
    let id = UUID()
    var color: TileColor
    let row: Int
    let col: Int
}

// MARK: - Game Engine

final class GameEngine: ObservableObject {

    @Published var grid: [[Tile]] = []
    @Published var score = 0
    @Published var selectedTile: Tile?

    let size: Int

    init(difficulty: Difficulty) {
        self.size = difficulty.gridSize
        setupGrid()
    }

    func setupGrid() {
        score = 0
        grid = (0..<size).map { row in
            (0..<size).map { col in
                Tile(
                    color: TileColor.allCases.randomElement()!,
                    row: row,
                    col: col
                )
            }
        }
    }

    func select(tile: Tile) {
        if let selected = selectedTile {
            if isAdjacent(selected, tile) {
                swapTiles(selected, tile)
                selectedTile = nil
            } else {
                selectedTile = tile
            }
        } else {
            selectedTile = tile
        }
    }

    private func isAdjacent(_ a: Tile, _ b: Tile) -> Bool {
        abs(a.row - b.row) + abs(a.col - b.col) == 1
    }

    private func swapTiles(_ a: Tile, _ b: Tile) {
        let tempColor = grid[a.row][a.col].color
        grid[a.row][a.col].color = grid[b.row][b.col].color
        grid[b.row][b.col].color = tempColor

        score += 10
    }

}

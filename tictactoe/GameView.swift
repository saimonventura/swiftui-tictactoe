//
//  GameView.swift
//  tictactoe
//
//  Created by GhostMon on 12/19/22.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text(viewModel.winner ?? viewModel.message)
                    .padding()
                    .fontWeight(.bold)
                LazyVGrid(columns: viewModel.columns, spacing: 5){
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.orange)
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.onTap(boardIndex: i)
                        }
                    }
                }
                
                Text("Recomeçar").onTapGesture{ viewModel.reset() }
                    .padding()
                Spacer()
            }
        }.padding()
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

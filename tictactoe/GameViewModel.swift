//
//  gameViewModel.swift
//  tictactoe
//
//  Created by GhostMon on 12/19/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var player: Player = .human
    @Published var winner: String? = nil
    @Published var message: String = "Começe o jogo"
    
    private var winPositions: [[Int]] = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    
    private func nextPlayer() {
        player = player == .computer ? .human : .computer
        message = player == .computer ? "Aguarde a IA jogar" : "Sua vez de jogar"
    }
    
    private func hasWinner() {
        for winPosition in winPositions {
            if (moves[winPosition[0]]?.player != nil
                && moves[winPosition[0]]?.player == moves[winPosition[1]]?.player
                && moves[winPosition[0]]?.player == moves[winPosition[2]]?.player
            ) {
                winner = moves[winPosition[0]]?.player == .computer ? "A IA venceu :(" : "Parabéns você ganhou!"
            }
        }
        
    }
    
    private func isDraw() {
        if (winner != nil) { return }
        
        let indexes = moves.map { $0?.boardIndex }
        if (!indexes.contains(nil)) {
            winner = "Empatou o Jogo"
        }
    }
    
    private func getBestMove(player: Player) -> Int? {
        for winPosition in winPositions {
            if (moves[winPosition[0]]?.player == moves[winPosition[1]]?.player
                && moves[winPosition[1]]?.player == player
                && moves[winPosition[2]]?.boardIndex == nil
            ) {
                return winPosition[2]
            }
            if (moves[winPosition[2]]?.player == moves[winPosition[1]]?.player
                && moves[winPosition[1]]?.player == player
                && moves[winPosition[0]]?.boardIndex == nil
            ) {
                return winPosition[0]
                
            }
            if (moves[winPosition[2]]?.player == moves[winPosition[0]]?.player
                && moves[winPosition[0]]?.player == player
                && moves[winPosition[1]]?.boardIndex == nil
            ) {
                return winPosition[1]
            }
        }
        return nil
    }
    
    private func iaMove() -> Void {
        // TryWin
        let winMove = getBestMove(player: .computer)
        if(winMove != nil) {
            move(boardIndex: winMove!)
            return
        }
        
        // TryBlock
        let blockMove = getBestMove(player: .human)
        if(blockMove != nil) {
            move(boardIndex: blockMove!)
            return
        }
        
        // TryCenter
        let centerIndex: Int = 4
        if (moves[centerIndex] == nil) {
            move(boardIndex: centerIndex)
            return
        }
        
        // Random
        var randomIndex: Int = Int.random(in: 0..<9)
        while moves[randomIndex]?.boardIndex != nil {
            randomIndex = Int.random(in: 0..<9)
        }
        move(boardIndex: randomIndex)
        
    }
    
    private func move(boardIndex: Int) -> Void {
        moves[boardIndex] = Move(player: player, boardIndex: boardIndex)
        hasWinner()
        isDraw()
        if (winner == nil) {
            nextPlayer()
            if (player == .computer){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: iaMove)
            }
        }
    }
    
    func onTap(boardIndex: Int) -> Void {
        if(moves[boardIndex] != nil || winner != nil || player == .computer) { return }
        
        move(boardIndex: boardIndex)
    }
    
    func reset() {
        moves = Array(repeating: nil, count: 9)
        player = .human
        winner = nil
        message = "Começe o jogo"
    }
    
}

//
//  Puzzle.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/27/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation


public class Puzzle {
    
    var fen: FEN!
    var firstComputerMove: String = ""
    var solutionMoves: String = ""
    var flipBoard: Bool = false
    
    init(FEN: String, computerMove: String, solution: String){
        self.fen = FENUtils().readBoardFromFEN(FEN)
        firstComputerMove = computerMove
        solutionMoves = solution
        if solutionMoves[solutionMoves.startIndex] == "." {
            flipBoard = true
        }
    }
}
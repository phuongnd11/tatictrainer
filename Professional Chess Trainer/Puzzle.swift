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
    var numOfMoves: Int = 0
    
    init(FEN: String, computerMove: String, solution: String){
        self.fen = FENUtils().readBoardFromFEN(FEN)
        firstComputerMove = computerMove
        solutionMoves = solution
        if solutionMoves[solutionMoves.startIndex] == "." {
            flipBoard = true
        }
        numOfMoves = solutionMoves.componentsSeparatedByString(" ").count/2 + 1
    }
    
    //count from 1
    public func validateMove(moveText: String, moveNumber: Int) -> Bool{
        let tokens = solutionMoves.componentsSeparatedByString(" ")
        if (moveNumber-1) * 2 > tokens.count {
            return false
        }
        NSLog(tokens[(moveNumber-1)*2])
        // Need to update
        if tokens[(moveNumber-1)*2].containsString(moveText) {
            return true
        }
        
        return false
    }
    
    //count from 1
    public func getNextComputerMove(moveNumber: Int) -> Move {
        var move : Move!
        return move
    }
}
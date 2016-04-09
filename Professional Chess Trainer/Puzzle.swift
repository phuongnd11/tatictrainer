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
    var title: String = ""
    var elo: Int
    
    init(FEN: String, computerMove: String, solution: String, gameTitle: String, elo: Int){
        self.fen = FENUtils().readBoardFromFEN(FEN)
        title = gameTitle
        self.elo = elo
        firstComputerMove = computerMove
        solutionMoves = solution.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        if solutionMoves[solutionMoves.startIndex] == "." {
            flipBoard = true
        }
        numOfMoves = solutionMoves.componentsSeparatedByString(" ").count
    }
    
    //count from 1
    public func validateMove(moveText: String, moveNumber: Int) -> Bool{
        let tokens = solutionMoves.componentsSeparatedByString(" ")
        if (moveNumber-1) > tokens.count {
            return false
        }
        NSLog("validate" + tokens[moveNumber-1])
        NSLog(moveText)
        // Need to update
        if tokens[moveNumber-1].containsString(moveText) {
            return true
        }
        
        return false
    }
    
    //count from 1
    public func getNextComputerMove(moveNumber: Int) -> String {
        let tokens = solutionMoves.componentsSeparatedByString(" ")
        if moveNumber > tokens.count {
            return ""
        }
        NSLog("computer " + tokens[moveNumber])
        
        return tokens[moveNumber]
    }
    
}
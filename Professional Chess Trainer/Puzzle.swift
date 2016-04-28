//
//  Puzzle.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/27/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation


public class Puzzle: Comparable {
    
    var fen: FEN!
    var firstComputerMove: String = ""
    var solutionMoves: String = ""
    var flipBoard: Bool = false
    var numOfMoves: Int = 0
    var idea: String = ""
    var elo: Int
    var id: Int
    
    init(FEN: String, computerMove: String, solution: String, idea: String, elo: Int, id: Int){
        self.fen = FENUtils().readBoardFromFEN(FEN)
        self.idea = idea
        self.elo = elo
        self.id = id
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
        
        return tokens[moveNumber]
    }
    
    
}


public func < (lhs: Puzzle, rhs: Puzzle) -> Bool {
    if (lhs.elo == rhs.elo) {
       return lhs.id < rhs.id
    }
    return lhs.elo < rhs.elo
}

public func == (lhs: Puzzle, rhs: Puzzle) -> Bool {
    return lhs.id == rhs.id
}
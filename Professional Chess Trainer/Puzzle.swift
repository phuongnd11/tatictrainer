//
//  Puzzle.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/27/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation


open class Puzzle: Comparable {
    
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
        NSLog("Computer move in String 11111: ", solution)
        solutionMoves = solution.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        if (!fen.whiteToMove || solutionMoves[solutionMoves.startIndex] == ".") {
            flipBoard = true
        }
        numOfMoves = solutionMoves.components(separatedBy: " ").count
    }
    
    //count from 1
    open func validateMove(_ moveText: String, moveNumber: Int) -> Bool{
        let tokens = solutionMoves.components(separatedBy: " ")
        if (moveNumber-1) > tokens.count {
            return false
        }
        NSLog("validate" + tokens[moveNumber-1])
        NSLog(moveText)
        // Need to update
        if tokens[moveNumber-1].contains(moveText) {
            return true
        }
        
        return false
    }
    
    //count from 1
    open func getNextComputerMove(_ moveNumber: Int) -> String {
        let tokens = solutionMoves.components(separatedBy: " ")
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

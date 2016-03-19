//
//  PuzzleFactory.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/16/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class PuzzleFactory{
    
    
    public func getNextPuzzle() -> Puzzle {
        var puzzle1 = Puzzle(FEN: "r2nr2k/1bp1bpp1/p7/1p1pP3/3P2q1/2P2NP1/P1B2PK1/R1BQR3 w - - 0 1", computerMove: "", solution: " Rh1+ Kg8 Bh7+ if Kf8 Bf5")
        
        var puzzle2 = Puzzle(FEN: "rn2k1r1/1R1b1p1p/3pp3/p6R/4P3/3NBP2/2P1B1P1/b4K2 w q - 0 1", computerMove: "", solution: "Rxa5")
        
        var puzzle3 = Puzzle(FEN: "4r1k1/Q4ppp/1r1q4/N1pPpb2/1nP5/R5P1/P4PBP/2R3K1 b - - 0 1", computerMove: "", solution: "...Ra6 if Qb7 Rb8")
        
        var puzzle4 = Puzzle(FEN: "r1bq1rk1/ppppnp1p/2n3p1/3N2B1/2PQ4/8/PP2PPPP/R3KB1R w KQ - 1 0", computerMove:  "", solution: "Nf6+ Kh8 Ng4+")
        
        let diceRoll = Int(arc4random_uniform(3) + 1)
        
        if diceRoll == 1 {
            return puzzle1
        }
        if diceRoll == 2 {
            return puzzle2
        }
        if diceRoll == 3 {
            return puzzle1
        }
        if diceRoll == 4 {
            return puzzle1
        }
        return puzzle1
    }
    
}
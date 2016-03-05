//
//  Puzzle.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/27/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation


public class Puzzle {
    
    var FEN: String = ""
    var firstComputerMove: String = ""
    var solutionMoves: String = ""
    var flipBoard: Bool = false
    var whiteToMove: Bool = true
    var isK: Bool = true
    var isQ: Bool = true
    var isk: Bool = true
    var isq: Bool = true
    var enPassant: String = ""
    
    init(FEN: String, computerMove: String, solution: String){
        
    }
}
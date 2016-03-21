//
//  Queen.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class Queen: Piece {
    public override func isValidMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool {
        return isValidDiagonalMove(start, dest: dest, board: board) || isValidHorVerMove(start, dest: dest, board: board)
    }
    
    public override func toPGN() -> String {
        return "Q";
    }
}
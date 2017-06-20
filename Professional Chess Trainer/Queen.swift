//
//  Queen.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class Queen: Piece {
    open override func isValidMove(_ start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool {
        return isValidDiagonalMove(start, dest: dest, board: board) || isValidHorVerMove(start: start, dest: dest, board: board)
    }
    
    open override func toPGN() -> String {
        return "Q";
    }
}

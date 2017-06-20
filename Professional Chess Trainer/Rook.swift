//
//  Rook.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class Rook: Piece {
    open override func isValidMove(_ start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        //an quan cung mau da check o tren
        
        return isValidHorVerMove(start: start, dest: dest, board: board)
    }
    
    open override func toPGN() -> String {
        return "R";
    }
}

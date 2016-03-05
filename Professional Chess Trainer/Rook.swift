//
//  Rook.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class Rook: Piece {
    public override func isValidMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        //an quan cung mau da check o tren
        
        return isValidHorVerMove(start, dest: dest, board: board)
    }
}
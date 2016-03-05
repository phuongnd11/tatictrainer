//
//  Knight.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class Knight: Piece {
    public override func isValidMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool {
        
        if(board[dest.0][dest.1] != "e") {
            //if ()
        }
        
        return true
    }
}
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
        
        if (abs(start.0-dest.0)==2 && abs(start.1-dest.1)==1){
            return true;
        }
        if (abs(start.0-dest.0)==1 && abs(start.1-dest.1)==2){
            return true;
        }
        return false
    }
    public override func toPGN() -> String {
        return "N";
    }
}
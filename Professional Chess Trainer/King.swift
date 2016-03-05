//
//  King.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class King: Piece {
    public override func isValidMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        //nhap thanh va an quan cung mau da duoc check o tren
        
        if ((abs(start.0-dest.0) != 1) && (abs(start.1-dest.1) != 1)){
            return false;
        }
        
        if ((abs(start.0-dest.0) > 1) || (abs(start.1-dest.1) > 1)){
            return false;
        }
        
        return true;
    }
    
}
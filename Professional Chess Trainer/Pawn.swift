//
//  Pawn.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class Pawn: Piece {
    open static func isPawnCanEat(_ start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        //note; chi check vi tri quan tot, khong check quan o dest
        let currentPiece = board[start.0][start.1].piece
        
        if (currentPiece?.color == PieceColor.white){
            if ((start.0 - dest.0) == 1 && abs(start.1-dest.1)==1){
                return true;
            }
            return false
        }
        
        if (currentPiece?.color == PieceColor.black){
            if ((dest.0 - start.0) == 1 && abs(start.1-dest.1)==1){
                return true;
            }
            return false
        }
        return false;
    }
    open override func isValidMove(_ start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        let currentPiece = board[start.0][start.1].piece
        
        if (!board[dest.0][dest.1].isEmpty()){// check truong hop an quan
            return Pawn.isPawnCanEat(start,dest: dest,board: board)
        }
        if (start.1 != dest.1){
            return false // check tot qua duong sau
        }
        let horDiff = dest.0 - start.0
        if (abs(horDiff)>2 || abs(horDiff)<=0) {
            return false
        }
        
        if (currentPiece?.color == PieceColor.white){
            if (horDiff > 0) {
                return false
            }
            if ((start.0 == 6) || (start.0<6 && horDiff == (-1))){
                // o tren da check th >2
                return true
            }
            return false
        }
        
        if (currentPiece?.color == PieceColor.black){
            if (horDiff < 0) {
                return false
            }
            if ((start.0 == 1) || (start.0>1 && horDiff == 1)){
                // o tren da check th >2
                return true
            }
            return false
        }
        return false;

    }
    
    open override func toPGN() -> String {
        return "";
    }
}

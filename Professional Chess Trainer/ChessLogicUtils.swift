//
//  ChessLogicUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/15/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class ChessLogicUtils {
    
    let squareX: String = "abcdefgh"
    let squareY: String = "87654321"
    
    public func toStandardMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> String {
        var move = ""
        if (board[start.0][start.1].piece is Pawn) {
            if (board[dest.0][dest.1].isEmpty()) {
                //need to check en passsant
                return positionToSquare(dest)
            }
            else {
                
            }
        }
        
        return ""
    }
    
    public func isValidMove(start: (Int, Int), dest: (Int, Int), board: [[Square]], whiteToMove: Bool, isK: Bool, isQ: Bool, isk: Bool, isq: Bool, enPassant: (Int, Int)) -> (Bool) {
        
        if(board[start.0][start.1] == "e") {
            return false
        }
        
        
        
        
        return true
    }
    
    
    private func isValidKnighMove(start: (Int, Int), dest: (Int, Int), board: [[Character]]) -> Bool {
        
        if(board[dest.0][dest.1] != "e") {
            //if ()
        }
        
        return true
    }
    
    
    private func isBlackPiece(piece: Character) -> Bool {
        return true
        //if (piece == "r" || piece == "r" ||)
    }
    
    private func positionToSquare(position: (Int, Int)) -> String {
        return String(squareX[squareX.startIndex.advancedBy(position.0)])
            + String(squareY[squareY.startIndex.advancedBy(position.1)])
    }
}

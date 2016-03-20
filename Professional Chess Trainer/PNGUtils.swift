//
//  PNGUtils.swift
//  Professional Chess Trainer
//
//  Created by MCB on 3/19/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
public class PNGUtils {
    public func GetPngFromMove(start: (Int, Int), dest: (Int, Int), board: [[Square]], boardStatus: BoardStatus, moveResult: MoveResult) -> String{
        //get Piece Text
        var pieceText = ""
        if (!board[start.0][start.1].isEmpty()){
            pieceText = board[start.0][start.1].piece.toPGN()
        }
        //get Piece duplicate Text
        var duplicateText = ""
        let destText = GetBoardText(dest)
        //get move in PNG
        var specialMove = ""
        //check check mate
        var mateEat = ""
        
        switch (moveResult){
        case MoveResult.castling:
            if (dest.1 == 2){
                specialMove = "O-O-O"
            }
            else if (dest.1 == 6){
                specialMove = "O-O"
            }
        case MoveResult.check: mateEat = "+"
        case MoveResult.checkMate: mateEat = "#"
        default: break
        }
        
        return pieceText+duplicateText+destText+specialMove+mateEat;
    }
    private func GetBoardText(location: (Int, Int)) -> String{
        return GetColText(location.1) + GetRowText(location.0)
    }
    
    private func GetColText(col: Int) -> String{
        // ASCII a is 97
        return String(Character(UnicodeScalar(97+col)))
    }
    
    private func GetRowText(row: Int) -> String{
        return String(8-row)
    }
    
    
}
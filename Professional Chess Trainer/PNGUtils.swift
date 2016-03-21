//
//  PNGUtils.swift
//  Professional Chess Trainer
//
//  Created by MCB on 3/19/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
public class PNGUtils {
    public func GetPngFromMove(start: (Int, Int), dest: (Int, Int), board: [[Square]], isWhiteMove: Bool, moveResult: MoveResult, gameResult: GameResult) -> String{
        //get Piece Text
        var pieceText = ""
        if (!board[start.0][start.1].isEmpty()){
            pieceText = board[start.0][start.1].piece.toPGN()
        }
        //get Piece duplicate Text
        var duplicateText = getDuplicateText(start,dest:dest, board: board, moveResult: moveResult)
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
        default: break
        }
        
        if ((isWhiteMove && gameResult == GameResult.whiteCheck) || (!isWhiteMove && gameResult == GameResult.blackCheck)){
            mateEat = "+"
        }
        else if ((isWhiteMove && gameResult == GameResult.whiteWin) || (!isWhiteMove && gameResult == GameResult.blackWin)){
            mateEat = "#"
        }
        else if (moveResult == MoveResult.eat){
            mateEat = "x"
        }
        
        return pieceText+duplicateText+destText+specialMove+mateEat;
    }
    
    private func getDuplicateText(square: (Int, Int), dest: (Int,Int), board: [[Square]], moveResult: MoveResult) -> String{
        if (board[square.0][square.1].isEmpty()) {
            return ""
        }
        let piece = board[square.0][square.1].piece
        if (piece is King || piece is Queen || piece is Bishop){
            return ""
        }
        let color = piece.color
        let pgn = piece.toPGN()
        
        var isRowExist = false
        var isColExist = false
        for var i = 0; i < 8; ++i {
            for var j = 0; j < 8; ++j {
                if (!(i == square.0 && j == square.1) && !board[i][j].isEmpty()){
                    if (board[i][j].piece.color == color && board[i][j].piece.toPGN() == pgn){
                        if (piece is Pawn){
                            if (board[i][j].piece.isValidMove((i,j), dest: dest, board: board) || (moveResult == MoveResult.enpass && Pawn.isPawnCanEat(square, dest: dest, board: board))){
                                if (i == square.0){
                                    isRowExist = false
                                }
                                if (j == square.1){
                                    isColExist = false
                                }
                            }
                        }
                        else{
                            if(board[i][j].piece.isValidMove((i,j), dest: dest, board: board)){
                                return getDistinction(square,square: (i,j))
                            }
                            else{
                                return ""
                            }
                        }
                        
                    }
                }
            }
        }
        if (piece is Pawn){
            if (isRowExist && isColExist){
                return GetBoardText(square)
            }
            if (isColExist){
                return GetColText(square.1)
            }
            if (isRowExist){
                return GetRowText(square.0)
            }
        }
        return ""
    }
    
    private func getDistinction(rootSquare:(Int,Int), square:(Int,Int)) -> String{
        if (rootSquare.1 != square.1){
            return GetColText(rootSquare.1)
        }
        return GetRowText(rootSquare.0)
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
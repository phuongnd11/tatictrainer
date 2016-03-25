//
//  PNGUtils.swift
//  Professional Chess Trainer
//
//  Created by MCB on 3/19/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
public class PNGUtils {
    let specialText = ["x","+","#","O-O-O", "O-O"]
    public func getPngFromMove(move: Move, board: [[Square]], isWhiteMove: Bool) -> String{
        let start = move.start
        let dest = move.dest
        let moveResult = move.moveResult
        let gameResult = move.gameResult
        //get Piece Text
        var pieceText = ""
        if (!board[start.0][start.1].isEmpty()){
            pieceText = board[start.0][start.1].piece!.toPGN()
        }
        //get Piece duplicate Text
        let duplicateText = getDuplicateText(start,dest:dest, board: board, moveResult: moveResult)
        let destText = GetBoardText(dest)
        //get move in PNG
        var specialMove = ""
        //check check mate
        var checkText = ""
        var captureText = ""
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
            checkText = "+"
        }
        else if ((isWhiteMove && gameResult == GameResult.whiteWin) || (!isWhiteMove && gameResult == GameResult.blackWin)){
            checkText = "#"
        }
        if (moveResult == MoveResult.eat){
            captureText = "x"
        }
        
        return pieceText + duplicateText + captureText + destText + specialMove + checkText
    }
    public func GetMoveFromPgn(pgn: String,board: [[Square]], isWhiteMove: Bool) -> Move{
        let piece = String(pgn[pgn.startIndex])
        
        // remove special characters
        var text = String(pgn.characters.dropFirst())
        
        for string in specialText {
            text = text.stringByReplacingOccurrencesOfString(string, withString: "")
        }
        
        
        var color = PieceColor.Black
        if isWhiteMove{
            color = PieceColor.White
        }
        var dest = (-1,-1)
        dest.0 = GetRowNum(text[text.endIndex.predecessor()])
        dest.1 = GetColNum(text[text.endIndex.advancedBy(-2)])
        
        var start = (-1,-1)
        if text.characters.count == 4{
            start.0 = GetRowNum(text[text.startIndex.advancedBy(1)])
            start.1 = GetColNum(text[text.startIndex])
        }
        else if (text.characters.count == 3){
            start.0 = GetRowNum(text[text.startIndex])
            start.1 = GetColNum(text[text.startIndex])
        }
        
        for var i = 0; i < 8; ++i {
            for var j = 0; j < 8; ++j {
                if (checkValidRange(start, dest: dest, item: (i,j)) && !board[i][j].isEmpty()){
                    if (board[i][j].piece.color == color && board[i][j].piece.toPGN() == piece){
                        if (piece == "K" || piece == "Q"){
                            return Move(start: (i,j),dest:dest)
                        }
                        else if board[i][j].piece.isValidMove((i,j), dest: dest, board: board){
                            return Move(start: (i,j),dest:dest)
                        }
                    }
                }
            }
        }
        return Move(start: start,dest:dest)
    }
    
    private func checkValidRange(start: (Int,Int), dest: (Int,Int), item: (Int,Int)) -> Bool{
        if item.0 == dest.0 && item.1 == dest.1{
            return false
        }
        
        if (item.0 == start.0 || start.0 == -1) && (item.1 == start.1 || start.1 == -1) {
            return true;
        }
        
        return false
    }
    private func getDuplicateText(square: (Int, Int), dest: (Int,Int), board: [[Square]], moveResult: MoveResult) -> String{
        if (board[square.0][square.1].isEmpty()) {
            return ""
        }
        let piece = board[square.0][square.1].piece
        if (piece is King){
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
    
    private func GetColNum(colStr: Character) -> Int{
        let colList = "abcdefgh"
        var i = 0
        for c in colList.characters{
            if (c == colStr){
                return i
            }
            i++
        }
        return -1;
    }
    
    private func GetRowNum(rowStr: Character) -> Int{
        let rowList = "87654321"
        var i = 0
        for c in rowList.characters{
            if (c == rowStr){
                return i
            }
            i++
        }
        return -1;
    }
    
    private func GetRowText(row: Int) -> String{
        return String(8-row)
    }
    
    
}
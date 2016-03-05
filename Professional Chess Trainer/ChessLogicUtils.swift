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
        if (!checkRange(start, dest: dest)){
            return false;
        }
        if (start.0 == dest.0 && start.1 == dest.1){
            return false
        }
        
        let currentSquare = board[start.0][start.1]
        let destSquare = board[dest.0][dest.1]
        
        //check current square
        if(currentSquare.isEmpty()) {
            return false
        }
        
        let currentPiece = currentSquare.piece!;
        if (whiteToMove && currentPiece.color == PieceColor.Black){
            return false;
        }
        if (!whiteToMove && currentPiece.color == PieceColor.White){
            return false;
        }
        var result = false;
        var isEnpass = false
        var isCastling = false
        // check nhap thanh
        if (!destSquare.isEmpty()){
            let destPiece = destSquare.piece!;
            
            if (destPiece.color == currentPiece.color){
                // neu khong phai nhap thanh thi la false
                result = checkCastling(start,dest:dest,board:board,isK: isK,isQ:isQ,isk:isk, isq:isq);
                
                isCastling = result;
            }
        }
        else
        if ((currentPiece is Pawn) && (dest.0 == enPassant.0 && dest.1 == enPassant.1)){
            // check tot qua duong
            result = Pawn.isPawnCanEat(start,dest: dest,board: board)
            isEnpass = result
        }
        else{
            result = currentPiece.isValidMove(start, dest: dest, board: board)
        }
        if (result){
            let pieces = convertToPiece(board)
            TryMove(start, dest:dest, board:board, isWhiteMove: whiteToMove , isEnpass:isEnpass, isCastling:isCastling)
            result = !isCheckMate(whiteToMove, board: board)
            copyToBoard(board, pieces: pieces)
        }
        return result
    }
    public func TryMove(start: (Int, Int), dest: (Int, Int), board:[[Square]], isWhiteMove: Bool, isEnpass: Bool, isCastling:Bool){
        if (isCastling){
            var rookRow = start.0
            var rookCol = start.1
            var king = board[dest.0][dest.1].piece
            if (board[dest.0][dest.1].piece is Rook){
                rookRow = dest.0
                rookCol = dest.1
                king = board[start.0][start.1].piece
            }
            if (!(king is King)){
                return
            }
            let rook = board[rookRow][rookCol].piece
            
            if (rookRow == 0 && rookCol == 0){
                board[0][2].piece = king
                board[0][3].piece = rook
            }
            if (rookRow == 0 && rookCol == 7){
                board[0][6].piece = king
                board[0][5].piece = rook
            }
            
            if (rookRow == 7 && rookCol == 0){
                board[7][2].piece = king
                board[7][3].piece = rook
            }
            if (rookRow == 7 && rookCol == 7){
                board[7][6].piece = king
                board[7][5].piece = rook
            }
            board[start.0][start.1].piece = nil
            board[dest.0][dest.1].piece = nil
            return
        }
        if (isEnpass){
            if (isWhiteMove){
                board[dest.0-1][dest.1].piece = nil
            }
            else {
                board[dest.0+1][dest.1].piece = nil
            }
        }
        board[dest.0][dest.1].piece = board[start.0][start.1].piece

        board[start.0][start.1].piece = nil
    }
    private func checkCastling(start: (Int, Int), dest: (Int, Int), board: [[Square]], isK: Bool, isQ: Bool, isk: Bool, isq: Bool) ->Bool{
        let currentPiece = board[start.0][start.1].piece!;
        let destPiece = board[dest.0][dest.1].piece!;
        
        if((currentPiece is Rook && destPiece is King) || (currentPiece is King && destPiece is Rook)){
            var rookLocation = (dest.0,dest.1)
            if (currentPiece is Rook){
                rookLocation = (start.0, start.1)
            }
            
            if (destPiece.color == PieceColor.White){
                if (isK && rookLocation.0 == 7 && rookLocation.1 == 7){
                    for var i = 0;i<2;++i{
                        if (!board[7][i+5].isEmpty()){
                            return false
                        }
                    }
                    return true;
                }
                if (isQ && rookLocation.0 == 7 && rookLocation.1 == 0){
                    for var i = 0;i<3;++i{
                        if (!board[7][i+1].isEmpty()){
                            return false
                        }
                    }
                    return true
                }
            }
            
            if (destPiece.color == PieceColor.Black){
                if (isk && rookLocation.0 == 0 && rookLocation.1 == 7){
                    for var i = 0;i<2;++i{
                        if (!board[0][i+5].isEmpty()){
                            return false
                        }
                    }
                    return true;
                }
                if (isq && rookLocation.0 == 0 && rookLocation.1 == 0){
                    for var i = 0;i<3;++i{
                        if (!board[0][i+1].isEmpty()){
                            return false
                        }
                    }
                    return true
                }
            }
        }
        return false;
    }
    
    public func isCheckMate(isCheckWhite:Bool,board: [[Square]]) -> Bool{
        // find king location
        var kingRow = -1
        var kingCol = -1
        
        var kingColor = PieceColor.Black
        var checkColor = PieceColor.White
        if (isCheckWhite){
            kingColor = PieceColor.White
            checkColor = PieceColor.Black
        }
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                if (board[i][j].piece is King){
                    if (board[i][j].piece.color == kingColor){
                        kingRow = i;
                        kingCol = j;
                    }
                }
            }
        }
        
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                if (!board[i][j].isEmpty() && board[i][j].piece.color == checkColor){
                    if (board[i][j].piece.isValidMove((i,j), dest: (kingRow,kingCol), board: board)){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    private func convertToPiece(board: [[Square]]) -> [[Piece?]]{
        var pieces = [[Piece?]](count: 8, repeatedValue: Array(count: 8, repeatedValue: nil))
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                if (!board[i][j].isEmpty()){
                    pieces[i][j] = board[i][j].piece
                }
            }
        }
        return pieces
    }
    private func copyToBoard(board:[[Square]], pieces: [[Piece?]]){
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                board[i][j].piece = pieces[i][j]
            }
        }
    }
    private func tryMove(board: [[Square]]) -> [[Piece]]{
        var pieces = [[Piece]]()
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                pieces[i][j] = board[i][j].piece
            }
        }
        return pieces
    }
    private func checkRange(start: (Int, Int), dest: (Int, Int)) -> Bool{
        if (start.0<0 || start.0 > 7){
            return false;
        }
        if (start.1<0 || start.1 > 7){
            return false;
        }
        if (dest.0<0 || dest.1 > 7){
            return false;
        }
        if (dest.0<0 || dest.1 > 7){
            return false;
        }
        return true;
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

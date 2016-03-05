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
        
        // check nhap thanh
        if (!destSquare.isEmpty()){
            let destPiece = destSquare.piece!;
            
            if (destPiece.color == currentPiece.color){
                // check quan
            
                // neu khong phai nhap thanh thi la false
                return false;
            }
            
            
        }
        
        if (currentPiece is Pawn){
            return isValidPawnMove(start, dest: dest, board: board)
        }
        if (currentPiece is King){
            return isValidKingMove(start, dest: dest, board: board)
        }
        if (currentPiece is Queen){
            return isValidQueenMove(start, dest: dest, board: board)
        }
        if (currentPiece is Bishop){
            return isValidBishopMove(start, dest: dest, board: board)
        }
        if (currentPiece is Rook){
            return isValidRookMove(start, dest: dest, board: board)
        }
        if (currentPiece is Knight){
            return isValidKnightMove(start, dest: dest, board: board)
        }
        return true;
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
    
    
    private func isValidKnightMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool {
        
        if(board[dest.0][dest.1] != "e") {
            //if ()
        }
        
        return true
    }
    
    private func isValidKingMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        //nhap thanh va an quan cung mau da duoc check o tren

        if ((abs(start.0-dest.0) != 1) && (abs(start.1-dest.1) != 1)){
            return false;
        }
        
        if ((abs(start.0-dest.0) > 1) || (abs(start.1-dest.1) > 1)){
            return false;
        }
        
        return true;
    }
    
    private func isValidRookMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        //an quan cung mau da check o tren
        
        if (start.0 != dest.0 && start.1 != dest.1){
            return false;
        }
        
        //check quan bi vuong
        if (start.0 == dest.0){ // di chuyen theo hang ngang
            if (start.1 > dest.1) {// di chuyen sang trai
                for var index = (start.1 - 1); index > dest.1 ; --index {
                    if (!board[dest.0][index].isEmpty()){
                        return false;
                    }
                }
            }
            
            if (start.1 < dest.1) {// di chuyen sang phai
                for var index = (start.1 + 1); index < dest.1 ; ++index {
                    if (!board[dest.0][index].isEmpty()){
                        return false;
                    }
                }
            }
        }
        
        if (start.1 == dest.1){ // di chuyen theo hang doc
            if (start.0 > dest.0) {// di chuyen len tren
                for var index = (start.0 - 1); index > dest.0 ; --index {
                    if (!board[index][dest.1].isEmpty()){
                        return false;
                    }
                }
            }
            
            if (start.0 < dest.0) {// di chuyen xuong duoi
                for var index = (start.0 + 1); index < dest.0 ; ++index {
                    if (!board[index][dest.1].isEmpty()){
                        return false;
                    }
                }
            }
        }
        return true;
    }
    
    private func isValidQueenMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        if (isValidRookMove(start, dest: dest, board: board) || isValidBishopMove(start, dest: dest, board: board)){
            return true;
        }
        return false;
    }
    
    private func isValidBishopMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        if (abs(start.0 - dest.0) == abs(start.1 - dest.1)){
            var horizontalDirection = 1
            if (start.0>dest.0){
                horizontalDirection = -1
            }
            
            var verticalDirection = 1
            if (start.1>dest.1){
                verticalDirection = -1
            }
            
            let step = abs(start.0-dest.0)
            for var i = 1;i<step;++i{
                if (!board[start.0+i*horizontalDirection][start.1+i*verticalDirection].isEmpty()){
                    return false;
                }
            }
            return true
        }
        return false;
    }
    private func isValidPawnMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> Bool{
        let currentPiece = board[start.0][start.1].piece

        if (!board[dest.0][dest.1].isEmpty()){// check truong hop an quan
            let destPiece = board[dest.0][dest.1].piece
            
            if (currentPiece.color != destPiece.color){
                if (currentPiece.color == PieceColor.White){
                    if ((start.0 - dest.0) == 1 && abs(start.1-dest.1)==1){
                        return true;
                    }
                    return false
                }
                
                if (currentPiece.color == PieceColor.Black){
                    if ((dest.0 - start.0) == 1 && abs(start.1-dest.1)==1){
                        return true;
                    }
                    return false
                }
            }
            return false;
        }
        if (start.1 != dest.1){
            return false // check tot qua duong sau
        }
        let horDiff = dest.0 - start.0
        if (abs(horDiff)>2 || abs(horDiff)<=0) {
            return false
        }
        
        if (currentPiece.color == PieceColor.White){
            if (horDiff > 0) {
                return false
            }
            if ((start.0 == 6) || (start.0<6 && horDiff == (-1))){
                // o tren da check th >2
                return true
            }
            return false
        }
        
        if (currentPiece.color == PieceColor.Black){
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
    
    private func isBlackPiece(piece: Character) -> Bool {
        return true
        //if (piece == "r" || piece == "r" ||)
    }
    
    private func positionToSquare(position: (Int, Int)) -> String {
        return String(squareX[squareX.startIndex.advancedBy(position.0)])
            + String(squareY[squareY.startIndex.advancedBy(position.1)])
    }
}

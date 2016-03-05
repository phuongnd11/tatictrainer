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
                if((currentPiece is Rook && destPiece is King) || (currentPiece is King && destPiece is Rook)){
                    var rookLocation = (dest.0,dest.1)
                    if (currentPiece is Rook){
                        rookLocation = (start.0, start.1)
                    }
                    
                    if (destPiece.color == PieceColor.White){
                        if (isK && rookLocation.0 == 7 && rookLocation.1 == 7){
                            for var i = 0;i<3;++i{
                                if (!board[7][i+1].isEmpty()){
                                    return false
                                }
                            }
                            return true;
                        }
                        if (isQ && rookLocation.0 == 7 && rookLocation.1 == 0){
                            for var i = 0;i<2;++i{
                                if (!board[7][i+5].isEmpty()){
                                    return false
                                }
                            }
                            return true
                        }
                        return false
                    }
                    
                    if (destPiece.color == PieceColor.Black){
                        if (isk && rookLocation.0 == 0 && rookLocation.1 == 7){
                            for var i = 0;i<3;++i{
                                if (!board[0][i+1].isEmpty()){
                                    return false
                                }
                            }
                            return true;
                        }
                        if (isq && rookLocation.0 == 0 && rookLocation.1 == 0){
                            for var i = 0;i<2;++i{
                                if (!board[0][i+5].isEmpty()){
                                    return false
                                }
                            }
                            return true
                        }
                        return false
                    }
                    return false;
                }
            
                // neu khong phai nhap thanh thi la false
                return false;
            }
            
            
        }
        if (currentPiece is Pawn){
            // check tot qua duong
            if (dest.0 == enPassant.0 && dest.1 == enPassant.1){
                return Pawn.isPawnCanEat(start,dest: dest,board: board)
            }
        }
        return currentPiece.isValidMove(start, dest: dest, board: board)
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

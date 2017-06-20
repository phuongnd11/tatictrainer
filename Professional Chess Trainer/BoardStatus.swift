//
//  BoardStatus.swift
//  Professional Chess Trainer
//
//  Created by MCB on 3/6/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
open class BoardStatus: NSObject,NSCopying{
    var isWhiteMove = true
    var enPassant = (-1,-1)
    var isKingBlackCastling = true
    var isQueenBlackCastling = true
    var isKingWhiteCastling = true
    var isQueenWhiteCastling = true
    var moveNumber: Int = 0
    
    override init(){
    }
    
    init(clone: BoardStatus){
        isWhiteMove = clone.isWhiteMove
        enPassant = clone.enPassant
        isKingBlackCastling = clone.isKingBlackCastling
        isQueenBlackCastling = clone.isQueenBlackCastling
        isKingWhiteCastling = clone.isKingWhiteCastling
        isQueenWhiteCastling = clone.isQueenWhiteCastling
        moveNumber = clone.moveNumber
    }
    
    open func copy(with zone: NSZone?) -> Any {
        let copy = BoardStatus()
        copy.isWhiteMove = isWhiteMove
        copy.enPassant = enPassant
        copy.isKingBlackCastling = isKingBlackCastling
        copy.isQueenBlackCastling = isQueenBlackCastling
        copy.isKingWhiteCastling = isKingWhiteCastling
        copy.isQueenWhiteCastling = isQueenWhiteCastling
        copy.moveNumber = moveNumber
        return copy
    }
    
    open func updateStatus(_ start:(Int,Int),dest:(Int,Int),movedPiece:Piece, moveResult: MoveResult){
        if (moveResult.rawValue<0){
            return //invalid move
        }
        if (moveResult == MoveResult.castling || movedPiece is King){
            if (isWhiteMove){
                isKingWhiteCastling = false
                isQueenWhiteCastling = false
            }
            else{
                isKingBlackCastling = false
                isQueenBlackCastling = false
            }
        }
        
        if (movedPiece is Rook){
            if (start.0 == 0 && start.1 == 0){
                isQueenBlackCastling = false
            }
            if (start.0 == 0 && start.1 == 7){
                isKingBlackCastling = false
            }
            if (start.0 == 7 && start.1 == 0){
                isQueenWhiteCastling = false
            }
            if (start.0 == 7 && start.1 == 7){
                isKingWhiteCastling = false
            }
        }
        if (movedPiece is Pawn && (abs(dest.0-start.0) == 2)){
            enPassant.1 = start.1
            enPassant.0 = (dest.0+start.0)/2
        }
        else{
            enPassant.1 = -1
            enPassant.0 = -1
        }
        moveNumber += 1
        isWhiteMove = !isWhiteMove
    }
    
}

//
//  FENUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/9/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class FENUtils{
    
    
    public func readBoardFromFEN(fen: String) -> [[Character]]{
        let tokens = fen.componentsSeparatedByString(" ")
        var position = Array(tokens[0].characters)
        //var square = 0
        var board = [[Character]](count: 8, repeatedValue: Array(count: 8, repeatedValue: "e"))
        var x = 0
        var y = 0
        
        for var i = 0; i < position.count; i++ {
            let piece = String(position[i])
            
            if piece == "/" {
                y++
                x = 0
            } else if let pieceValue = Int(piece) {
                x += pieceValue
                //square += pieceValue
            } else {
                //put(GamePiece(str: piece), square: algebraic(square))
                //square++
                board[x][y] = (piece[piece.startIndex])
                x++
            }
        }
        
        //turn = tokens[1] == "w" ? .WHITE : .BLACK
        
        //if tokens[2].rangeOfString("K") != nil { setKingSideCastle(false,  side: .WHITE) }
        //if tokens[2].rangeOfString("Q") != nil { setQueenSideCastle(false, side: .WHITE) }
        //if tokens[2].rangeOfString("k") != nil { setKingSideCastle(false,  side: .BLACK) }
        //if tokens[2].rangeOfString("q") != nil { setQueenSideCastle(false, side: .BLACK) }
        
//        if tokens[3] == "-" {
//            epSquare = EMPTY
//        } else {
//            epSquare = board.SQUARES[tokens[3]]!
//        }
//        halfMoves = Int(tokens[4])!
//        moveNumber = Int(tokens[5])!
        return board
    }
    
    
}
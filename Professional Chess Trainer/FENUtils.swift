//
//  FENUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/9/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class FENUtils{
    
    
    public func readBoardFromFEN(fen: String) -> FEN{
        let tokens = fen.componentsSeparatedByString(" ")
        var position = Array(tokens[0].characters)
        var board = [[Character]](count: 8, repeatedValue: Array(count: 8, repeatedValue: "e"))
        var x = 0
        var y = 0
        var whiteTurn = false
        var isK = false
        var isQ = false
        var isk = false
        var isq = false
        var enPassant = ""
        
        for var i = 0; i < position.count; i++ {
            let piece = String(position[i])
            
            if piece == "/" {
                x++
                y = 0
            } else if let pieceValue = Int(piece) {
                y += pieceValue
            } else {
                board[x][y] = (piece[piece.startIndex])
                y++
            }
        }
        
        whiteTurn = tokens[1] == "w" ? true : false
        
        if tokens[2].rangeOfString("K") != nil { isK = true }
        if tokens[2].rangeOfString("Q") != nil { isQ = true }
        if tokens[2].rangeOfString("k") != nil { isk = true }
        if tokens[2].rangeOfString("q") != nil { isq = true }
        
        if tokens[3] == "-" {
            enPassant = "-"
        } else {
            enPassant = tokens[3]
        }
//        halfMoves = Int(tokens[4])!
//        moveNumber = Int(tokens[5])!
        
        return FEN(board: board, whiteTurn: whiteTurn, wCastleKSide: isK, wCastleQSide: isQ, bCastleKSide: isk, bCastleQSide: isq, enPass: enPassant)
    }
    
    
}
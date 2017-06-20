//
//  FENUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/9/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class FENUtils{
    
    
    open func readBoardFromFEN(_ fen: String) -> FEN{
        let tokens = fen.components(separatedBy: " ")
        var position = Array(tokens[0].characters)
        var board = [[Character]](repeating: Array(repeating: "e", count: 8), count: 8)
        var x = 0
        var y = 0
        var whiteTurn = false
        var isK = false
        var isQ = false
        var isk = false
        var isq = false
        var enPassant = ""
        
        for i in 0..<position.count{
            let piece = String(position[i])
            
            if piece == "/" {
                x += 1
                y = 0
            } else if let pieceValue = Int(piece) {
                y += pieceValue
            } else {
                board[x][y] = (piece[piece.startIndex])
                y += 1
            }
        }
        
        whiteTurn = tokens[1] == "w" ? true : false
        if (tokens[1] == "W"){
            whiteTurn = true
        }
        
        if tokens[2].range(of: "K") != nil { isK = true }
        if tokens[2].range(of: "Q") != nil { isQ = true }
        if tokens[2].range(of: "k") != nil { isk = true }
        if tokens[2].range(of: "q") != nil { isq = true }
        
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

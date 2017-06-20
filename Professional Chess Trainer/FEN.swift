//
//  FEN.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/5/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class FEN {
    
    var board = [[Character]]()
    var whiteToMove: Bool
    var isK: Bool
    var isQ: Bool
    var isk: Bool
    var isq: Bool
    var enPassant: String
    
    init(board: [[Character]], whiteTurn: Bool, wCastleKSide: Bool, wCastleQSide: Bool, bCastleKSide: Bool, bCastleQSide: Bool, enPass: String){
        self.board = board
        whiteToMove = whiteTurn
        isK = wCastleKSide
        isQ = wCastleQSide
        isk = bCastleKSide
        isq = bCastleQSide
        enPassant = enPass
    }
}

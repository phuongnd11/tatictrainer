//
//  MoveInfo.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 4/22/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class MoveInfo{
    
    var start: (Int, Int)
    var end: (Int, Int)
    var enpassantRemove: (Int, Int)
    var castlingRookStart: (Int, Int)
    var castlingRookEnd: (Int, Int)
    
    init(){
        start = (-1, -1)
        end = (-1, -1)
        enpassantRemove = (-1, -1)
        castlingRookStart = (-1, -1)
        castlingRookEnd = (-1, -1)
    }
}

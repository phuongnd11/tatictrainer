//
//  Enums.swift
//  Professional Chess Trainer
//
//  Created by MCB on 3/6/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public enum MoveResult: Int {
    // Invalid move Return List
    case invalidMove = -1
    case invalidCastling = -2
    case checkMatesInvalid = -3
    case invalidRange = -4
    case sameSquare = -5
    case emptySquare = -6
    case notInTurn = -7
    case sameColor = -8 //: the same color in destination
    case okMove = 0
    case enpass = 2
    case castling = 3 //: castling
}

public enum GameResult: Int{
    case goingOn = 0
    case whiteWin = 1
    case blackWin = 2
    case draw = 3
}
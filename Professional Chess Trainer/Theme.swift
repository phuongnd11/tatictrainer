//
//  Theme.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 5/22/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



open class Theme {
    
    struct Piece {
        static var items: [String] = ["default", "alphonso", "maya"]
        //to add normal/color
    }
    
    struct Board {
        static var items: [String] = ["default", "paper", "grass", "wood"]
        //to add normal/color
    }
    
    class var boards: [String]{
        get {return Board.items}
        set {Board.items = newValue}
    }
    
    class var pieces: [String]{
        get {return Piece.items}
        set {Piece.items = newValue}
    }
    
    
    open static func getNextPiece(_ currentPiece: String) -> String {
        let currentIndex = Piece.items.index(of: currentPiece)
        if (currentIndex != nil) {
            if currentIndex < Piece.items.count - 1  {
                return Piece.items[currentIndex! + 1]
            }
            else {
                return Piece.items[0]
            }
        }
        else {
            return "default"
        }
    }
    
    open static func getNextBoard(_ currentBoard: String) -> String {
        let currentIndex = Board.items.index(of: currentBoard)
        if (currentIndex != nil) {
            if currentIndex < Board.items.count - 1  {
                return Board.items[currentIndex! + 1]
            }
            else {
                return Board.items[0]
            }
        }
        else {
            return "default"
        }
    }
}

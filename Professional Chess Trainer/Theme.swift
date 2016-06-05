//
//  Theme.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 5/22/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation


public class Theme {
    
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
    
    
    public static func getNextPiece(currentPiece: String) -> String {
        var currentIndex = Piece.items.indexOf(currentPiece)
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
    
    public static func getNextBoard(currentBoard: String) -> String {
        var currentIndex = Board.items.indexOf(currentBoard)
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
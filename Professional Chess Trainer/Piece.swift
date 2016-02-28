//
//  Piece.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/16/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
import UIKit

enum PieceColor {
    case Black
    case White
}

struct IconSet {
    var whitePawn: UIImage!
    var whiteRook: UIImage!
    var whiteKnight: UIImage!
    var whiteBishop: UIImage!
    var whiteQueen: UIImage!
    var whiteKing: UIImage!
    
    var blackPawn: UIImage!
    var blackRook: UIImage!
    var blackKnight: UIImage!
    var blackBishop: UIImage!
    var blackQueen: UIImage!
    var blackKing: UIImage!
    
    init(){
        whitePawn = UIImage(named: "normal_white_pawn")
        whiteRook = UIImage(named: "normal_white_rook")
        whiteKnight = UIImage(named: "normal_white_knight")
        whiteBishop = UIImage(named: "normal_white_bishop")
        whiteQueen = UIImage(named: "normal_white_queen")
        whiteKing = UIImage(named: "normal_white_king")
        
        blackPawn = UIImage(named: "normal_black_pawn")
        blackRook = UIImage(named: "normal_black_rook")
        blackKnight = UIImage(named: "normal_black_knight")
        blackBishop = UIImage(named: "normal_black_bishop")
        blackQueen = UIImage(named: "normal_black_queen")
        blackKing = UIImage(named: "normal_black_king")
    }
}

public class Piece {
    
    var image: UIImage!
    var color: PieceColor!
    
    
    init(image: UIImage, color: PieceColor){
        self.image = image
        self.color = color
    }
    
    
}
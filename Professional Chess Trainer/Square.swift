//
//  Square.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/16/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
import UIKit



public class Square: UIView {
    
    var isLight: Bool
    var position: (Int, Int)
    var size: CGFloat!
    var piece: Piece!
    var occupyingPieceImageView: UIImageView!
    
    let darkSquareColor = UIColor(red: 0.7, green: 0.53, blue: 0.39, alpha: 1)
    let lightSquareColor = UIColor(red: 240/255, green: 218/255, blue: 182/255, alpha: 1)
    
    init() {
        isLight = false
        position = (0, 0)
        size = 0
        super.init(frame: CGRectZero)
    }
    
    init(x: Int, y: Int, light: Bool, squareSize: CGFloat){
        isLight = light
        position = (x, y)
        size = squareSize
        super.init(frame: CGRectMake(CGFloat(y) * size, CGFloat(x) * size, size, size))
        tag = x * 10 + y
        if light {
            backgroundColor = lightSquareColor
        } else {
            backgroundColor = darkSquareColor
        }
    }
    
    func setPiece(piece: Piece){
        self.piece = piece
        if (occupyingPieceImageView == nil) {
            occupyingPieceImageView = UIImageView(frame: CGRectMake(0, 0, size, size))
            self.addSubview(occupyingPieceImageView)
        }
        occupyingPieceImageView.image = self.piece.image
    }
    
    func isEmpty() -> Bool{
        return piece == nil
    }
    
    func clearPiece(){
        occupyingPieceImageView.removeFromSuperview()
        occupyingPieceImageView = nil
        piece = nil
    }
    
    func clearHighlight(){
        if isLight {
            backgroundColor = lightSquareColor
        } else {
            backgroundColor = darkSquareColor
        }
    }
    
    func highlight(){
        backgroundColor = UIColor.yellowColor()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
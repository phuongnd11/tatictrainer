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
    
    weak var boardView: BoardView!
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
    
    init(clone: Square) {
        isLight = clone.isLight
        size = clone.size
        position = clone.position
        super.init(frame: CGRectMake(CGFloat(position.1) * size, CGFloat(position.0) * size, size, size))
        tag = position.0 * 10 + position.1
        backgroundColor = clone.backgroundColor
        piece = clone.piece
        occupyingPieceImageView = clone.occupyingPieceImageView
        boardView = clone.boardView
    }
    
    init(x: Int, y: Int, light: Bool, squareSize: CGFloat, flipBoard: Bool, boardView: BoardView){
        isLight = light
        size = squareSize
        self.boardView = boardView
        if !flipBoard {
            position = (x, y)
        } else {
            position = (7-x, 7-y)
        }
        super.init(frame: CGRectMake(CGFloat(y) * size, CGFloat(x) * size, size, size))
        tag = position.0 * 10 + position.1
        if light {
            backgroundColor = lightSquareColor
        } else {
            backgroundColor = darkSquareColor
        }
    }
    
    func move(destSquare: Square){
        //var imgView = self.occupyingPieceImageView
        //var thisPiece = self.piece
        UIView.animateWithDuration(0.5, animations: {
            self.occupyingPieceImageView.frame = destSquare.frame
            }, completion:{(finished: Bool) -> Void in
                
        })
        destSquare.piece = self.piece
        if(destSquare.occupyingPieceImageView != nil) {
            destSquare.occupyingPieceImageView.removeFromSuperview()
        }
        destSquare.occupyingPieceImageView = self.occupyingPieceImageView
        self.piece = nil
        self.occupyingPieceImageView = nil
        //destSquare.setPiece(self.piece)
        //self.clearPiece()
    }
    
    func setPiece(piece: Piece){
        self.piece = piece
        if (occupyingPieceImageView == nil) {
            //occupyingPieceImageView = UIImageView(frame: CGRectMake(0, 0, size, size))
            occupyingPieceImageView = UIImageView(frame: self.frame)
            boardView.addSubview(occupyingPieceImageView)
            boardView.bringSubviewToFront(occupyingPieceImageView)
            //self.addSubview(occupyingPieceImageView)
        }
        occupyingPieceImageView.image = self.piece.image
    }

     func setPiece2(piece: Piece, occupyingPieceImageView: UIImageView){
        self.piece = piece
        if (self.occupyingPieceImageView == nil) {
            //occupyingPieceImageView = UIImageView(frame: CGRectMake(0, 0, size, size))
            //occupyingPieceImageView = UIImageView(frame: self.frame)
            //boardView.addSubview(occupyingPieceImageView)
            //self.addSubview(occupyingPieceImageView)
        }
        self.occupyingPieceImageView = occupyingPieceImageView
    }
    
    func isEmpty() -> Bool{
        return piece == nil
    }
    
    func clearPiece(){
        if !isEmpty() {
            occupyingPieceImageView.removeFromSuperview()
            occupyingPieceImageView = nil
            piece = nil
        }
    }
    
    func clearPiece2(){
        if !isEmpty() {
            //occupyingPieceImageView.removeFromSuperview()
            occupyingPieceImageView = nil
            piece = nil
        }
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
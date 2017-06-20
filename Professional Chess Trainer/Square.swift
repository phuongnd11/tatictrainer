//
//  Square.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/16/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
import UIKit



open class Square: UIView {
    
    weak var boardView: BoardView!
    var isLight: Bool
    var position: (Int, Int)
    var size: CGFloat!
    var piece: Piece!
    var occupyingPieceImageView: UIImageView!
    var bgSquare: UIImageView!
    let darkSquareColor = UIColor(red: 0.7, green: 0.53, blue: 0.39, alpha: 1)
    let lightSquareColor = UIColor(red: 240/255, green: 218/255, blue: 182/255, alpha: 1)
    var board: String
    
    init() {
        isLight = false
        position = (0, 0)
        size = 0
        board = "default"
        super.init(frame: CGRect.zero)
    }
    
    init(clone: Square) {
        isLight = clone.isLight
        size = clone.size
        position = clone.position
        board = clone.board
        super.init(frame: CGRect(x: CGFloat(position.1) * size, y: CGFloat(position.0) * size, width: size, height: size))
        tag = position.0 * 10 + position.1
        backgroundColor = clone.backgroundColor
        piece = clone.piece
        occupyingPieceImageView = clone.occupyingPieceImageView
        bgSquare = clone.bgSquare
        boardView = clone.boardView
    }
    
    init(x: Int, y: Int, light: Bool, squareSize: CGFloat, flipBoard: Bool, boardView: BoardView, board: String){
        isLight = light
        size = squareSize
        self.boardView = boardView
        self.board = board
        if !flipBoard {
            position = (x, y)
        } else {
            position = (7-x, 7-y)
        }
        super.init(frame: CGRect(x: CGFloat(y) * size, y: CGFloat(x) * size, width: size, height: size))
        tag = position.0 * 10 + position.1
        if light {
            if (board == "normal"){
                backgroundColor = lightSquareColor
            }
            else {
                bgSquare = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
                bgSquare.image = UIImage(named: board + "_light")
                if bgSquare.image != nil {
                    self.addSubview(bgSquare)
                    self.sendSubview(toBack: bgSquare)
                }
                //else {
                  //  backgroundColor = lightSquareColor
                //}
            }
        } else {
            if (board == "normal"){
                backgroundColor = darkSquareColor
            }
            else {
                bgSquare = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
                bgSquare.image = UIImage(named: board + "_dark")
                if bgSquare.image != nil {
                    self.addSubview(bgSquare)
                    self.sendSubview(toBack: bgSquare)
                }
                //else {
                  //  backgroundColor = darkSquareColor
                //}
            }
        }
    }
    
    func move(_ destSquare: Square){
        destSquare.clearPiece()
        destSquare.receivePiece(self.piece,
                                occupyingPieceImageView: self.occupyingPieceImageView)
        self.releasePiece()
    }
    
    func setPiece(_ piece: Piece){
        self.piece = piece
        if (occupyingPieceImageView == nil) {
            //occupyingPieceImageView = UIImageView(frame: self.frame)
            occupyingPieceImageView = UIImageView(frame: UIUtils.calculatePieceFrame(self.frame))
            boardView.addSubview(occupyingPieceImageView)
            boardView.bringSubview(toFront: occupyingPieceImageView)
        }
        occupyingPieceImageView.image = self.piece.image
    }

     func receivePiece(_ piece: Piece, occupyingPieceImageView: UIImageView){
        self.piece = piece
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
    
    func releasePiece(){
        if !isEmpty() {
            occupyingPieceImageView = nil
            piece = nil
        }
    }
    
    func clearHighlight(){
        if isLight {
            self.bgSquare.image = UIImage(named: board + "_light")
        } else {
            self.bgSquare.image = UIImage(named: board + "_dark")
        }
        //self.bringSubviewToFront(bgSquare)
        //if !isEmpty(){
          //  self.bringSubviewToFront(occupyingPieceImageView)
        //}
    }
    
    func highlight(){
        if (isLight) {
            self.bgSquare.image = UIImage(named: board + "_light_selected")
        }
        else {
            self.bgSquare.image = UIImage(named: board + "_dark_selected")
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

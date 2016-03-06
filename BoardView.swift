//
//  BoardView.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 1/31/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit

@IBDesignable
class BoardView: UIView {
    
    var margin: CGFloat = 0
    
    var size: CGFloat {
        return (bounds.size.width - margin) / 8
    }
    
    let iconSet: IconSet = IconSet()
    
    let darkSquareColor = UIColor(red: 0.7, green: 0.53, blue: 0.39, alpha: 1)
    let lightSquareColor = UIColor(red: 240/255, green: 218/255, blue: 182/255, alpha: 1)
    
    var squares = [[Square]](count: 8, repeatedValue: Array(count: 8, repeatedValue: Square()))
    var board = [[Character]](count: 8, repeatedValue: Array(count: 8, repeatedValue: "e"))
    var highlightedSquare: (Int, Int) = (-1, -1)
    var moves = ""
    var whiteToMove = true
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func drawRect(rect: CGRect) {
        //		var drawingRecipe = UIBezierPath(roundedRect: r, cornerRadius: 5)
        var flip = false //alternating dark and light
        //board = FENUtils().readBoardFromFEN("r2qk2r/pp6/2pbp3/2Pp1p2/3PBPp1/4PRp1/PP1BQ1P1/4R1K1 b kq – 0 20")
        var fen = FENUtils().readBoardFromFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

        board = fen.board
        
        for x in 0...7 {
            print("")
            for y in 0...7 {
                print("\(board[x][y]) ", terminator: "")
 
                var square: Square
                
                square = Square(x: x, y: y, light: flip, squareSize: size)
                
                var piece:Piece
                
                if (board[x][y] != "e"){
                    switch board[x][y] {
                        case "r":
                            piece = Rook(image: iconSet.blackRook, color: .Black)
                        case "b":
                            piece = Bishop(image: iconSet.blackBishop, color: .Black)
                        case "n":
                            piece = Knight(image: iconSet.blackKnight, color: .Black)
                        case "q":
                            piece = Queen(image: iconSet.blackQueen, color: .Black)
                        case "k":
                            piece = King(image: iconSet.blackKing, color: .Black)
                        case "p":
                            piece = Pawn(image: iconSet.blackPawn, color: .Black)
                        case "R":
                            piece = Rook(image: iconSet.whiteRook, color: .White)
                        case "B":
                            piece = Bishop(image: iconSet.whiteBishop, color: .White)
                        case "N":
                            piece = Knight(image: iconSet.whiteKnight, color: .White)
                        case "Q":
                            piece = Queen(image: iconSet.whiteQueen, color: .White)
                        case "K":
                            piece = King(image: iconSet.whiteKing, color: .White)
                        case "P":
                            piece = Pawn(image: iconSet.whitePawn, color: .White)
                        default:
                            piece = Pawn(image: iconSet.whitePawn, color: .White)
                    }
                    
                    square.setPiece(piece)
                }
                
                
                flip = !flip
                
                let squareTapGesture = UITapGestureRecognizer(target: self, action: "squareTapView:")
                
                square.addGestureRecognizer(squareTapGesture)
                square.userInteractionEnabled = true
                square.multipleTouchEnabled = false

                self.addSubview(square)
                squares[x][y] = square
            }
            flip = !flip
        }
    }
   
    func squareTapView(sender: UITapGestureRecognizer){
        
        if (highlightedSquare.0 != -1) {
            let tag = sender.view!.tag
            
            let dest: (Int, Int) = (tag/10, tag%10)
            
            //moves += ChessLogicUtils().toStandardMove(highlightedSquare, dest: dest, board: squares)
            
            //print("move: \(moves)")
            let result = ChessLogicUtils().isValidMove(highlightedSquare, dest: dest, board: squares, whiteToMove: whiteToMove, isK: true, isQ: true, isk: true, isq: true, enPassant: (-1, -1))
            if (result.rawValue > (-1)){
                //squares[tag/10][tag%10].setPiece(squares[highlightedSquare.0][highlightedSquare.1].piece)
                //squares[highlightedSquare.0][highlightedSquare.1].clearPiece()
                ChessLogicUtils().TryMove(highlightedSquare, dest: dest, board: squares, isWhiteMove: whiteToMove, moveResult: result, isTest: false)
                //--------------------------------debug only
                board[tag/10][tag%10] = board[highlightedSquare.0][highlightedSquare.1]
                board[highlightedSquare.0][highlightedSquare.1] = "e"
                //-------------------------------------
                whiteToMove = !whiteToMove
                
            }
            squares[highlightedSquare.0][highlightedSquare.1].clearHighlight()
            highlightedSquare.0 = -1
            highlightedSquare.1 = -1
            

        } else {

            let tag = sender.view!.tag
            
            if !squares[tag/10][tag%10].isEmpty() {
                highlightedSquare.0 = tag/10
                highlightedSquare.1 = tag%10
                squares[highlightedSquare.0][highlightedSquare.1].highlight()
            }
            
        }
        print("----------------------------------------------")
        for x in 0...7 {
            print("")
            for y in 0...7 {
                print("\(board[x][y]) ", terminator: "")
            }
        }
    }
    
}




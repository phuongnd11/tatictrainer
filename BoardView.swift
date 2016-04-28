//
//  BoardView.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 1/31/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit
import GameKit

protocol PrintEventDelegate: class {
    func moveFinish(moveResult: MoveResult)
}

protocol UpdateStatusDelegate: class {
    func updateUserStatus(correctMove: Bool, moveNum: (Int, Int))
}

//@IBDesignable
class BoardView: UIView {
    let chessLogicUtils = ChessLogicUtils()
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
    var boardStatus = BoardStatus()
    var puzzle: Puzzle!
    var boardHistory = [BoardHistory?]()
    var userWon = false
    var disable = false
    var onMove = false
    
    //event delegate
    weak var moveFinishDelegate: PrintEventDelegate?
    weak var updateStatusDelegate: UpdateStatusDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func reload(newPuzzle: Puzzle) {
        self.puzzle = newPuzzle
        userWon = false
        disable = false
        onMove = false
        boardStatus = BoardStatus()
        if puzzle.flipBoard {
                boardStatus.isWhiteMove = false
        }
        highlightedSquare = (-1, -1)
        boardHistory = [BoardHistory?](count: puzzle.numOfMoves, repeatedValue: nil)
    
        squares = [[Square]](count: 8, repeatedValue: Array(count: 8, repeatedValue: Square()))
        board = [[Character]](count: 8, repeatedValue: Array(count: 8, repeatedValue: "e"))
    }
   
    override func drawRect(rect: CGRect) {
        
        var flip = false //alternating dark and light
        
        if puzzle == nil {
            puzzle = PuzzleFactory.puzzleFactory.getPuzzleById(UserData.getLastPlayedPuzzle())
            if puzzle == nil {
                puzzle = Puzzle(FEN: "2q1r1k1/1p3p2/p2p3Q/2pPr3/2P1p3/PP2Pn1P/1R1N1PK1/7R b - - 0 1", computerMove: "", solution: "...Rg5+ Kf1 Rg6 Qf4 Qxh3+", idea: "Unknown - Unknown (2016)", elo: 1500, id: 5)
            }
        }
        if puzzle.flipBoard {
            boardStatus.isWhiteMove = false
        }
        
        boardHistory = [BoardHistory?](count: puzzle.numOfMoves, repeatedValue: nil)
        
        var board = puzzle.fen.board
        
        for x in 0...7 {
            print("")
            for y in 0...7 {
                var symbol: Character!
                
                if puzzle.flipBoard {
                    symbol = board[7-x][7-y]
                } else {
                    symbol = board[x][y]
                }
                
                print("\(symbol) ", terminator: "")
                
                var square: Square
                
                square = Square(x: x, y: y, light: flip, squareSize: size, flipBoard: puzzle.flipBoard, boardView: self)
                self.addSubview(square)
                var piece:Piece
                
                if (symbol != "e"){
                    switch symbol {
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

                if (!puzzle.flipBoard) {
                    squares[x][y] = square
                } else {
                    squares[7-x][7-y] = square
                }
            }
            flip = !flip
        }
        
        
        
    }
   
    func squareTapView(sender: UITapGestureRecognizer){
        if !userWon && !disable && !onMove {
            if (highlightedSquare.0 != -1) {
                let tag = sender.view!.tag
                
                let dest: (Int, Int) = (tag/10, tag%10)
                
                let move = chessLogicUtils.getMoveResult(highlightedSquare, dest: dest, board: squares, boardStatus: boardStatus, isCheckGame: true)
                let result = move.moveResult
                self.moveFinishDelegate?.moveFinish(result)
                if (result.rawValue > (-1)){
                    NSLog("Move Number InIt: " + String(boardStatus.moveNumber))
                    boardHistory[boardStatus.moveNumber] = BoardHistory(start: Square(clone: squares[highlightedSquare.0][highlightedSquare.1]), dest: Square(clone: squares[dest.0][dest.1]), status: BoardStatus(clone: boardStatus))
                    
                    let currentPiece = squares[highlightedSquare.0][highlightedSquare.1].piece
                    
                    var moveInfo = chessLogicUtils.TryMove(highlightedSquare, dest: dest, board: squares, isWhiteMove: boardStatus.isWhiteMove, moveResult: result, isTest: false)
                    
                    self.onMove = true
                    
                    UIView.animateWithDuration(0.4, animations:{
        
                        self.bringSubviewToFront(self.squares[moveInfo.start.0][moveInfo.start.1].occupyingPieceImageView)
                        self.squares[moveInfo.start.0][moveInfo.start.1].occupyingPieceImageView.frame =
                        self.squares[moveInfo.end.0][moveInfo.end.1].frame
                        
                        }, completion:{(finished: Bool) -> Void in
                            //SoundPlayer().playMove()
                            if (!self.squares[moveInfo.end.0][moveInfo.end.1].isEmpty()){
                                Chirp.sharedManager.playSound(fileName: "eat")
                            }
                            else {
                                Chirp.sharedManager.playSound(fileName: "move")
                            }
                            self.squares[moveInfo.start.0][moveInfo.start.1].move(self.squares[moveInfo.end.0][moveInfo.end.1])
                            
                            self.boardStatus.updateStatus(self.highlightedSquare, dest: dest,movedPiece: currentPiece, moveResult:result)
                            
                            let moveText = move.pgn
                            
                            var moveNum = (self.boardStatus.moveNumber, self.puzzle.numOfMoves)
                            if self.puzzle.validateMove(moveText, moveNumber: self.boardStatus.moveNumber) {
                                self.updateStatusDelegate?.updateUserStatus(true, moveNum: moveNum)
                                if self.boardStatus.moveNumber >= self.puzzle.numOfMoves {
                                    self.userWon = true
                                } else {
                                    let nextMove = self.puzzle.getNextComputerMove(self.boardStatus.moveNumber)
                                    //computerMove
                                    let nextComputerMove = PNGUtils().GetMoveFromPgn(nextMove, board: self.squares, isWhiteMove: self.boardStatus.isWhiteMove)
                                    
                                    var computerMove = self.chessLogicUtils.TryMove(nextComputerMove.start, dest: nextComputerMove.dest, board: self.squares, isWhiteMove: self.boardStatus.isWhiteMove, moveResult: nextComputerMove.moveResult, isTest: false)
                                    
                                    UIView.animateWithDuration(0.4, delay: 0.1, options:UIViewAnimationOptions.CurveLinear, animations: {
                                        self.bringSubviewToFront(self.squares[computerMove.start.0][computerMove.start.1].occupyingPieceImageView)
                                        self.squares[computerMove.start.0][computerMove.start.1].occupyingPieceImageView.frame = self.squares[computerMove.end.0][computerMove.end.1].frame
                                        
                                        },
                                        completion: {(finished: Bool) -> Void in
                                            //SoundPlayer().playMove()
                                            if (!self.squares[computerMove.end.0][computerMove.end.1].isEmpty()){
                                                Chirp.sharedManager.playSound(fileName: "eat")
                                            }
                                            else {
                                                Chirp.sharedManager.playSound(fileName: "move")
                                            }
                                            
                                            self.boardHistory[self.boardStatus.moveNumber] = BoardHistory(start: Square(clone: self.squares[computerMove.start.0][computerMove.start.1]), dest: Square(clone: self.squares[computerMove.end.0][computerMove.end.1]), status: BoardStatus(clone: self.boardStatus))
                                            
                                            self.squares[computerMove.start.0][computerMove.start.1].move(self.squares[computerMove.end.0][computerMove.end.1])
    
                                        self.boardStatus.updateStatus(nextComputerMove.start, dest:nextComputerMove.dest,movedPiece: self.squares[nextComputerMove.dest.0][nextComputerMove.dest.1].piece!, moveResult:nextComputerMove.moveResult)
                                    })
                                    
                                }
                            }
                            else {
                                self.updateStatusDelegate?.updateUserStatus(false, moveNum: moveNum)
                                //goto(boardHistory[boardStatus.moveNumber-1]!)
                                //revert board status
                                self.disable = true
                            }
                        self.onMove = false
                    })
                    
                                      //--------------------------------debug only
                    board[tag/10][tag%10] = board[highlightedSquare.0][highlightedSquare.1]
                    board[highlightedSquare.0][highlightedSquare.1] = "e"
                    //-------------------------------------
                    
                }
                squares[highlightedSquare.0][highlightedSquare.1].clearHighlight()
                highlightedSquare.0 = -1
                highlightedSquare.1 = -1
                
                
            } else {
                
                let tag = sender.view!.tag
                
                if !squares[tag/10][tag%10].isEmpty() {
                    if((boardStatus.isWhiteMove) == (squares[tag/10][tag%10].piece!.color == PieceColor.White)){
                        highlightedSquare.0 = tag/10
                        highlightedSquare.1 = tag%10
                        squares[highlightedSquare.0][highlightedSquare.1].highlight()
                    }
                }
                
            }
        }
    }
    
    func goto(history: BoardHistory) {
        let start = history.start.position
        let dest = history.dest.position
        
        squares[start.0][start.1].clearPiece()
        if (!history.start.isEmpty()) {
            squares[start.0][start.1].setPiece(history.start.piece)
        }
        
        squares[dest.0][dest.1].clearPiece()
        if (!history.dest.isEmpty()) {
            squares[dest.0][dest.1].setPiece(history.dest.piece)
        }
        
        boardStatus = history.status
    }
    
    func retry(){
        if (boardStatus.moveNumber > 0){
            goto(boardHistory[boardStatus.moveNumber-1]!)
            disable = false
        }
    }
    
    func getPuzzle() -> Puzzle {
        return self.puzzle
    }
    
    func moveBack(){
        while(boardStatus.moveNumber > 0){
            goto(boardHistory[boardStatus.moveNumber-1]!)
        }
    }
    
    func showSolution(){
        if (self.boardStatus.moveNumber >= puzzle.numOfMoves) {
            return
        }
        let moves = self.puzzle.solutionMoves.componentsSeparatedByString(" ")
        
        var pngMove = moves[self.boardStatus.moveNumber]
            
            let move = PNGUtils().GetMoveFromPgn(pngMove, board: self.squares, isWhiteMove: self.boardStatus.isWhiteMove)
            
            var computerMove = self.chessLogicUtils.TryMove(move.start, dest: move.dest, board: self.squares, isWhiteMove: self.boardStatus.isWhiteMove, moveResult: move.moveResult, isTest: false)
            
            UIView.animateWithDuration(0.5, delay: 0.4, options:UIViewAnimationOptions.CurveLinear, animations: {
                self.bringSubviewToFront(self.squares[computerMove.start.0][computerMove.start.1].occupyingPieceImageView)
                self.squares[computerMove.start.0][computerMove.start.1].occupyingPieceImageView.frame = self.squares[computerMove.end.0][computerMove.end.1].frame
                
                },
                        completion: {(finished: Bool) -> Void in
                        //SoundPlayer().playMove()
                            if (!self.squares[computerMove.end.0][computerMove.end.1].isEmpty()){
                                 Chirp.sharedManager.playSound(fileName: "eat")
                            }
                            else {
                                Chirp.sharedManager.playSound(fileName: "move")
                            }
                        
                                        
                        self.boardHistory[self.boardStatus.moveNumber] = BoardHistory(start: Square(clone: self.squares[computerMove.start.0][computerMove.start.1]), dest: Square(clone: self.squares[computerMove.end.0][computerMove.end.1]), status: BoardStatus(clone: self.boardStatus))
                                        
                        self.squares[computerMove.start.0][computerMove.start.1].move(self.squares[computerMove.end.0][computerMove.end.1])
                                        
                        self.boardStatus.updateStatus(move.start, dest:move.dest,movedPiece: self.squares[move.dest.0][move.dest.1].piece!, moveResult:move.moveResult)
                            self.showSolution()
            })

        }
        
    
}




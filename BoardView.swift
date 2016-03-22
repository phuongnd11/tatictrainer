//
//  BoardView.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 1/31/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit

protocol PrintEventDelegate {
    func moveFinish(moveResult: MoveResult)
}

protocol UpdateStatusDelegate {
    func updateUserStatus(correctMove: Bool)
}

protocol NextPuzzleDelegate {
    func loadNextPuzzle()
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
    
    //event delegate
    var moveFinishDelegate: PrintEventDelegate?
    var updateStatusDelegate: UpdateStatusDelegate?
    var nextPuzzleDelegate: NextPuzzleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func reload(newPuzzle: Puzzle) {
        self.puzzle = newPuzzle
        var boardStatus = BoardStatus()
        if puzzle.flipBoard {
                boardStatus.isWhiteMove = false
        }
        squares = [[Square]](count: 8, repeatedValue: Array(count: 8, repeatedValue: Square()))
        board = [[Character]](count: 8, repeatedValue: Array(count: 8, repeatedValue: "e"))
    }
   
    override func drawRect(rect: CGRect) {

        var flip = false //alternating dark and light
        
        if puzzle == nil {
            puzzle = Puzzle(FEN: "2q1r1k1/1p3p2/p2p3Q/2pPr3/2P1p3/PP2Pn1P/1R1N1PK1/7R b - - 0 1", computerMove: "", solution: "...Rg5+ Kf1 Rg6 Qf4 Qxh3+")
        }
        if puzzle.flipBoard {
            boardStatus.isWhiteMove = false
        }
        
        boardHistory = [BoardHistory?](count: puzzle.numOfMoves, repeatedValue: nil)
        //var fen = FENUtils().readBoardFromFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        
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
                
                square = Square(x: x, y: y, light: flip, squareSize: size, flipBoard: puzzle.flipBoard)
                
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

                self.addSubview(square)
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
        
        if (highlightedSquare.0 != -1) {
            let tag = sender.view!.tag
            
            let dest: (Int, Int) = (tag/10, tag%10)
            
            //moves += ChessLogicUtils().toStandardMove(highlightedSquare, dest: dest, board: squares)
            
            //print("move: \(moves)")
            let move = chessLogicUtils.getMoveResult(highlightedSquare, dest: dest, board: squares, boardStatus: boardStatus, isCheckGame: true)
            let result = move.moveResult
            self.moveFinishDelegate?.moveFinish(result)
            if (result.rawValue > (-1)){
                
                boardHistory[boardStatus.moveNumber] = BoardHistory(start: Square(clone: squares[highlightedSquare.0][highlightedSquare.1]), dest: Square(clone: squares[dest.0][dest.1]), status: BoardStatus(clone: boardStatus))
                
                let currentPiece = squares[highlightedSquare.0][highlightedSquare.1].piece
                
                chessLogicUtils.TryMove(highlightedSquare, dest: dest, board: squares, isWhiteMove: boardStatus.isWhiteMove, moveResult: result, isTest: false)
                
                boardStatus.updateStatus(highlightedSquare, dest: dest,movedPiece: currentPiece, moveResult:result)
                
                let moveText = move.pgn
                
                // if move is correct
                NSLog(moveText)
                if puzzle.validateMove(moveText, moveNumber: boardStatus.moveNumber) {
                    updateStatusDelegate?.updateUserStatus(true)
                    if boardStatus.moveNumber >= puzzle.numOfMoves {
                     //next puzzle
                    } else {
                        var nextMove = puzzle.getNextComputerMove(boardStatus.moveNumber)
                        //computerMove
                    }
                }
                else {
                    updateStatusDelegate?.updateUserStatus(false)
                    goto(boardHistory[boardStatus.moveNumber-1]!)
                    //revert board status
                }
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
        if (false){
            print(boardStatus.isWhiteMove)
            print(boardStatus.isKingWhiteCastling)
            print(boardStatus.isQueenWhiteCastling)
            print(boardStatus.isKingBlackCastling)
            print(boardStatus.isQueenBlackCastling)
            print("----------------------------------------------")
            for x in 0...7 {
                print("")
                for y in 0...7 {
                    print("\(board[x][y]) ", terminator: "")
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
}




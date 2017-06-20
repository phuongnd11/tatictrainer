//
//  ChessLogicUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/15/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

open class ChessLogicUtils {
    
    let squareY: String = "abcdefgh"
    let squareX: String = "87654321"
    let pgnUtil = PNGUtils()

    
    // Invalid move Return List
    //-1: invalid move
    //-2: invalid castling
    //-3: check mates - invalid
    //-4: invalid range
    //-5: same square - invalid
    //-6: current square is empty
    //-7: it's not your turn
    //-8: the same color in destination
    //0: Ok move
    //2: enpass
    //3: castling
    fileprivate func checkColorValid(_ currentSquare: Square, destSquare: Square, boardStatus: BoardStatus) -> MoveResult{
        
        //check current square
        if(currentSquare.isEmpty()) {
            return MoveResult.emptySquare
        }
        
        let currentPiece = currentSquare.piece!;
        if (boardStatus.isWhiteMove && currentPiece.color == PieceColor.black){
            return MoveResult.notInTurn;
        }
        if (!boardStatus.isWhiteMove && currentPiece.color == PieceColor.white){
            return MoveResult.notInTurn;
        }
        
        
        if (!destSquare.isEmpty()){
            //x
            let destPiece = destSquare.piece!;
            
            if (destPiece.color == currentPiece.color){
                return MoveResult.sameColor
            }
        }
        return MoveResult.okMove
    }
    open func isValidMove(_ start: (Int, Int), dest: (Int, Int), board: [[Square]], boardStatus: BoardStatus) -> Bool{
        let move = getMoveResult(start, dest: dest, board: board, boardStatus: boardStatus, isCheckGame: false)
        return move.moveResult.rawValue >= 0
    }
    
    open func getMoveResult(_ start: (Int, Int), dest: (Int, Int), board: [[Square]], boardStatus: BoardStatus, isCheckGame:Bool ) -> (Move) {
        let move = Move(start: start, dest: dest)
        
        if (!checkRange(start, dest: dest)){
            move.moveResult = MoveResult.invalidRange
            return move;
        }
        
        if (start.0 == dest.0 && start.1 == dest.1){
            move.moveResult = MoveResult.sameSquare
            return move;
        }
        
        let currentSquare = board[start.0][start.1]
        let destSquare = board[dest.0][dest.1]
        let currentPiece = currentSquare.piece!;
        
        var returnCode = checkColorValid(currentSquare,destSquare: destSquare, boardStatus: boardStatus)
        
        if (returnCode.rawValue < 0){
            move.moveResult = returnCode
            return move
        }
        var result = false;
        var isEnpass = false
        // check nhap thanh
        if (checkCastling(start,dest:dest,board:board,isK: boardStatus.isKingWhiteCastling,isQ:boardStatus.isQueenWhiteCastling,isk:boardStatus.isKingBlackCastling, isq:boardStatus.isQueenBlackCastling))
        {
            //if start.1 > dest.1 -> O-O-O
            //else 0 - 0
            returnCode = MoveResult.castling
        }
        if (returnCode.rawValue == 0 && ((currentPiece is Pawn) && (dest.0 == boardStatus.enPassant.0 && dest.1 == boardStatus.enPassant.1))){
            // check tot qua duong
            result = Pawn.isPawnCanEat(start,dest: dest,board: board)
            isEnpass = result
            if (isEnpass){
                //squareY[start.1] + "x" + positionToSquare(dest)
                returnCode = MoveResult.enpass
            }
            else{
                returnCode = MoveResult.invalidMove
            }
        }
        else if (returnCode.rawValue == 0){
            result = currentPiece.isValidMove(start, dest: dest, board: board)
            if (!result){
                returnCode = MoveResult.invalidMove
            }
            else{
                returnCode = MoveResult.okMove
            }
        }
        if (result){
            let pieces = convertToPiece(board)
            let boardStatusClone = boardStatus.copy() as! BoardStatus
            TryMove(start, dest:dest, board:board, isWhiteMove: boardStatus.isWhiteMove , moveResult: returnCode, isTest: true)
            result = !isCheckMate(boardStatus.isWhiteMove, board: board)
            
            if (result)
            {
                if (isCheckGame){
                    //note: parameter is not ref, unlike C#
                    boardStatusClone.updateStatus(start, dest: dest, movedPiece: currentPiece, moveResult: returnCode)
                    move.gameResult = CheckResult(board,boardStatus: boardStatusClone)
                }
            }
            else
            {
                returnCode = MoveResult.checkMatesInvalid;
            }
            copyToBoard(board, pieces: pieces)
        }
        
        if (returnCode == MoveResult.okMove && !destSquare.isEmpty()){
            returnCode = MoveResult.eat
        }
        move.moveResult = returnCode
        
        if (isCheckGame && returnCode.rawValue >= 0){
            move.pgn = pgnUtil.getPngFromMove(move, board: board, isWhiteMove: boardStatus.isWhiteMove)
        }
        
        if (move.moveResult == MoveResult.castling){
            let king = board[start.0][start.1].piece
            
          //  if (!(king is King)){
            //    return nil
            //}
            let row = start.0
            var rookCol = 0 // mac dinh canh hau
            var rookColDest = 3
            if (dest.1 > start.1){ // canh vua
                rookCol = 7
                rookColDest = 5
            }
            
            move.castlingRookStart = (row, rookCol)
            move.castlingRookEnd = (row, rookColDest)
        }
        if (move.moveResult == MoveResult.enpass){
            if (boardStatus.isWhiteMove){//quan bi an la quan den
                move.enpassantRemove = (dest.0+1, dest.1)
            }
            else {
                move.enpassantRemove = (dest.0-1, dest.1)
            }
        }
        return move
    }
    
    fileprivate func applyPiece(_ square:Square, piece:Piece?, test:Bool){
        if (test){
            square.piece = piece
        }
        else{
            if (piece == nil){
                square.clearPiece()
            }
            else{
                square.setPiece(piece!)
            }
        }
    }
    
    
    open func movePiece(_ startSquare: Square?, destSquare: Square, test: Bool){
        if (test){
            if startSquare != nil {
                destSquare.piece = startSquare!.piece
            }
        }
        else{
          if (startSquare == nil){
            destSquare.clearPiece()
          }
          else {
            startSquare!.move(destSquare)
          }
        }
    }
    
    open func CheckResult(_ board: [[Square]], boardStatus: BoardStatus) -> GameResult{
        var colorToCheck = PieceColor.black
        if (boardStatus.isWhiteMove){
            colorToCheck = PieceColor.white
        }
        
        var kingRow = -1
        var kingCol = -1
        // find king
        for i in 0 ..< 8{
            for j in 0 ..< 8{
                if (!board[i][j].isEmpty() && !(board[i][j].piece.color == colorToCheck)){
                    if (board[i][j].piece is King){
                        kingRow = i
                        kingCol = j
                        break
                    }
                }
            }
        }
        
        if (kingRow == -1 && kingCol == -1){
            if (colorToCheck == PieceColor.white){
                return GameResult.whiteWin
            }
            if (colorToCheck == PieceColor.black){
                return GameResult.blackWin
            }
        }
        var gameResult = GameResult.goingOn
        if (isCheckMate(boardStatus.isWhiteMove, board: board)){
            if (boardStatus.isWhiteMove){
                gameResult = GameResult.blackCheck
            }
            else{
                gameResult = GameResult.whiteCheck
            }
        }
        for i in 0 ..< 8{
            for j in 0 ..< 8{
                if (!board[i][j].isEmpty() && board[i][j].piece.color == colorToCheck){
                    for mRow in 0 ..< 8{
                        for mCol in 0 ..< 8{
                            if (isValidMove((i,j), dest: (mRow,mCol), board: board, boardStatus: boardStatus)){
                                return gameResult
                            }
                        }
                    }
                }
            }
        }
        // đang chiếu và bí nước
        if (gameResult == GameResult.blackCheck){
                return GameResult.blackWin
        }
        else if (gameResult == GameResult.whiteCheck){
                return GameResult.whiteWin
        }
        else{
            return GameResult.draw
        }
    }
    
    open func TryMove(_ start: (Int, Int), dest: (Int, Int), board:[[Square]], isWhiteMove: Bool, moveResult: MoveResult, isTest:Bool){
        if (moveResult.rawValue < 0){
            return
        }
        if (moveResult == MoveResult.castling){
            let king = board[start.0][start.1].piece
            
            if (!(king is King)){
                return
            }
            let row = start.0
            var rookCol = 0 // mac dinh canh hau
            var rookColDest = 3
            if (dest.1 > start.1){ // canh vua
                rookCol = 7
                rookColDest = 5
            }
            
            let rook = board[row][rookCol].piece
            if (isTest)
            {
            applyPiece(board[row][dest.1], piece: king, test: isTest)
            applyPiece(board[row][rookColDest], piece: rook, test: isTest)
            
            applyPiece(board[row][start.1], piece: nil, test: isTest)
            applyPiece(board[row][rookCol], piece: nil, test: isTest)
            }
            return
        }
        if (moveResult == MoveResult.enpass){
            if (isWhiteMove && isTest){//quan bi an la quan den
                applyPiece(board[dest.0+1][dest.1], piece: nil, test: isTest)
            }
            else {
                applyPiece(board[dest.0-1][dest.1], piece: nil, test: isTest)
            }
        }
        applyPiece(board[dest.0][dest.1], piece: board[start.0][start.1].piece, test: isTest)
        
        applyPiece(board[start.0][start.1], piece: nil, test: isTest)
    }

    
    open func TryMove2(_ start: (Int, Int), dest: (Int, Int), board:[[Square]], isWhiteMove: Bool, moveResult: MoveResult, isTest:Bool) -> MoveInfo!{
        let moveInfo = MoveInfo()
        if (moveResult.rawValue < 0){
            return nil
        }
        if (moveResult == MoveResult.castling){
            let king = board[start.0][start.1].piece
            
            if (!(king is King)){
                return nil
            }
            let row = start.0
            var rookCol = 0 // mac dinh canh hau
            var rookColDest = 3
            if (dest.1 > start.1){ // canh vua
                rookCol = 7
                rookColDest = 5
            }
            
            _ = board[row][rookCol].piece
            
            //applyPiece(board[row][dest.1], piece: king, test: isTest)
            //movePiece(board[start.0][start.1], destSquare: board[row][dest.1], test: isTest)
            moveInfo.start = (start.0, start.1)
            moveInfo.end = (row, dest.1)
            //applyPiece(board[row][rookColDest], piece: rook, test: isTest)
            //movePiece(board[row][rookCol], destSquare: board[row][rookColDest], test: isTest)
            moveInfo.castlingRookStart = (row, rookCol)
            moveInfo.castlingRookEnd = (row, rookColDest)
            
            //applyPiece(board[row][start.1], piece: nil, test: isTest)
            //applyPiece(board[row][rookCol], piece: nil, test: isTest)
            return moveInfo
        }
        if (moveResult == MoveResult.enpass){
            if (isWhiteMove){//quan bi an la quan den
                //applyPiece(board[dest.0+1][dest.1], piece: nil, test: isTest)
                //movePiece(nil, destSquare: board[dest.0+1][dest.1], test: isTest)
                moveInfo.enpassantRemove = (dest.0+1, dest.1)
            }
            else {
                //applyPiece(board[dest.0-1][dest.1], piece: nil, test: isTest)
                //movePiece(nil, destSquare: board[dest.0-1][dest.1], test: isTest)
                moveInfo.enpassantRemove = (dest.0-1, dest.1)
            }
        }
        //movePiece(board[start.0][start.1], destSquare: board[dest.0][dest.1], test: isTest)
        //applyPiece(board[dest.0][dest.1], piece: board[start.0][start.1].piece, test: isTest)

        //applyPiece(board[start.0][start.1], piece: nil, test: isTest)
        moveInfo.start = (start.0, start.1)
        moveInfo.end = (dest.0, dest.1)
        
        return moveInfo
    }
    
    fileprivate func checkCastling(_ start: (Int, Int), dest: (Int, Int), board: [[Square]], isK: Bool, isQ: Bool, isk: Bool, isq: Bool) ->Bool{
        let currentPiece = board[start.0][start.1].piece!;
        
        if (currentPiece is King && start.0 == dest.0 && abs(start.1-dest.1) == 2){
            if (currentPiece.color == PieceColor.white){
                if (isK && dest.0 == 7 && dest.1 == 6){
                    for i in 0 ..< 2{
                        if (!board[7][i+5].isEmpty()){
                            return false
                        }
                    }
                }
                else if (isQ && dest.0 == 7 && dest.1 == 2){
                    for i in 0 ..< 3{
                        if (!board[7][i+1].isEmpty()){
                            return false
                        }
                    }
                }
                else{
                    return false
                }
            }
            
            if (currentPiece.color == PieceColor.black){
                if (isk && dest.0 == 0 && dest.1 == 6){
                    for i in 0 ..< 2{
                        if (!board[0][i+5].isEmpty()){
                            return false
                        }
                    }
                }
                else if (isq && dest.0 == 0 && dest.1 == 2){
                    for i in 0 ..< 3{
                        if (!board[0][i+1].isEmpty()){
                            return false
                        }
                    }
                }
                else{
                    return false
                }
            }
            return !isCheckMate(currentPiece.color == PieceColor.white, board: board)
        }
        return false;
    }
    
    open func isCheckMate(_ isCheckWhite:Bool,board: [[Square]]) -> Bool{
        // find king location
        var kingRow = -1
        var kingCol = -1
        
        var kingColor = PieceColor.black
        var checkColor = PieceColor.white
        if (isCheckWhite){
            kingColor = PieceColor.white
            checkColor = PieceColor.black
        }
        for i in 0 ..< 8{
            for j in 0 ..< 8{
                if (board[i][j].piece is King){
                    if (board[i][j].piece.color == kingColor){
                        kingRow = i;
                        kingCol = j;
                    }
                }
            }
        }
        
        for i in 0 ..< 8{
            for j in 0 ..< 8{
                if (!board[i][j].isEmpty() && board[i][j].piece.color == checkColor){
                    if (board[i][j].piece.isValidMove((i,j), dest: (kingRow,kingCol), board: board)){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    fileprivate func convertToPiece(_ board: [[Square]]) -> [[Piece?]]{
        var pieces = [[Piece?]](repeating: Array(repeating: nil, count: 8), count: 8)
        for i in 0 ..< 8{
            for j in 0 ..< 8{
                if (!board[i][j].isEmpty()){
                    pieces[i][j] = board[i][j].piece
                }
            }
        }
        return pieces
    }
    fileprivate func copyToBoard(_ board:[[Square]], pieces: [[Piece?]]){
        for i in 0 ..< 8{
            for j in 0 ..< 8{
                board[i][j].piece = pieces[i][j]
            }
        }
    }
    
    fileprivate func checkRange(_ start: (Int, Int), dest: (Int, Int)) -> Bool{
        if (start.0<0 || start.0 > 7){
            return false;
        }
        if (start.1<0 || start.1 > 7){
            return false;
        }
        if (dest.0<0 || dest.1 > 7){
            return false;
        }
        if (dest.0<0 || dest.1 > 7){
            return false;
        }
        return true;
    }
}

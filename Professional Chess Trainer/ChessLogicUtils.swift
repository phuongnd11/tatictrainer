//
//  ChessLogicUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/15/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class ChessLogicUtils {
    
    let squareY: String = "abcdefgh"
    let squareX: String = "87654321"
    
    public func toStandardMove(start: (Int, Int), dest: (Int, Int), board: [[Square]], moveStatus: MoveResult,flipBoard: Bool) -> String {
        if (board[start.0][start.1].piece is Pawn) {
            
        }
        
        return ""
    }
    
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
    public func isValidMove(start: (Int, Int), dest: (Int, Int), board: [[Square]], boardStatus: BoardStatus) -> (MoveResult) {
        var returnCode = MoveResult.okMove
        if (!checkRange(start, dest: dest)){
            return MoveResult.invalidRange;
        }
        if (start.0 == dest.0 && start.1 == dest.1){
            return MoveResult.sameSquare
        }
        
        let currentSquare = board[start.0][start.1]
        let destSquare = board[dest.0][dest.1]
        
        //check current square
        if(currentSquare.isEmpty()) {
            return MoveResult.emptySquare
        }
        
        let currentPiece = currentSquare.piece!;
        if (boardStatus.isWhiteMove && currentPiece.color == PieceColor.Black){
            return MoveResult.notInTurn;
        }
        if (!boardStatus.isWhiteMove && currentPiece.color == PieceColor.White){
            return MoveResult.notInTurn;
        }
        var result = false;
        var isEnpass = false
        
        if (!destSquare.isEmpty()){
            //x
            let destPiece = destSquare.piece!;
            
            if (destPiece.color == currentPiece.color){
                return MoveResult.sameColor
            }
        }
        
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
            TryMove(start, dest:dest, board:board, isWhiteMove: boardStatus.isWhiteMove , moveResult: returnCode, isTest: true)
            result = !isCheckMate(boardStatus.isWhiteMove, board: board)
            copyToBoard(board, pieces: pieces)
            if (!result){
                returnCode = MoveResult.checkMatesInvalid
            }
        }
        return returnCode
    }
    private func applyPiece(square:Square, piece:Piece?, test:Bool){
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
    public func CheckResult(board: [[Square]], boardStatus: BoardStatus) -> GameResult{
        var colorToCheck = PieceColor.Black
        if (boardStatus.isWhiteMove){
            colorToCheck = PieceColor.White
        }
        
        var kingRow = -1
        var kingCol = -1
        // find king
        for var i = 0; i<=7; ++i{
            for var j = 0;j<=7;++j{
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
            if (colorToCheck == PieceColor.White){
                return GameResult.whiteWin
            }
            if (colorToCheck == PieceColor.Black){
                return GameResult.blackWin
            }
        }
        for var i = 0; i<=7; ++i{
            for var j = 0;j<=7;++j{
                if (!board[i][j].isEmpty() && board[i][j].piece.color == colorToCheck){
                    for var mRow = 0; mRow <= 7; ++mRow{
                        for var mCol = 0; mCol <= 7; ++mCol{
                            if (isValidMove((i,j), dest: (mRow,mCol), board: board, boardStatus: boardStatus).rawValue >= 0 ){
                                return GameResult.goingOn
                            }
                        }
                    }
                }
            }
        }
        
        if (isCheckMate(boardStatus.isWhiteMove, board: board)){
            return GameResult.blackWin
        }
        else{
            return GameResult.draw
        }
    }
    
    public func TryMove(start: (Int, Int), dest: (Int, Int), board:[[Square]], isWhiteMove: Bool, moveResult: MoveResult, isTest:Bool){
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
            
            applyPiece(board[row][dest.1], piece: king, test: isTest)
            applyPiece(board[row][rookColDest], piece: rook, test: isTest)
            
            applyPiece(board[row][start.1], piece: nil, test: isTest)
            //board[start.0][start.1].piece = nil
            applyPiece(board[row][rookCol], piece: nil, test: isTest)
            //board[dest.0][dest.1].piece = nil
            return
        }
        if (moveResult == MoveResult.enpass){
            if (isWhiteMove){//quan bi an la quan den
                applyPiece(board[dest.0+1][dest.1], piece: nil, test: isTest)
                //board[dest.0-1][dest.1].piece = nil
            }
            else {
                applyPiece(board[dest.0-1][dest.1], piece: nil, test: isTest)
                //board[dest.0+1][dest.1].piece = nil
            }
        }
        applyPiece(board[dest.0][dest.1], piece: board[start.0][start.1].piece, test: isTest)
        //board[dest.0][dest.1].piece = board[start.0][start.1].piece

        applyPiece(board[start.0][start.1], piece: nil, test: isTest)
        //board[start.0][start.1].piece = nil
    }
    private func checkCastling(start: (Int, Int), dest: (Int, Int), board: [[Square]], isK: Bool, isQ: Bool, isk: Bool, isq: Bool) ->Bool{
        let currentPiece = board[start.0][start.1].piece!;
        
        if (currentPiece is King && start.0 == dest.0 && abs(start.1-dest.1) == 2){
            if (currentPiece.color == PieceColor.White){
                if (isK && dest.0 == 7 && dest.1 == 6){
                    for var i = 0;i<2;++i{
                        if (!board[7][i+5].isEmpty()){
                            return false
                        }
                    }
                }
                else if (isQ && dest.0 == 7 && dest.1 == 2){
                    for var i = 0;i<3;++i{
                        if (!board[7][i+1].isEmpty()){
                            return false
                        }
                    }
                }
                else{
                    return false
                }
            }
            
            if (currentPiece.color == PieceColor.Black){
                if (isk && dest.0 == 0 && dest.1 == 6){
                    for var i = 0;i<2;++i{
                        if (!board[0][i+5].isEmpty()){
                            return false
                        }
                    }
                }
                else if (isq && dest.0 == 0 && dest.1 == 2){
                    for var i = 0;i<3;++i{
                        if (!board[0][i+1].isEmpty()){
                            return false
                        }
                    }
                }
                else{
                    return false
                }
            }
            return !isCheckMate(currentPiece.color == PieceColor.White, board: board)
        }
        return false;
    }
    
    public func isCheckMate(isCheckWhite:Bool,board: [[Square]]) -> Bool{
        // find king location
        var kingRow = -1
        var kingCol = -1
        
        var kingColor = PieceColor.Black
        var checkColor = PieceColor.White
        if (isCheckWhite){
            kingColor = PieceColor.White
            checkColor = PieceColor.Black
        }
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                if (board[i][j].piece is King){
                    if (board[i][j].piece.color == kingColor){
                        kingRow = i;
                        kingCol = j;
                    }
                }
            }
        }
        
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                if (!board[i][j].isEmpty() && board[i][j].piece.color == checkColor){
                    if (board[i][j].piece.isValidMove((i,j), dest: (kingRow,kingCol), board: board)){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    private func convertToPiece(board: [[Square]]) -> [[Piece?]]{
        var pieces = [[Piece?]](count: 8, repeatedValue: Array(count: 8, repeatedValue: nil))
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                if (!board[i][j].isEmpty()){
                    pieces[i][j] = board[i][j].piece
                }
            }
        }
        return pieces
    }
    private func copyToBoard(board:[[Square]], pieces: [[Piece?]]){
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                board[i][j].piece = pieces[i][j]
            }
        }
    }
    
    private func checkRange(start: (Int, Int), dest: (Int, Int)) -> Bool{
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
    
    private func isBlackPiece(piece: Character) -> Bool {
        return true
        //if (piece == "r" || piece == "r" ||)
    }
    
    private func positionToSquare(position: (Int, Int)) -> String {
        return String(squareY[squareY.startIndex.advancedBy(position.1)])
            + String(squareX[squareX.startIndex.advancedBy(position.0)])
    }
}

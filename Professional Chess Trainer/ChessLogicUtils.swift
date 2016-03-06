//
//  ChessLogicUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/15/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class ChessLogicUtils {
    
    let squareX: String = "abcdefgh"
    let squareY: String = "87654321"
    
    public func toStandardMove(start: (Int, Int), dest: (Int, Int), board: [[Square]]) -> String {
        if (board[start.0][start.1].piece is Pawn) {
            if (board[dest.0][dest.1].isEmpty()) {
                //need to check en passsant
                return positionToSquare(dest)
            }
            else {
                
            }
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
        var isCastling = false
        // check nhap thanh
        if (!destSquare.isEmpty()){
            let destPiece = destSquare.piece!;
            
            if (destPiece.color == currentPiece.color){
                // neu khong phai nhap thanh thi la false
                result = checkCastling(start,dest:dest,board:board,isK: boardStatus.isKingWhiteCastling,isQ:boardStatus.isQueenWhiteCastling,isk:boardStatus.isKingBlackCastling, isq:boardStatus.isQueenBlackCastling);
                
                isCastling = result;
                if (isCastling){
                    returnCode = MoveResult.castling
                }
                else{
                    returnCode = MoveResult.sameColor
                }
            }
        }
        if (returnCode.rawValue == 0 && ((currentPiece is Pawn) && (dest.0 == boardStatus.enPassant.0 && dest.1 == boardStatus.enPassant.1))){
            // check tot qua duong
            result = Pawn.isPawnCanEat(start,dest: dest,board: board)
            isEnpass = result
            if (isEnpass){
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
    public func updateStatus(start:(Int,Int),dest:(Int,Int),movedPiece:Piece, moveResult: MoveResult, boardStatus:BoardStatus){
        if (moveResult.rawValue<0){
            return //invalid move
        }
        if (moveResult == MoveResult.castling || movedPiece is King){
            if (boardStatus.isWhiteMove){
            boardStatus.isKingWhiteCastling = false
            boardStatus.isQueenWhiteCastling = false
            }
            else{
                boardStatus.isKingBlackCastling = false
                boardStatus.isQueenBlackCastling = false
            }
        }
        
        if (movedPiece is Rook){
            if (start.0 == 0 && start.1 == 0){
                boardStatus.isQueenBlackCastling = false
            }
            if (start.0 == 0 && start.1 == 7){
                boardStatus.isKingBlackCastling = false
            }
            if (start.0 == 7 && start.1 == 0){
                boardStatus.isQueenWhiteCastling = false
            }
            if (start.0 == 7 && start.1 == 7){
                boardStatus.isKingWhiteCastling = false
            }
        }
        if (movedPiece is Pawn && (abs(dest.0-start.0) == 2)){
            boardStatus.enPassant.1 = start.1
            boardStatus.enPassant.0 = (dest.0+start.0)/2
        }
        else{
            boardStatus.enPassant.1 = -1
            boardStatus.enPassant.0 = -1
        }
        boardStatus.isWhiteMove = !boardStatus.isWhiteMove
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
    public func TryMove(start: (Int, Int), dest: (Int, Int), board:[[Square]], isWhiteMove: Bool, moveResult: MoveResult, isTest:Bool){
        if (moveResult.rawValue < 0){
            return
        }
        if (moveResult == MoveResult.castling){
            var rookRow = start.0
            var rookCol = start.1
            var king = board[dest.0][dest.1].piece
            if (board[dest.0][dest.1].piece is Rook){
                rookRow = dest.0
                rookCol = dest.1
                king = board[start.0][start.1].piece
            }
            if (!(king is King)){
                return
            }
            let rook = board[rookRow][rookCol].piece
            
            if (rookRow == 0 && rookCol == 0){
                applyPiece(board[0][2], piece: king, test: isTest)
                //board[0][2].piece = king
                applyPiece(board[0][3], piece: rook, test: isTest)
                //board[0][3].piece = rook
            }
            if (rookRow == 0 && rookCol == 7){
                applyPiece(board[0][6], piece: king, test: isTest)
                //board[0][6].piece = king
                applyPiece(board[0][5], piece: rook, test: isTest)
                //board[0][5].piece = rook
            }
            
            if (rookRow == 7 && rookCol == 0){
                applyPiece(board[7][2], piece: king, test: isTest)
                //board[7][2].piece = king
                applyPiece(board[7][3], piece: rook, test: isTest)
                //board[7][3].piece = rook
            }
            if (rookRow == 7 && rookCol == 7){
                applyPiece(board[7][6], piece: king, test: isTest)
                //board[7][6].piece = king
                applyPiece(board[7][5], piece: rook, test: isTest)
                //board[7][5].piece = rook
            }
            applyPiece(board[start.0][start.1], piece: nil, test: isTest)
            //board[start.0][start.1].piece = nil
            applyPiece(board[dest.0][dest.1], piece: nil, test: isTest)
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
        let destPiece = board[dest.0][dest.1].piece!;
        
        if((currentPiece is Rook && destPiece is King) || (currentPiece is King && destPiece is Rook)){
            var rookLocation = (dest.0,dest.1)
            if (currentPiece is Rook){
                rookLocation = (start.0, start.1)
            }
            
            if (destPiece.color == PieceColor.White){
                if (isK && rookLocation.0 == 7 && rookLocation.1 == 7){
                    for var i = 0;i<2;++i{
                        if (!board[7][i+5].isEmpty()){
                            return false
                        }
                    }
                    return true;
                }
                if (isQ && rookLocation.0 == 7 && rookLocation.1 == 0){
                    for var i = 0;i<3;++i{
                        if (!board[7][i+1].isEmpty()){
                            return false
                        }
                    }
                    return true
                }
            }
            
            if (destPiece.color == PieceColor.Black){
                if (isk && rookLocation.0 == 0 && rookLocation.1 == 7){
                    for var i = 0;i<2;++i{
                        if (!board[0][i+5].isEmpty()){
                            return false
                        }
                    }
                    return true;
                }
                if (isq && rookLocation.0 == 0 && rookLocation.1 == 0){
                    for var i = 0;i<3;++i{
                        if (!board[0][i+1].isEmpty()){
                            return false
                        }
                    }
                    return true
                }
            }
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
    private func tryMove(board: [[Square]]) -> [[Piece]]{
        var pieces = [[Piece]]()
        for var i = 0; i<=7;++i{
            for var j = 0; j<=7;++j{
                pieces[i][j] = board[i][j].piece
            }
        }
        return pieces
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
        return String(squareX[squareX.startIndex.advancedBy(position.0)])
            + String(squareY[squareY.startIndex.advancedBy(position.1)])
    }
}

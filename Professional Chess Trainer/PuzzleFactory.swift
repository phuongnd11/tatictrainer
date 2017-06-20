//
//  PuzzleFactory.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/16/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
import GRDB


open class PuzzleFactory{
    
    static let puzzleFactory: PuzzleFactory = PuzzleFactory()
    

    open func getNextPuzzle(_ elo: Int) -> Puzzle {
        
        var query = "SELECT * FROM ChessData WHERE Played=0 AND ELO > " + String(elo)
        
        query = query.appending(" ORDER BY ELO LIMIT 1")
        NSLog(query)
        let _sourcePath = Bundle.main.path(forResource: "chessData", ofType: "db")
        var nextPuzzle = Puzzle(FEN: "r2nr2k/1bp1bpp1/p7/1p1pP3/3P2q1/2P2NP1/P1B2PK1/R1BQR3 w - - 0 1", computerMove: "", solution: " Rh1+ Kg8 Bh7+ Kf8 Bf5", idea: "Nakamura - Magnus Carslen 2015", elo: 1532, id: 1)
        var success = 0
        NSLog("In Factoryyyyyyyyy")
        do{
            let _dbQueue = try DatabaseQueue(path: _sourcePath!)
            
            try _dbQueue.inDatabase { db in
                let rows = try Row.fetchCursor(db, query)
                while let row = try rows.next() {
                    let ID: Int = row.value(named: "ID")
                    let FEN: String = row.value(named: "FEN")
                    var COMPUTER: String? = row.value(named: "Computer")
                    let solution: String = row.value(named: "Solution")
                    var idea: String? = row.value(named: "Idea")
                    let elo: Int = row.value(named: "ELO")
                    
                    if (COMPUTER == nil){
                        COMPUTER = ""
                    }
                    if (idea == nil){
                        idea = "No comments for this tatic"
                    }
                    NSLog(String(ID))
                    NSLog(FEN)
                    NSLog(COMPUTER!)
                    NSLog(solution)
                    NSLog(String(elo))
                    
                    nextPuzzle = Puzzle(FEN: FEN, computerMove: COMPUTER!, solution: solution, idea: idea!, elo: elo, id: ID)
                    success = ID
                    
                    break;
                }
            }
            if(success > 0){
                try _dbQueue.inDatabase { db in
                
                    try db.execute(
                        "UPDATE ChessData SET Played=1 WHERE ID=" +
                            String(success))
                }
            }
        }
        catch{
            NSLog("Connect error")
        }

        return nextPuzzle
    }
    
}

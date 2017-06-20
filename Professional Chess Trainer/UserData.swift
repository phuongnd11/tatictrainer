//
//  UserData.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 4/9/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

struct defaultKeys {
    static let userScoreKey = "userScore"
    static let username = "username"
    static let numOfGames = "numOfGames"
    static let puzzle = "puzzle"
    static let puzzlePlayed = "puzzlePlayed"
    static let board = "board"
    static let piece = "piece"
}

open class UserData {
    
    static func storeScore(_ score: Int){
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: defaultKeys.userScoreKey)
        defaults.synchronize()
    }
    
    static func getScore() -> Int{
        let defaults = UserDefaults.standard
        let score = defaults.integer(forKey: defaultKeys.userScoreKey)
        if score == 0 {
            return 1200
        }
        else {
            return score
        }
    }
    
    static func increaseNumOfGames(){
        let defaults = UserDefaults.standard
        var numOfGames = defaults.integer(forKey: defaultKeys.numOfGames)
        numOfGames = numOfGames+1;
        defaults.set(numOfGames, forKey: defaultKeys.numOfGames)
        defaults.synchronize()
    }
    
    static func getNumOfGames() -> Int{
        let defaults = UserDefaults.standard
        let numOfGames = defaults.integer(forKey: defaultKeys.numOfGames)
        return numOfGames
    }
    
    static func storeUsername(_ username: String){
        let defaults = UserDefaults.standard
        defaults.setValue(username, forKey: defaultKeys.username)
        defaults.synchronize()
    }
    
    static func getUsername() -> String{
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: defaultKeys.username) {
            return username
        }
        return "Guest"
    }
    
    static func saveLastPlayedPuzzle(_ id: Int) {
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: defaultKeys.puzzle)
        defaults.synchronize()
    }
    
    static func getLastPlayedPuzzle() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: defaultKeys.puzzle)
    }
    
    static func savePuzzlePlayed(_ id: Int) {
        let defaults = UserDefaults.standard
        
        var gamesPlayed = defaults.array(forKey: defaultKeys.puzzlePlayed)
        
        if (gamesPlayed == nil){
            gamesPlayed = [-1]
        }
        
        gamesPlayed?.append(id)
        
        defaults.set(gamesPlayed, forKey: defaultKeys.puzzlePlayed)
        defaults.synchronize()
    }
    
    static func getPlayedPuzzles() -> [Int]?{
        let defaults = UserDefaults.standard
        let gamesPlayed = defaults.array(forKey: defaultKeys.puzzlePlayed) as? [Int]
        
        if (gamesPlayed == nil){
            return [-1]
        }
        return gamesPlayed
    }
    
    static func resetPlayedGames() {
        let defaults = UserDefaults.standard
        
        let gamesPlayed = [Int]()
        
        defaults.set(gamesPlayed, forKey: defaultKeys.puzzlePlayed)
        defaults.synchronize()
    }

    
    static func getPiece() -> String {
        let defaults = UserDefaults.standard
        let piece = defaults.string(forKey: defaultKeys.piece)
        if (piece != nil && !piece!.isEmpty){
            return piece!
        }
        return "default"
    }
    
    static func savePiece(_ piece: String){
        let defaults = UserDefaults.standard
        defaults.setValue(piece, forKey: defaultKeys.piece)
        defaults.synchronize()
    }
    
    
    static func getBoard() -> String {
        let defaults = UserDefaults.standard
        let board = defaults.string(forKey: defaultKeys.board)
        if (board != nil && !board!.isEmpty){
            return board!
        }
        return "default"
    }
    
    static func saveBoard(_ board: String){
        let defaults = UserDefaults.standard
        defaults.setValue(board, forKey: defaultKeys.board)
        defaults.synchronize()
    }

}

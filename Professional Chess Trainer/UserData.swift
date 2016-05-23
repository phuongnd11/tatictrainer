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
    static let theme = "theme"
}

public class UserData {
    
    static func storeScore(score: Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(score, forKey: defaultKeys.userScoreKey)
        defaults.synchronize()
    }
    
    static func getScore() -> Int{
        let defaults = NSUserDefaults.standardUserDefaults()
        let score = defaults.integerForKey(defaultKeys.userScoreKey)
        if score == 0 {
            return 1200
        }
        else {
            return score
        }
    }
    
    static func increaseNumOfGames(){
        let defaults = NSUserDefaults.standardUserDefaults()
        var numOfGames = defaults.integerForKey(defaultKeys.numOfGames)
        defaults.setInteger(numOfGames++, forKey: defaultKeys.numOfGames)
        defaults.synchronize()
    }
    
    static func getNumOfGames() -> Int{
        let defaults = NSUserDefaults.standardUserDefaults()
        let numOfGames = defaults.integerForKey(defaultKeys.numOfGames)
        return numOfGames
    }
    
    static func storeUsername(username: String){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(username, forKey: defaultKeys.username)
        defaults.synchronize()
    }
    
    static func getUsername() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.stringForKey(defaultKeys.username) {
            return username
        }
        return "Guest"
    }
    
    static func saveLastPlayedPuzzle(id: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(id, forKey: defaultKeys.puzzle)
        defaults.synchronize()
    }
    
    static func getLastPlayedPuzzle() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaultKeys.puzzle)
    }
    
    static func savePuzzlePlayed(id: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var gamesPlayed = defaults.arrayForKey(defaultKeys.puzzlePlayed)
        
        if (gamesPlayed == nil){
            gamesPlayed = [-1]
        }
        
        gamesPlayed?.append(id)
        
        defaults.setObject(gamesPlayed, forKey: defaultKeys.puzzlePlayed)
        defaults.synchronize()
    }
    
    static func getPlayedPuzzles() -> [Int]?{
        let defaults = NSUserDefaults.standardUserDefaults()
        let gamesPlayed = defaults.arrayForKey(defaultKeys.puzzlePlayed) as? [Int]
        
        if (gamesPlayed == nil){
            return [-1]
        }
        return gamesPlayed
    }
    
    static func resetPlayedGames() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let gamesPlayed = [Int]()
        
        defaults.setObject(gamesPlayed, forKey: defaultKeys.puzzlePlayed)
        defaults.synchronize()
    }

    
    static func getTheme() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let theme = defaults.stringForKey(defaultKeys.theme) {
            return theme
        }
        return "default"
    }
    
    static func saveTheme(theme: String){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(theme, forKey: defaultKeys.theme)
        defaults.synchronize()
    }
}
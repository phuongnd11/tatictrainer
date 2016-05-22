//
//  PuzzleFactory.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/16/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class PuzzleFactory{
    
    static let puzzleFactory: PuzzleFactory = PuzzleFactory()
    
    private var taticArray: [Puzzle]
    private init(){
        /*let puzzle1 = Puzzle(FEN: "r2nr2k/1bp1bpp1/p7/1p1pP3/3P2q1/2P2NP1/P1B2PK1/R1BQR3 w - - 0 1", computerMove: "", solution: "Rh1+ Kg8 Bh7+ Kf8 Bf5", idea: "Nakamura - Magnus Carslen 2015", elo: 1532, id: 1)
        
        let puzzle2 = Puzzle(FEN: "rn2k1r1/1R1b1p1p/3pp3/p6R/4P3/3NBP2/2P1B1P1/b4K2 w q - 0 1", computerMove: "", solution: "Rxa5", idea: "Nakamura - Magnus Carslen 2015", elo: 1480, id: 2)
        
        let puzzle3 = Puzzle(FEN: "4r1k1/Q4ppp/1r1q4/N1pPpb2/1nP5/R5P1/P4PBP/2R3K1 b - - 0 1", computerMove: "", solution: "...Ra6 Qb7 Rb8", idea: "Nakamura - Magnus Carslen 2015", elo: 1488, id: 3)
        
        let puzzle4 = Puzzle(FEN: "r1bq1rk1/ppppnp1p/2n3p1/3N2B1/2PQ4/8/PP2PPPP/R3KB1R w KQ - 1 0", computerMove:  "", solution: "Nf6+ Kh8 Ng4+", idea: "Nakamura - Magnus Carslen 2015", elo: 1542, id: 4)
        */
        //taticArray.append(puzzle1)
        //taticArray.append(puzzle2)
        //taticArray.append(puzzle3)
        //taticArray.append(puzzle4)
        taticArray = CSVUtils().parseCSVtoPuzzle("newtatics")!
    }
    
    public func getNextPuzzle(elo: Int) -> Puzzle {
        let puzzle1 = Puzzle(FEN: "r2nr2k/1bp1bpp1/p7/1p1pP3/3P2q1/2P2NP1/P1B2PK1/R1BQR3 w - - 0 1", computerMove: "", solution: " Rh1+ Kg8 Bh7+ Kf8 Bf5", idea: "Nakamura - Magnus Carslen 2015", elo: 1532, id: 1)
        /*
        let puzzle2 = Puzzle(FEN: "rn2k1r1/1R1b1p1p/3pp3/p6R/4P3/3NBP2/2P1B1P1/b4K2 w q - 0 1", computerMove: "", solution: "Rxa5", gameTitle: "Nakamura - Magnus Carslen 2015", elo: 1480, id: 2)
        
        let puzzle3 = Puzzle(FEN: "4r1k1/Q4ppp/1r1q4/N1pPpb2/1nP5/R5P1/P4PBP/2R3K1 b - - 0 1", computerMove: "", solution: "...Ra6 Qb7 Rb8", gameTitle: "Nakamura - Magnus Carslen 2015", elo: 1488, id: 3)
        
        let puzzle4 = Puzzle(FEN: "r1bq1rk1/ppppnp1p/2n3p1/3N2B1/2PQ4/8/PP2PPPP/R3KB1R w KQ - 1 0", computerMove:  "", solution: "Nf6+ Kh8 Ng4+", gameTitle: "Nakamura - Magnus Carslen 2015", elo: 1542, id: 4)
        
        let puzzleMock = Puzzle(FEN: "r1bq1rk1/ppppnp1p/2n3p1/3N2B1/2PQ4/8/PP2PPPP/R3KB1R w KQ - 1 0", computerMove: "", solution: "Nf6+ Kh8 Ng4+", gameTitle: "", elo: elo, id: 99999999)
        
        var puzzleArray = Array<Puzzle>()//[puzzle1, puzzle2, puzzle3, puzzle4]
        
         let puzzleMock = Puzzle(FEN: "r1bq1rk1/ppppnp1p/2n3p1/3N2B1/2PQ4/8/PP2PPPP/R3KB1R w KQ - 1 0", computerMove: "", solution: "Nf6+ Kh8 Ng4+", gameTitle: "", elo: elo, id: 99999999)

        puzzleArray.append(puzzle1)
        puzzleArray.append(puzzle2)
        puzzleArray.append(puzzle3)
        puzzleArray.append(puzzle4)
        */
        let puzzleMock = Puzzle(FEN: "r1bq1rk1/ppppnp1p/2n3p1/3N2B1/2PQ4/8/PP2PPPP/R3KB1R w KQ - 1 0", computerMove: "", solution: "Nf6+ Kh8 Ng4+", idea: "", elo: elo, id: 99999999)
        
        taticArray.append(puzzleMock)
        
        taticArray.sortInPlace { (puzzleX, puzzleY) -> Bool in
            puzzleX.elo < puzzleY.elo
        }
        var playedGames = UserData.getPlayedPuzzles()
        //let searchIndex = binarySearch(puzzleArray, searchItem: puzzleMock)
        //let searchIndex = puzzleArray.indexOf(puzzleMock)
        
        for (index, puzzle) in taticArray.enumerate() {
            if (puzzle > puzzleMock && puzzle != puzzleMock) {
                if(!playedGames!.contains(puzzle.id)) {
                    NSLog("Next tatic for ELO \(puzzle.id)")
                    return puzzle
                }
            }
        }
        var mockIndex = taticArray.indexOf(puzzleMock)
        if (mockIndex != nil) {
            taticArray.removeAtIndex(taticArray.indexOf(puzzleMock)!)
        }
        if (taticArray.count == 0) {
            NSLog("No more puzzle available")
            return puzzle1
        }
        let diceRoll = Int(arc4random_uniform(UInt32(taticArray.count)))
        NSLog("Randonly select \(diceRoll)")
        return taticArray.removeAtIndex(diceRoll)
    }
    
    public func getPuzzleById(id: Int) -> Puzzle?{
    
        for puzz in taticArray {
            if (puzz.id == id) {
                return puzz
            }
        }
        
        return nil
    }
    
    
    func binarySearch<T:Comparable>(inputArr:Array<T>, searchItem: T)->Int{
        var lowerIndex = 0;
        var upperIndex = inputArr.count - 1
        
        while (true) {
            var currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex] == searchItem) {
                return currentIndex
            } else if (lowerIndex > upperIndex) {
                return -1
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }

}
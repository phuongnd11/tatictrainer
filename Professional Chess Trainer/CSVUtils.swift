//
//  CSVUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 4/28/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class CSVUtils{
    
    
    func parseCSVtoPuzzle(name: String) -> [Puzzle]?{
        
        var puzzles = [Puzzle]()
        if let contentOfURL = NSBundle.mainBundle().URLForResource(name, withExtension: "csv") {
            do {
                let csv = try CSV(string: String(contentsOfURL: contentOfURL))
                csv.enumerateAsArray{array in
                    
                    //if array.first != nil && array[1] != nil && //array[4] != nil && array[5] != nil {
                        //puzzles?.append(Puzzle(FEN: array[1]!, computerMove: array[2], solution: ))
                        puzzles.append(Puzzle(FEN: array[1], computerMove: array[2], solution: array[4], idea: array[3], elo: Int(array[5])!, id: Int(array[0])!))
                   // }
                    
                }
            } catch {
                print(error)
            }
            
            return puzzles
        }
        return nil
    }
    
}
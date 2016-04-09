//
//  ELOUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 4/9/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class ELOUtils {
    
    static func calculateELOChange(rating1: Int, rating2: Int, winLoseDraw: Int, numOfGamesPlayed: Int) -> Int{
        var K = 40
        if numOfGamesPlayed > 30 {
            K = 20
        }
        if rating1 > 2400 {
            K = 15
        }
        
        var r1 = pow(10.0, Double(rating1)/400)
        var r2 = pow(10.0, Double(rating2)/400)
        
        var W = Double(1)
        if (winLoseDraw == 0){
            W = 0.5
        } else if winLoseDraw == -1 {
            W = 0
        }
        var change = Int((W - r1/(r1+r2)) * Double(K))
        
        return change
    }
    
}
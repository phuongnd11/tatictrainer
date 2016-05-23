//
//  ELOUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 4/9/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class ELOUtils {
    
    static func calculateELOChange(rating1: Int, rating2: Int, winLoseDraw: Int, numOfGamesPlayed: Int, moveNum: (Int, Int)) -> Int{
        var K = 40
        if numOfGamesPlayed > 30 {
            K = 20
        }
        if rating1 > 2400 {
            K = 15
        }
        
        let r1 = pow(10.0, Double(rating1)/400)
        let r2 = pow(10.0, Double(rating2)/400)
        var change = 0
        change = Int((Double(winLoseDraw) - r1/(r1+r2)) * Double(K))
        let correctMoveNum = moveNum.0 - 1
        if(moveNum.0 == 1 || moveNum.0 >= moveNum.1) {
            return change
        }
        else {
            if (correctMoveNum * 2 >= moveNum.1 && winLoseDraw == 0){
                change = change * (-1) * correctMoveNum/moveNum.1
            }
            else if (correctMoveNum * 2 < moveNum.1 && winLoseDraw == 0){
                change = change * correctMoveNum/moveNum.1
            }
        }
        return change
    }
    
}
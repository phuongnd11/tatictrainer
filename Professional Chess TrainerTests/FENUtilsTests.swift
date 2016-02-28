//
//  FENUtilsTests.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 2/12/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import XCTest

class FENUtilsTests: XCTestCase {



    func testExample() {
        var board = FENUtils().readBoardFromFEN("rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2")
        for var x = 7; x >= 0; x-- {
            print("")
            for y in 0...7 {
                print("\(board[x][y]) ", terminator:"")
            }
        }
        print("")
//        for x in board {
//            for y in x {
//                print("\(y) ", terminator:"")
//            }
//            print("")
//        }

    }


}

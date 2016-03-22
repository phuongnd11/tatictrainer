//
//  BoardHistory.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/22/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation

public class BoardHistory {
    
    var start: Square!
    var dest: Square!
    var status: BoardStatus!

    init(start: Square, dest: Square, status: BoardStatus) {
        self.start = start
        self.dest = dest
        self.status = status
    }
}
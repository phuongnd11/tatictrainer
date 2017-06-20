//
//  UIUtils.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 5/19/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
import UIKit

open class UIUtils {
    
    open static func calculatePieceFrame(_ frame: CGRect) -> CGRect{
        
        let varX = frame.origin.x + frame.size.width/12
        let varY = frame.origin.y + frame.size.width/12
        let pieceSize = frame.size.width - frame.size.width*2/12
        return CGRect(x: varX, y: varY, width: pieceSize , height: pieceSize)
    }
    
}

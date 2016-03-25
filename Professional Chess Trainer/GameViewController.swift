//
//  GameViewController.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/14/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, PrintEventDelegate, UpdateStatusDelegate, NextPuzzleDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eloLabel: UILabel!
    
    @IBOutlet weak var theBoardView: BoardView!
    
    @IBAction func nextButton(sender: AnyObject) {
        if theBoardView != nil {
            eloLabel.text = ""
            theBoardView.reload(PuzzleFactory().getNextPuzzle())
            theBoardView.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.hidden = true
        theBoardView.moveFinishDelegate = self
        theBoardView.updateStatusDelegate = self
        theBoardView.nextPuzzleDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveFinish(moveResult: MoveResult){
        eloLabel.text = String(moveResult)
    }
    
    func updateUserStatus(correctMove: Bool) {
        if correctMove {
            if eloLabel.text!.hasPrefix("+10") || eloLabel.text!.hasPrefix("-10") {
                eloLabel.text = "+10 ELO.Correct Move! " + String(eloLabel.text!.substringFromIndex(eloLabel.text!.startIndex.advancedBy(22)))
            } else {
                eloLabel.text = "+10 ELO.Correct Move! " + String(eloLabel.text!)
            }
        }
        else {
            if eloLabel.text!.hasPrefix("+10") || eloLabel.text!.hasPrefix("-10") {
                eloLabel.text = "-10 ELO.  Wrong Move! " + String(eloLabel.text!.substringFromIndex(eloLabel.text!.startIndex.advancedBy(22)))
            } else {
                eloLabel.text = "-10 ELO.  Wrong Move! " + String(eloLabel.text!)
            }
        }
    }

    func enableNext() {
        eloLabel.text = "You won"
        nextButton.hidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

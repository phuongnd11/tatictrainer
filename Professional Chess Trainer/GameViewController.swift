//
//  GameViewController.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/14/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController, PrintEventDelegate, UpdateStatusDelegate, NextPuzzleDelegate {
    
    @IBOutlet weak var ideaButton: UIButton!
    @IBOutlet weak var previousMove: UIButton!
    @IBOutlet weak var nextMove: UIButton!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eloLabel: UILabel!
    
    @IBOutlet weak var theBoardView: BoardView!
    
    @IBAction func nextButton(sender: AnyObject) {
        if theBoardView != nil {
            let puzzle = PuzzleFactory().getNextPuzzle()
            theBoardView.reload(puzzle)
            theBoardView.setNeedsDisplay()
            var userPlay = "White"
            if puzzle.flipBoard {
                userPlay = "Black"
            }
//            if GKLocalPlayer.localPlayer().authenticated {
//                gameTitle.text = GKLocalPlayer.localPlayer().alias! + ", you play " + userPlay
//            }
//            else {
                gameTitle.text = "You play " + userPlay
//            }
        }
        UserData.increaseNumOfGames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.hidden = true
        ideaButton.hidden = true
        nextMove.hidden = true
        previousMove.hidden = true
        theBoardView.moveFinishDelegate = self
        theBoardView.updateStatusDelegate = self
        theBoardView.nextPuzzleDelegate = self
        eloLabel.text = String(UserData.getScore())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveFinish(moveResult: MoveResult){
        eloLabel.text = String(moveResult)
    }
    
    func updateUserStatus(correctMove: Bool) {
        var score = UserData.getScore()
        if correctMove {
            score += 10
            eloLabel.text = String(score) + " (+10)"
        }
        else {
            score -= 10
            eloLabel.text = String(score) + " (-10)"
        }
        UserData.storeScore(score)
    }

    func enableNext() {
        nextButton.backgroundColor = UIColor.orangeColor()
        nextButton.hidden = false
        ideaButton.backgroundColor = UIColor.lightGrayColor()
        ideaButton.hidden = false
        nextMove.backgroundColor = UIColor.lightGrayColor()
        nextMove.hidden = false
        previousMove.backgroundColor = UIColor.lightGrayColor()
        previousMove.hidden = false
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

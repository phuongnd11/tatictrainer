//
//  GameViewController.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/14/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, PrintEventDelegate {
    
    @IBOutlet weak var eloLabel: UILabel!
    
    @IBOutlet weak var theBoardView: BoardView!
    
    @IBAction func nextButton(sender: AnyObject) {
        if theBoardView != nil {
            theBoardView.reload(PuzzleFactory().getNextPuzzle())
            theBoardView.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theBoardView.moveFinishDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveFinish(moveResult: MoveResult){
        eloLabel.text = String(moveResult)
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

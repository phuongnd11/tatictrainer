//
//  GameViewController.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/14/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController, PrintEventDelegate, UpdateStatusDelegate {
    
    @IBOutlet weak var ideaButton: UIButton!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eloLabel: UILabel!
    
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var solutionButton: UIButton!
    
    @IBOutlet weak var gAdBannerView: GADBannerView!
    
    @IBOutlet weak var theBoardView: BoardView!
    
    var popViewController: PopUpViewController!
    
    var lockELO = false
    var titleGame = ""
    
    @IBAction func ideaClicked(sender: AnyObject) {
        /*
        let bundle = NSBundle(forClass: PopUpViewController.self)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPad", bundle: bundle)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
        } else
        {
            /**
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6Plus", bundle: bundle)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
                } else {
                    self.popViewController = PopUpViewController(nibName: "PopUpViewController_iPhone6", bundle: bundle)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
                }
            } else {
 */
                self.popViewController = PopUpViewController(nibName: "PopUpViewController", bundle: bundle)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
           // }
        }
 */
    }
    
    @IBAction func solutionClicked(sender: AnyObject) {
        if theBoardView != nil {
            theBoardView.moveBack()
            theBoardView.showSolution()
        }
        retryButton.hidden = true
        
        gameTitle.text = "Solution"
    }
    
    @IBAction func retryClicked(sender: AnyObject) {
        
        if theBoardView != nil {
            theBoardView.retry()
        }
        //gameTitle.textColor = UIColor.whiteColor()
        gameTitle.text = "Analysis mode"
        
        hideButtons()
        //redisplayELO()
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        if theBoardView != nil {
            let puzzle = PuzzleFactory.puzzleFactory.getNextPuzzle(UserData.getScore())
            theBoardView.reload(puzzle)
            UserData.saveLastPlayedPuzzle(puzzle.id)
            UserData.savePuzzlePlayed(puzzle.id)
            theBoardView.setNeedsDisplay()
            var userPlay = "White"
            if puzzle.flipBoard {
                userPlay = "Black"
            }
//            if GKLocalPlayer.localPlayer().authenticated {
//                gameTitle.text = GKLocalPlayer.localPlayer().alias! + ", you play " + userPlay
//            }
//            else {
                //gameTitle.textColor = UIColor.whiteColor()
                gameTitle.text = userPlay + " to play"
                titleGame = gameTitle.text!
//            }
        }
        
        lockELO = false
        hideButtons()
        redisplayELO()
        UserData.increaseNumOfGames()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let board = UserData.getBoard()
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: board + "_bg")//if its in images.xcassets
        imageView.contentMode = .ScaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        hideButtons()
        theBoardView.moveFinishDelegate = self
        theBoardView.updateStatusDelegate = self
        gameTitle.backgroundColor = UIColor(patternImage: UIImage(named: board + "_title")!)
        eloLabel.backgroundColor = UIColor(patternImage: UIImage(named: board + "_title")!)
        eloLabel.textColor = UIColor.blackColor()
        eloLabel.text = " Your rating: " + String(UserData.getScore())
        gameTitle.textColor = UIColor.blackColor()
        gameTitle.textAlignment = .Center
        var userPlay = "White"
        let puzzle = theBoardView.puzzle
        if puzzle != nil && puzzle.flipBoard {
            userPlay = "Black"
        }
        gameTitle.text = userPlay + " to play"
        loadBanner()
    }
    
    func loadBanner(){
        //gAdBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        gAdBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gAdBannerView.rootViewController = self
        let req : GADRequest = GADRequest()
        gAdBannerView.loadRequest(req)
        //gAdBannerView.frame = CGRectMake(0, view.bounds.height - gAdBannerView.frame.size.height, gAdBannerView.frame.size.width, gAdBannerView.frame.size.height)
        //self.view.addSubview(gAdBannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveFinish(moveResult: MoveResult){
        //eloLabel.text = String(moveResult)
    }
    
    func updateUserStatus(correctMove: Bool, moveNum: (Int, Int)) {
        var score = UserData.getScore()
        let elo = theBoardView.getPuzzle().elo
        
        if !correctMove {
            Chirp.sharedManager.playSound(fileName: "invalid")
            if(!lockELO) {
                lockELO = true
                let eloChange = ELOUtils.calculateELOChange(UserData.getScore(), rating2: elo, winLoseDraw: 0, numOfGamesPlayed: UserData.getNumOfGames(), moveNum: moveNum)
                var symbol = "+"
                
                score += eloChange
                //eloLabel.textColor = UIColor.redColor()
                eloLabel.text = " Your rating: " + String(score) + " (" + String(eloChange) + ")"
                
                UserData.storeScore(score)
            }
            updateUIWhenFailed()
        }
        else {
            //gameTitle.textColor = UIColor.greenColor()
            gameTitle.text = "Correct"
            if (!lockELO && moveNum.0 >= moveNum.1){
                Chirp.sharedManager.playSound(fileName: "correct")
                let eloChange = ELOUtils.calculateELOChange(UserData.getScore(), rating2: elo, winLoseDraw: 1, numOfGamesPlayed: UserData.getNumOfGames(),moveNum: moveNum)
                let symbol = "+"
            
                score += eloChange
                eloLabel.text = " Your rating: " + String(score) + " (" + symbol + String(eloChange) + ")"
                enableNext()
                
                UserData.storeScore(score)
            }
            
            else if(lockELO) {
                //eloLabel.textColor = UIColor.whiteColor()
                //eloLabel.text = String(score)
                if (moveNum.0 >= moveNum.1){
                    enableNext()
                }
            }
            
        }
        
    }
    
    func updateUIWhenFailed(){
        retryButton.hidden = false
        solutionButton.hidden = false
        gameTitle.text = "Incorrect"
        enableNext()
    }

    func enableNext() {
        //nextButton.backgroundColor = UIColor.orangeColor()
        nextButton.hidden = false
        //ideaButton.backgroundColor = UIColor.lightGrayColor()
        ideaButton.hidden = false
    }
    
    func hideButtons(){
        nextButton.frame = CGRectMake(0, 0, nextButton.currentImage!.size.width/2, nextButton.currentImage!.size.height/3)
        nextButton.hidden = true
        ideaButton.hidden = true
        ideaButton.frame = CGRectMake(0, 0, nextButton.currentImage!.size.width/2, nextButton.currentImage!.size.height/3)
        solutionButton.hidden = true
        solutionButton.frame = CGRectMake(0, 0, nextButton.currentImage!.size.width/2, nextButton.currentImage!.size.height/3)
        retryButton.hidden = true
        retryButton.frame = CGRectMake(0, 0, nextButton.currentImage!.size.width/2, nextButton.currentImage!.size.height/3)
    }

    func redisplayELO(){
        let score = UserData.getScore()
        eloLabel.text = String(score)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

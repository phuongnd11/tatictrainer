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


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class GameViewController: UIViewController, PrintEventDelegate, UpdateStatusDelegate {
    
    @IBOutlet weak var ideaButton: UIButton!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eloLabel: UILabel!
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var solutionButton: UIButton!
    
    @IBOutlet weak var gAdBannerView: GADBannerView!
    
    @IBOutlet weak var theBoardView: BoardView!
    
    @IBOutlet weak var backButton: UIButton!
    
    var popViewController: PopUpViewController!
    
    @IBOutlet weak var gameControlStackView: UIStackView!
    var lockELO = false
    var titleGame = ""
    
    @IBAction func ideaClicked(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Idea/Comment for this tatic", message: "Not available", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func solutionClicked(_ sender: AnyObject) {
        if(!theBoardView.showingSolution){
            solutionButton.isEnabled = false;
            if theBoardView != nil {
                theBoardView.moveBack()
                theBoardView.showSolution()
            }
        
            retryButton.isHidden = true
        
            gameTitle.text = "Solution"
            solutionButton.isEnabled = true;
        }
    }
    
    @IBAction func retryClicked(_ sender: AnyObject) {
        
        if theBoardView != nil {
            theBoardView.retry()
            theBoardView.highlightComputerMoveAgain()
        }
        //gameTitle.textColor = UIColor.whiteColor()
        gameTitle.text = "Analysis mode"
        
        hideButtons()
        //redisplayELO()
    }
    
    @IBAction func nextButton(_ sender: AnyObject) {
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
        imageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        hideButtons()
        theBoardView.moveFinishDelegate = self
        theBoardView.updateStatusDelegate = self
        gameTitle.backgroundColor = UIColor(patternImage: UIImage(named: board + "_title")!)
        eloLabel.backgroundColor = UIColor(patternImage: UIImage(named: board + "_title")!)
        eloLabel.textColor = UIColor.black
        eloLabel.text = " Your rating: " + String(UserData.getScore())
        gameTitle.textColor = UIColor.black
        gameTitle.textAlignment = .center
        var userPlay = "White"
        let puzzle = theBoardView.puzzle
        if puzzle != nil && (puzzle?.flipBoard)! {
            userPlay = "Black"
        }
        gameTitle.text = userPlay + " to play"
        
        if (DeviceType.IS_IPHONE_6P) {
            let width = self.view.bounds.width*2/4
            let y = self.view.bounds.height*1/25
            let x = (self.view.bounds.width - width)/2
            let height = width*92/502
            
            let logoImageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
            logoImageView.image = UIImage(named: "logo_text")
            self.view.addSubview(logoImageView)
            
            //parentStackView.
            //let horizontalConstraint = NSLayoutConstraint(item: parentStackView, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: self.topLayoutGuide)
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 80).isActive = true
            
            //backButton.frame = CGRectMake(x, y, width, height)
            backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: y).isActive = true
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 3).isActive = true
            self.view.bringSubview(toFront: backButton)
            loadBanner()
        }
        
        if (DeviceType.IS_IPHONE_6) {
            let width = self.view.bounds.width*2/4
            let y = self.view.bounds.height*1/25
            let x = (self.view.bounds.width - width)/2
            let height = width*92/502
        
            let logoImageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
            logoImageView.image = UIImage(named: "logo_text")
            self.view.addSubview(logoImageView)
            
            //parentStackView.
            //let horizontalConstraint = NSLayoutConstraint(item: parentStackView, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: self.topLayoutGuide)
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 80).isActive = true
            
            //backButton.frame = CGRectMake(x, y, width, height)
            backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: y).isActive = true
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 3).isActive = true
            self.view.bringSubview(toFront: backButton)
            loadBanner()
        }
        else if (DeviceType.IS_IPHONE_4_OR_LESS) {
            //let width = self.view.bounds.width*1/4
            //let y = self.view.bounds.height*1/30
            //let x = (self.view.bounds.width - width)/2
            //let height = width*92/502
            
            //let logoImageView = UIImageView(frame: CGRectMake(x, y, width, height))
            //logoImageView.image = UIImage(named: "logo_text")
            //self.view.addSubview(logoImageView)
            
            //parentStackView.
            //let horizontalConstraint = NSLayoutConstraint(item: parentStackView, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: self.topLayoutGuide)
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
            gameControlStackView.alignment = UIStackViewAlignment.center
            //backButton.frame = CGRectMake(x, y, width, height)
            backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 3).isActive = true
            
            retryButton.setImage(UIImage(named: "i4-retry-button"), for: UIControlState())
            solutionButton.setImage(UIImage(named: "i4-solution-button"), for: UIControlState())
            nextButton.setImage(UIImage(named: "i4-next-button"), for: UIControlState())
            ideaButton.setImage(UIImage(named: "i4-idea-button"), for: UIControlState())
            
            
            self.view.bringSubview(toFront: backButton)
        }
        else if (DeviceType.IS_IPHONE_5){
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
            backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 4).isActive = true
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 3).isActive = true
            self.view.bringSubview(toFront: backButton)
            loadBanner()
        }
    }
    
    func loadBanner(){
        //gAdBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        gAdBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gAdBannerView.rootViewController = self
        let req : GADRequest = GADRequest()
        gAdBannerView.load(req)
        //gAdBannerView.frame = CGRectMake(0, view.bounds.height - gAdBannerView.frame.size.height, gAdBannerView.frame.size.width, gAdBannerView.frame.size.height)
        //self.view.addSubview(gAdBannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveFinish(_ moveResult: MoveResult){
        //eloLabel.text = String(moveResult)
    }
    
    func updateUserStatus(_ correctMove: Bool, moveNum: (Int, Int)) {
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
        retryButton.isHidden = false
        solutionButton.isHidden = false
        gameTitle.text = "Incorrect"
        enableNext()
    }

    func enableNext() {
        //nextButton.backgroundColor = UIColor.orangeColor()
        nextButton.isHidden = false
        //ideaButton.backgroundColor = UIColor.lightGrayColor()
        ideaButton.isHidden = false
    }
    
    func hideButtons(){
        //nextButton.frame = CGRect(x: 0, y: 0, width: nextButton.currentImage!.size.width/2, height: nextButton.currentImage!.size.height/3)
        //nextButton.isHidden = true
        //ideaButton.isHidden = true
        //ideaButton.frame = CGRect(x: 0, y: 0, width: nextButton.currentImage!.size.width/2, height: nextButton.currentImage!.size.height/3)
        //solutionButton.isHidden = true
       //solutionButton.frame = CGRect(x: 0, y: 0, width: nextButton.currentImage!.size.width/2, height: nextButton.currentImage!.size.height/3)
        //retryButton.isHidden = true
        //retryButton.frame = CGRect(x: 0, y: 0, width: nextButton.currentImage!.size.width/2, height: nextButton.currentImage!.size.height/3)
    }

    func redisplayELO(){
        let score = UserData.getScore()
        eloLabel.text = " Your rating: " + String(score)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}

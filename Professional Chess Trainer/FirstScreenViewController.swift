//
//  FirstScreenViewController.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 3/26/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit
import GameKit

class FirstScreenViewController: UIViewController, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "default" + "_first_bg")//if its in images.xcassets
        //imageView.contentMode = .ScaleAspectFill
        //imageView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor)
        //imageView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)

        Chirp.sharedManager.prepareSound(fileName: "move")
        Chirp.sharedManager.prepareSound(fileName: "invalid")
        Chirp.sharedManager.prepareSound(fileName: "eat")
        Chirp.sharedManager.prepareSound(fileName: "correct")
        //UserData.resetPlayedGames()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(sender: UIButton) {
        
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        
    }
    
    @IBAction func showLeaderBoard(sender: AnyObject) {
        authPlayer()
        saveHighscore(UserData.getScore())
        showLeaderBoard()
    }
    
    func saveHighscore(number : Int){
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "chesstaticv1_leaderboard")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
            
        }
        
    }
    
    //Game Center Functions
    
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
                self.presentViewController(view!, animated: true, completion: nil)
                
            }
            else {
                
                print(GKLocalPlayer.localPlayer().authenticated)
                
            }
            
            
        }
    }
    
    func showLeaderBoard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.presentViewController(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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

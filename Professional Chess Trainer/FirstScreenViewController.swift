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

    @IBOutlet weak var parentStackView: UIStackView!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let board = UserData.getBoard()
        imageView = UIImageView(frame: self.view.bounds)
        
        //imageView.contentMode = .ScaleAspectFill
        //imageView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor)
        //imageView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
        
        
        if (DeviceType.IS_IPHONE_6P) {
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 440).isActive = true
            imageView.image = UIImage(named: board + "_i6_first_bg")
        }
        
        if (DeviceType.IS_IPHONE_6) {
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 400).isActive = true
            imageView.image = UIImage(named: board + "_i6_first_bg")
        }
        else if (DeviceType.IS_IPHONE_4_OR_LESS) {
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 270).isActive = true
            imageView.image = UIImage(named: board + "_i4_first_bg")
        }
        else if (DeviceType.IS_IPHONE_5){
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 330).isActive = true
            imageView.image = UIImage(named: board + "_i5_first_bg")
        }
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
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
    
    @IBAction func play(_ sender: UIButton) {
        
    }
    
    @IBAction func unwindToSegue (_ segue : UIStoryboardSegue) {
        let board = UserData.getBoard()
        
        //imageView.contentMode = .ScaleAspectFill
        //imageView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor)
        //imageView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
        
        
        if (DeviceType.IS_IPHONE_6P) {
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 440).isActive = true
            imageView.image = UIImage(named: board + "_i6_first_bg")
        }
        
        if (DeviceType.IS_IPHONE_6) {
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 400).isActive = true
            imageView.image = UIImage(named: board + "_i6_first_bg")
        }
        else if (DeviceType.IS_IPHONE_4_OR_LESS) {
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 270).isActive = true
            imageView.image = UIImage(named: board + "_i4_first_bg")
        }
        else if (DeviceType.IS_IPHONE_5){
            parentStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 330).isActive = true
            imageView.image = UIImage(named: board + "_i5_first_bg")
        }
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    @IBAction func showLeaderBoard(_ sender: AnyObject) {
        authPlayer()
        saveHighscore(UserData.getScore())
        showLeaderBoard()
    }
    
    func saveHighscore(_ number : Int){
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "chesstatics_leaderbaord")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
        }
        
    }
    
    //Game Center Functions
    
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
                self.present(view!, animated: true, completion: nil)
                
            }
            else {
                
                print(GKLocalPlayer.localPlayer().isAuthenticated)
                
            }
            
            
        }
    }
    
    func showLeaderBoard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    override var prefersStatusBarHidden : Bool {
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

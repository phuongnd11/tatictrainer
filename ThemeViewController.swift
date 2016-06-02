//
//  ThemeViewController.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 5/21/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var changeBoardButton: UIButton!
    @IBOutlet weak var changePieceButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var currentBoard = ""
    var currentPiece = ""
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let board = UserData.getBoard()
        imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: board + "_bg")//if its in images.xcassets
        imageView.contentMode = .ScaleAspectFill
        
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        
        if boardView != nil {
            
            let puzzle = Puzzle(FEN: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", computerMove: "", solution: "e4", idea: "Nakamura - Magnus Carslen 2015", elo: 1480, id: 2)
            boardView.reload(puzzle)
            boardView.disable = true
            
            boardView.setNeedsDisplay()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBAction func chooseTheme(sender: AnyObject) {
        UserData.savePiece(currentPiece)
        UserData.saveBoard(currentBoard)
    }
    

    @IBAction func changePiece(sender: AnyObject) {
        if (currentPiece == "") {
            currentPiece = UserData.getPiece()
        }
        if boardView != nil {
            var nextPiece = Theme.getNextPiece(currentPiece)
            boardView.changePieceStype(nextPiece)
            currentPiece = nextPiece
            let puzzle = Puzzle(FEN: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", computerMove: "", solution: "e4", idea: "Nakamura - Magnus Carslen 2015", elo: 1480, id: 2)
            boardView.reload(puzzle)
            boardView.disable = true
            
            boardView.setNeedsDisplay()
        }
    }
    
    
    @IBAction func changeBoard(sender: AnyObject) {
        if (currentBoard == "") {
            currentBoard = UserData.getBoard()
        }
        if boardView != nil {
            var nextBoard = Theme.getNextBoard(currentBoard)
            boardView.boardStyle = nextBoard
            currentBoard = nextBoard
            imageView.image = UIImage(named: nextBoard + "_bg")
            let puzzle = Puzzle(FEN: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", computerMove: "", solution: "e4", idea: "Nakamura - Magnus Carslen 2015", elo: 1480, id: 2)
            boardView.reload(puzzle)
            boardView.disable = true
            
            boardView.setNeedsDisplay()
        }
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

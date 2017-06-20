//
//  SoundPlayer.swift
//  Professional Chess Trainer
//
//  Created by Phuong on 4/23/16.
//  Copyright © 2016 InspireOn. All rights reserved.
//

import Foundation
import AVFoundation

open class SoundPlayer{
    
    var audioPlayer: AVAudioPlayer!
    
    func playMove(){
        do {
            self.audioPlayer =  try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Click", ofType: "wav")!))
            self.audioPlayer.play()
        }
        catch {
            print("error")
        }
        /**
        let path = NSBundle.mainBundle().pathForResource("click.wav", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            playMoveEffect = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
         */
    }
    
}

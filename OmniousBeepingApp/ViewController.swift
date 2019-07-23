//
//  ViewController.swift
//  OmniousBeepingApp
//
//  Created by Manan on 2019-07-22.
//  Copyright © 2019 Manan Patel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let beepingSound = URL(fileURLWithPath: Bundle.main.path(forResource: "beeping", ofType: "m4a")!)
    var audioPlayer = AVAudioPlayer()
    var playing = false

    @IBAction func buttonPressed(_ sender: Any) {
        if playing != true {
            playBeeping()
            playing = true
            imageView.image = #imageLiteral(resourceName: "pause")
        } else {
            audioPlayer.stop()
            playing = false
            imageView.image = #imageLiteral(resourceName: "play")
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    var pulseArray = [CAShapeLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupImage()
        createPulse()
    }
    
    override func becomeFirstResponder() -> Bool{
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            playBeeping()
            playing = true
        }
    }
    
    func playBeeping() {
        do {
            if let url = Bundle.main.url(forResource: "beeping", withExtension: "m4a") {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.numberOfLoops = -1
                audioPlayer.play()
            }
        } catch {
            
        }
    }
    
    
    func setupImage() {
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.backgroundColor = .red
        imageView.clipsToBounds = false
        imageView.contentMode = .center
    }
    
    
    func createPulse(){
        
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.width/2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            let pulsatingLayer = CAShapeLayer()
            pulsatingLayer.path = circularPath.cgPath
            pulsatingLayer.lineWidth = 60
            pulsatingLayer.fillColor = UIColor.clear.cgColor
            pulsatingLayer.lineCap = .round
            pulsatingLayer.position = CGPoint(x: imageView.frame.width/2, y: imageView.frame.size.width/2)
            imageView.layer.addSublayer(pulsatingLayer)
            pulseArray.append(pulsatingLayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animatePulsingLayer(at: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.animatePulsingLayer(at: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    self.animatePulsingLayer(at: 2)
                })
            })
        })
    }

    func animatePulsingLayer(at index:Int){
        pulseArray[index].strokeColor = UIColor.red.cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 1.1
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulseArray[index].add(groupAnimation, forKey: "groupanimation")
        
    }

}


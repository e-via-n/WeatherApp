//
//  LoadView.swift
//  MyWeatherApp#2
//
//  Created by Evian on 27.12.2020.
//

import UIKit

class LoadView: UIViewController {
  
  //MARK: -Outlets
  @IBOutlet weak var firstPoint: UILabel!
  @IBOutlet weak var secondPoint: UILabel!
  @IBOutlet weak var thirdPoint: UILabel!
  
  //MARK: -Life cycle
  override func viewDidAppear(_ animated: Bool) {
    Bundle.main.loadNibNamed("LoadView", owner: self, options: nil)
    animatePointsLoad()
  }
  
  
  //MARK: -Animation
  private func animatePointsLoad() {
    
    firstPoint.transform = CGAffineTransform(translationX: 1, y: 3)
    secondPoint.transform = CGAffineTransform(translationX: 1, y: 3)
    thirdPoint.transform = CGAffineTransform(translationX: 1, y: 3)
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: [.autoreverse, .repeat],
                   animations: {
                    self.firstPoint.transform = .identity
                    self.firstPoint.alpha = 0.2
                   },
                   completion: nil)
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.5,
                   options: [.autoreverse, .repeat],
                   animations: {
                    self.secondPoint.transform = .identity
                    self.secondPoint.alpha = 0.2
                   },
                   completion: nil)
    
    UIView.animate(withDuration: 0.5,
                   delay: 1,
                   options: [.autoreverse, .repeat],
                   animations: {
                    
                    self.thirdPoint.transform = .identity
                    self.thirdPoint.alpha = 0.2
                   },
                   completion: nil)
  }
  
  private func pathAnimation() {
    
    let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
    pathAnimationEnd.fromValue = 0
    pathAnimationEnd.toValue = 1
    pathAnimationEnd.duration = 2
    pathAnimationEnd.fillMode = .both
    pathAnimationEnd.isRemovedOnCompletion = false
    
    let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
    pathAnimationStart.fromValue = 0
    pathAnimationStart.toValue = 1
    pathAnimationStart.duration = 2
    pathAnimationStart.fillMode = .both
    pathAnimationStart.isRemovedOnCompletion = false
    pathAnimationStart.beginTime = 1
    
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 3
    animationGroup.fillMode = CAMediaTimingFillMode.backwards
    animationGroup.animations = [pathAnimationEnd, pathAnimationStart]
    animationGroup.repeatCount = .infinity
  }
  
}

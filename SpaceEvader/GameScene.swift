//
//  GameScene.swift
//  SpaceEvader
//
//  Created by iD Student on 8/3/17.
//  Copyright © 2017 com.iDtech. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let hero = SKSpriteNode(imageNamed: "Spaceship")
    let heroSpeed: CGFloat = 100.0
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        
        let xCoord = size.width * 0.5
        let yCoord = size.height * 0.5
        
        hero.size.height = 50
        hero.size.width = 50
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
    
        
        addChild(hero)
        
        
      
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        
        swipeUp.direction = .up
        
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeDown)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
    }
        
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        let bullet = SKSpriteNode()
         bullet.color = UIColor.green
        bullet.size = CGSize(width: 5, height: 5)
        bullet.position = CGPoint(x: hero.position.x, y: hero.position.y)
        addChild(bullet)
        
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let vector = CGVector(dx: -(hero.position.x - touchLocation.x), dy: -(hero.position.y - touchLocation.y))
        
    
        let projectileAction = SKAction.sequence([
            SKAction.repeat(
                SKAction.move(by: vector, duration: 0.5), count: 10),
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ])
        bullet.run(projectileAction)    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x , y: hero.position.y + heroSpeed), duration: 0.5);
        
        hero.run(actionMove);
        print("Up")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x , y: hero.position.y - heroSpeed), duration: 0.5);
        
        hero.run(actionMove);
        print("Down")
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x + heroSpeed , y: hero.position.y ), duration: 0.5);
        
        hero.run(actionMove);
        print("Right")
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x - heroSpeed , y: hero.position.y), duration: 0.5);
        
        hero.run(actionMove);
        print("Left")
    }
}

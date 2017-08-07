//
//  GameScene.swift
//  SpaceEvader
//
//  Created by iD Student on 8/3/17.
//  Copyright © 2017 com.iDtech. All rights reserved.
//

import SpriteKit
import GameplayKit


struct BodyType {
    
    static let None: UInt32 = 0
    static let Meteor: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Hero: UInt32 = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let hero = SKSpriteNode(imageNamed: "Spaceship")
    let heroSpeed: CGFloat = 100.0
    // Declare the new variables
    
    var meteorScore = 0
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    
    
    var level = 1
    
    var levelLabel = SKLabelNode(fontNamed: "Arial")
    
    var levelLimit = 5
    
    var levelIncrease = 5
    
    var enemies : [Enemy] = []
    var enemyHealth = 1
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        
        let xCoord = size.width * 0.5
        let yCoord = size.height * 0.5
        
        hero.size.height = 50.0
        hero.size.width = 50.0
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
        // Set up the label in the didMoveToView(...) method
        
        scoreLabel.fontColor = UIColor.white
        
        scoreLabel.fontSize = 40
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-50)
        
        addChild(scoreLabel)
        
        levelLabel.fontColor = UIColor.yellow
        
        levelLabel.fontSize = 20
        
        levelLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.9)
        
        addChild(levelLabel)
        
        levelLabel.text = "Level: 1"
        
        scoreLabel.text = "0"
        
        
        
        
        // Hero
        
        // Add in the didMove(to:) method before the addChild() method
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BodyType.Hero
        hero.physicsBody?.contactTestBitMask = BodyType.Meteor
        hero.physicsBody?.collisionBitMask = 0
        
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
        
        //creates a random float between 0.0 and 1.0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        physicsWorld.contactDelegate = self
        
        //repeatedly runs addMeteor function every second.
        
        addEnemies()

    
    }

    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
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
        
        // Bullet
        
        
        // Add in the touchesEnd() method before the addChild() method
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = BodyType.Bullet
        bullet.physicsBody?.contactTestBitMask = BodyType.Meteor
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
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
        
        if (hero.position.y + heroSpeed >= size.height){
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: 0.5)
        }
        
        
        hero.run(actionMove);
        print("Up")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.y - heroSpeed <= 0){
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.size.height/2), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y - heroSpeed), duration: 0.5)
        }
        
        
        hero.run(actionMove);
        print("Down")
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x + heroSpeed >= size.width){
            
            actionMove = SKAction.move(to: CGPoint(x: size.width - hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x + heroSpeed, y: hero.position.y), duration: 0.5)
        }
        
        
        hero.run(actionMove);
        print("Right")
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x - heroSpeed <= 0){
            
            actionMove = SKAction.move(to: CGPoint(x: hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x - heroSpeed, y: hero.position.y), duration: 0.5)
        }
        
        
        hero.run(actionMove);
        print("Left")
    }
  
    func addMeteor() {
    
        var meteor: Enemy
        
        meteor = Enemy(imageNamed: "MeteorLeft")
        
        meteor.size.height = 35.0
        
        meteor.size.width = 50.0
        
        let randomY = random() * (size.height - meteor.size.height)  + meteor.size.height/2;
        
        meteor.position = CGPoint(x: size.width + meteor.size.width/2, y: randomY)
        
        // Meteor
        
        // Add in the addMeteor() method before the addChild() method
        
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody?.categoryBitMask = BodyType.Meteor
        meteor.physicsBody?.contactTestBitMask = BodyType.Bullet
        meteor.physicsBody?.collisionBitMask = 0
        
        addChild(meteor)
        
        enemies.append(meteor)
        
        
        var moveMeteor: SKAction
        
        moveMeteor = SKAction.move(to: CGPoint(x: -meteor.size.width/2, y: randomY), duration: (5.0))
        
        meteor.run(SKAction.sequence([moveMeteor, SKAction.removeFromParent()]))
        
    }
    
    func  didBegin(_ contact: SKPhysicsContact) {
       
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let contactA = bodyA.categoryBitMask
        let contactB = bodyB.categoryBitMask
    
        
        switch contactA {
            
        case BodyType.Meteor:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                break
                
                
                
            case BodyType.Bullet:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    explodeMeteor(meteor: bodyANode)
                    bulletHitMeteor(bullet: bodyBNode, meteor: bodyANode)
                    
                }
                
                
                
            case BodyType.Hero:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    heroHitMeteor(player: bodyBNode, meteor: bodyANode)
                    
                }
                
                
                
            default:
                
                break
                
            }
            
            
            
        case BodyType.Bullet:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    explodeMeteor(meteor: bodyBNode)
                    bulletHitMeteor(bullet: bodyANode, meteor: bodyBNode)
                }
                
                
                
            case BodyType.Bullet:
                
                break
                
                
                
            case BodyType.Hero:
                
                break
                
                
                
            default:
                
                break
                
            }
            
            
            
        case BodyType.Hero:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                    heroHitMeteor(player: bodyANode, meteor: bodyBNode)
                    
                }           
                
                
                
            case BodyType.Bullet:
                
                break     
                
                
                
            case BodyType.Hero:
                
                break       
                
                
                
            default:
                
                break
                
            }
            
            
            
        default:
            
            break
            
        }
    
    }
    func bulletHitMeteor(bullet: SKSpriteNode, meteor: Enemy) {
        
        bullet.removeFromParent()
        
        meteor.removeFromParent()
        
        // In bulletHitMeteor() increment the score and set the label value
        
        meteorScore += 1
        
        scoreLabel.text = "\(meteorScore)"
        
        explodeMeteor(meteor: meteor)
        
        checkLevelIncrease()
        
      
        if let meteorIndex = enemies.index(of: meteor) {
            
            enemies.remove(at: meteorIndex)
        }
        
}

    func heroHitMeteor(player: SKSpriteNode, meteor: Enemy) {
        
        
        removeAllChildren()
        
        // Label Code
        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        
        gameOverLabel.text = "Game Over"
        
        gameOverLabel.fontColor = UIColor.white
        
        gameOverLabel.fontSize = 40
        
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        addChild(gameOverLabel)        
    }


    func explodeMeteor(meteor: Enemy) {
        
        let explosions: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        
        for explosion in explosions {
            
            explosion.color = UIColor.orange
            explosion.size = CGSize (width: 5, height: 5)
            explosion.position = CGPoint (x: meteor.position.x, y: meteor.position.y)
            
            let randomExplosionX = (random() * (1000 + size.width)) - size.width
            
            let randomExplosionY = (random() * (1000 + size.height)) - size.width
            
            let moveExplosion: SKAction
            
            moveExplosion = SKAction.move(to: CGPoint(x: randomExplosionX, y: randomExplosionY), duration: 10.0)
            explosion.run(SKAction.sequence([moveExplosion, SKAction.removeFromParent()]))
            
            addChild(explosion)
            
        }
    }
    
    
    func addEnemies() {
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMeteor), SKAction.wait(forDuration: 1.0)])), withKey:"addEnemies")
    }
    
    func stopEnemies() {
        
        for enemy in enemies {
            enemy.removeFromParent()
        }
        
        removeAction(forKey: "addEnemies")
    }
    
    
    func increaseLevel(){
        
        levelLimit = levelLimit + levelIncrease
        
        level += 1
        
        levelLabel.text = "Level: \(level)"
    }
    
    
    
    func checkLevelIncrease(){
    
        if meteorScore > levelLimit {
    
            for enemy in enemies {
                
                enemy.removeFromParent()
            }
            
            enemies = [Enemy] ()
            
            let runEnemies = SKAction.sequence([SKAction.run(stopEnemies), SKAction.wait(forDuration: 10.0), SKAction.run(increaseLevel), SKAction.run(addEnemies)])
            
            run(runEnemies)
    }
    
    }
}






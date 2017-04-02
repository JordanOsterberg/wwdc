//: Playground - noun: a place where people can play

import PlaygroundSupport
import SpriteKit
import CoreMotion

class Scene : SKScene, SKPhysicsContactDelegate {
    
    var advanceAllowed = false
    var stage : Stage = .welcome
    
    var mainSprite : SKSpriteNode?
    var background : SKSpriteNode?
    var spriteArray = SKSpriteArray()
    
    var motionManager = CMMotionManager()
    
    var catTimer : Timer?
    var catSeconds = 0
    
    var firstCatImage = UIImage(named: "cat1")
    var secondCatImage = UIImage(named: "cat2")
    
    var audioNode : SKAudioNode?
    var statusLabel = SKLabelNode(fontNamed: "Arial")
    var lowerStatusLabel = SKLabelNode(fontNamed: "Arial")
    var taps = 10
    
    var meSuccessTaps = 0
    var meFailedTaps = 0
    
    var originalBackgroundColor : UIColor?
    
    var physicsWantedContact = ""
    var blueHoleNode : SKSpriteNode?
    var redHoleNode : SKSpriteNode?
    var yellowHoleNode : SKSpriteNode?
    var whiteHoleNode : SKSpriteNode?
    var mainLabel : SKLabelNode?
    
    var timPoints = 0
    var canTimGetPoints = true
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        originalBackgroundColor = self.backgroundColor
        showWelcome()
    }
    
    // Shows the first welcome screen
    func showWelcome() {
        let appleLogo = SKSpriteNode(imageNamed: "appl.png")
        appleLogo.setScale(0.5)
        appleLogo.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        appleLogo.alpha = 0
        addChild(appleLogo)
        
        let title = SKLabelNode(fontNamed: "Arial")
        title.text = "Jordan Osterberg's"
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 120)
        title.fontColor = UIColor.white
        title.zPosition = 10
        title.setScale(0.5)
        title.alpha = 0
        
        let subTitle = SKLabelNode(fontNamed: "Arial")
        subTitle.text = "WWDC 2017 Playground"
        subTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        subTitle.fontColor = UIColor.white
        subTitle.zPosition = 10
        subTitle.setScale(0.5)
        subTitle.alpha = 0
        
        let continueLabel = SKLabelNode(fontNamed: "Arial")
        continueLabel.text = "Tap to begin! (The playground may lag at times, be patient)"
        continueLabel.alpha = 0
        continueLabel.position = subTitle.position
        continueLabel.position.y = continueLabel.position.y - 25
        continueLabel.fontSize = 15
        
        self.addChild(title)
        self.addChild(subTitle)
        self.addChild(continueLabel)
        
        appleLogo.run(SKAction.group([SKAction.fadeIn(withDuration: 3), SKAction.scale(to: 1, duration: 3)]))
        continueLabel.run(SKAction.sequence([SKAction.wait(forDuration: 4), SKAction.fadeIn(withDuration: 1)]))
        title.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.group([SKAction.scale(to: 1, duration: 2), SKAction.fadeIn(withDuration: 2)])]))
        subTitle.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.group([SKAction.scale(to: 1, duration: 2), SKAction.fadeIn(withDuration: 2)])]))
        
        run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
            self.advanceAllowed = true
            self.simulateTouch()
            }]))
    }
    
    func simulateTouch() {
        //        touchesBegan([], with: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!advanceAllowed) {
            if (stage == .cat) {
                guard let touch = touches.first else { // Get first touch
                    return
                }
                
                let positionInScene = touch.location(in: self)
                let touchedNode = self.atPoint(positionInScene)
                
                if touchedNode == mainSprite! {
                    
                    let catTexture = SKTexture(image: secondCatImage!)
                    let catTexture2 = SKTexture(image: firstCatImage!)
                    
                    audioNode?.run(SKAction.changeVolume(by: -0.1, duration: 0))
                    taps -= 1
                    lowerStatusLabel.text = "\(taps) taps left to silence the cat! (\(self.catSeconds) seconds)"
                    
                    statusLabel.alpha = 0
                    
                    mainSprite?.position = CGPoint(x: randomX(maxX: Int(self.frame.maxX)), y: randomY(maxY: Int(self.frame.maxY)))
                    
                    if (taps == 0) {
                        catTimer?.invalidate()
                        clearAll()
                        let done = SKLabelNode(fontNamed: "Arial")
                        done.text = "You silenced the cat in \(catSeconds) seconds!"
                        done.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                        addChild(done)
                        
                        lowerStatusLabel = SKLabelNode(fontNamed: "Arial")
                        lowerStatusLabel.text = "Tap to continue!"
                        lowerStatusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
                        lowerStatusLabel.fontColor = UIColor.white
                        lowerStatusLabel.fontSize = 15
                        addChild(lowerStatusLabel)
                        
                        advanceAllowed = true
                        return
                    }
                    
                    mainSprite?.run(SKAction.sequence([SKAction.setTexture(catTexture), SKAction.run { self.mainSprite?.setScale(1.1) }, SKAction.wait(forDuration: 0.2), SKAction.run { self.mainSprite?.setScale(1) }, SKAction.setTexture(catTexture2)]))
                }
            } else if (stage == .me) {
                guard let touch = touches.first else {
                    return
                }
                
                let position = touch.location(in: self)
                if let node = nodes(at: position).first {
                    if (node.name == "crown" && !spriteArray.children.contains(node)) {
                        self.meSuccessTaps += 1
                        self.spriteArray.children.append(node)
                        self.spriteArray.updatePositions()
                        node.removeAllActions()
                        
                        run(SKAction.playSoundFileNamed("ding", waitForCompletion: false))
                        
                        self.lowerStatusLabel.text = "\(self.meSuccessTaps) crowns grabbed, \(self.meFailedTaps) crowns lost"
                        
                        handleMeAction()
                    }
                }
            }
            return
        }
        if (stage == .welcome) {
            clearAll()
            stage = .catInstructions
            
            let name = SKLabelNode(fontNamed: "Arial")
            name.text = "Silence the cat!"
            name.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 325)
            name.fontSize = 25
            addChild(name)
            
            let instructions = SKLabelNode(fontNamed: "Arial")
            instructions.text = "Tap the cat as fast as you can to silence it."
            instructions.fontSize = 20
            instructions.position = name.position
            instructions.position.y = instructions.position.y - 25
            addChild(instructions)
            
            let tapToContinue = SKLabelNode(fontNamed: "Arial")
            tapToContinue.text = "Tap to start"
            tapToContinue.fontSize = 15
            tapToContinue.position = instructions.position
            tapToContinue.position.y = tapToContinue.position.y - 100
            addChild(tapToContinue)
        } else if (stage == .catInstructions) {
            stage = .cat
            advanceAllowed = false
            
            clearAll()
            
            let catTexture = SKTexture(image: firstCatImage!)
            mainSprite = SKSpriteNode(texture: catTexture)
            mainSprite?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            addChild(mainSprite!)
            
            let an = SKAudioNode(fileNamed: "catmeow.mp3")
            audioNode = an
            addChild(an)
            audioNode?.autoplayLooped = true
            audioNode?.run(SKAction.play())
            
            statusLabel.text = "Tap on the cat to silence it!"
            statusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 250)
            statusLabel.fontColor = UIColor.white
            addChild(statusLabel)
            
            lowerStatusLabel.text = "10 taps left!"
            lowerStatusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 355)
            lowerStatusLabel.fontColor = UIColor.white
            lowerStatusLabel.fontSize = 15
            addChild(lowerStatusLabel)
            
            catTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                self.catSeconds+=1
                self.lowerStatusLabel.text = "\(self.taps) taps left to silence the cat! (\(self.catSeconds) seconds)"
            })
        } else if (stage == .cat) {
            clearAll()
            stage = .meInstructions
            
            let name = SKLabelNode(fontNamed: "Arial")
            name.text = "Collect the crowns!"
            name.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 325)
            name.fontSize = 25
            addChild(name)
            
            let instructions = SKLabelNode(fontNamed: "Arial")
            instructions.text = "Tap the falling crowns before they touch the ground!"
            instructions.fontSize = 20
            instructions.position = name.position
            instructions.position.y = instructions.position.y - 25
            addChild(instructions)
            
            let tapToContinue = SKLabelNode(fontNamed: "Arial")
            tapToContinue.text = "Tap to start"
            tapToContinue.fontSize = 15
            tapToContinue.position = instructions.position
            tapToContinue.position.y = tapToContinue.position.y - 100
            addChild(tapToContinue)
        } else if (stage == .meInstructions) {
            stage = .me
            advanceAllowed = false
            
            clearAll()
            
            self.backgroundColor = UIColor.white
            
            // This creates A LOT of lag, so don't use it :(
            //            background = SKSpriteNode(imageNamed: "me_bg")
            //            background?.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            //            background?.zPosition = -5
            //            addChild(background!)
            
            spriteArray.mainSprite = SKSpriteNode(texture: SKTexture(image: UIImage(named: "me")!))
            spriteArray.mainSprite!.name = "me"
            addChild(spriteArray.mainSprite!)
            spriteArray.mainSpritePosition = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
            
            lowerStatusLabel.text = "Tap each flower crown before it reaches the bottom"
            lowerStatusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 230)
            lowerStatusLabel.fontColor = UIColor.black
            lowerStatusLabel.fontSize = 15
            addChild(lowerStatusLabel)
            
            for x in 0...9 {
                run(SKAction.sequence([
                    SKAction.wait(forDuration: TimeInterval(x)),
                    SKAction.run { self.flowerDrop(waitFor: TimeInterval(x)) }
                    ]))
            }
        } else if (stage == .me) {
            clearAll()
            
            self.backgroundColor = originalBackgroundColor!
            
            stage = .rollInstructions
            
            let name = SKLabelNode(fontNamed: "Arial")
            name.text = "Rolling-Tim"
            name.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 325)
            name.fontSize = 25
            addChild(name)
            
            let instructions = SKLabelNode(fontNamed: "Arial")
            instructions.text = "Tilt the device to move Tim onto the dot that looks similar to the background color"
            instructions.fontSize = 20
            instructions.position = name.position
            instructions.position.y = instructions.position.y - 25
            addChild(instructions)
            
            let tapToContinue = SKLabelNode(fontNamed: "Arial")
            tapToContinue.text = "Tap to start"
            tapToContinue.fontSize = 15
            tapToContinue.position = instructions.position
            tapToContinue.position.y = tapToContinue.position.y - 100
            addChild(tapToContinue)
        } else if (stage == .rollInstructions) {
            stage = .roll
            advanceAllowed = false
            
            clearAll()
            
            if motionManager.isAccelerometerAvailable {
                self.mainSprite = SKSpriteNode(imageNamed: "cook")
                self.mainSprite?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.mainSprite?.physicsBody = SKPhysicsBody(circleOfRadius: self.mainSprite!.size.width / 3)
                self.mainSprite?.physicsBody?.affectedByGravity = false
                self.mainSprite?.physicsBody?.isDynamic = true
                self.mainSprite?.physicsBody?.allowsRotation = false
                self.mainSprite?.physicsBody?.categoryBitMask = 1
                self.mainSprite?.name = "cook"
                addChild(self.mainSprite!)
                
                let done = SKLabelNode(fontNamed: "Arial")
                done.text = "Tilt the device to move Tim onto the dot that looks similar to the background color"
                done.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 325)
                done.fontSize = 22
                addChild(done)
                self.mainLabel = done
                
                lowerStatusLabel = SKLabelNode(fontNamed: "Arial")
                lowerStatusLabel.text = "You'll loose points if you hit the wrong dot!"
                lowerStatusLabel.position = done.position
                lowerStatusLabel.position.y = lowerStatusLabel.position.y - 25
                lowerStatusLabel.fontColor = UIColor.white
                lowerStatusLabel.fontSize = 15
                addChild(lowerStatusLabel)
                
                let blueHole = SKSpriteNode(imageNamed: "blue")
                let redHole = SKSpriteNode(imageNamed: "red")
                let yellowHole = SKSpriteNode(imageNamed: "yellow")
                let whiteHole = SKSpriteNode(imageNamed: "white")
                
                blueHole.position = CGPoint(x: self.frame.midX + 450, y: self.frame.midY + 300)
                redHole.position = CGPoint(x: self.frame.midX + 450, y: self.frame.midY - 300)
                yellowHole.position = CGPoint(x: self.frame.midX - 450, y: self.frame.midY + 300)
                whiteHole.position = CGPoint(x: self.frame.midX - 450, y: self.frame.midY - 300)
                
                blueHole.physicsBody = SKPhysicsBody(circleOfRadius: blueHole.size.width / 3)
                redHole.physicsBody = SKPhysicsBody(circleOfRadius: redHole.size.width / 3)
                yellowHole.physicsBody = SKPhysicsBody(circleOfRadius: yellowHole.size.width / 3)
                whiteHole.physicsBody = SKPhysicsBody(circleOfRadius: whiteHole.size.width / 3)
                
                blueHole.physicsBody?.isDynamic = false
                blueHole.physicsBody?.affectedByGravity = false
                blueHole.physicsBody?.contactTestBitMask = 1
                blueHole.name = "blueHole"
                
                redHole.physicsBody?.isDynamic = false
                redHole.physicsBody?.affectedByGravity = false
                redHole.physicsBody?.contactTestBitMask = 1
                redHole.name = "redHole"
                
                yellowHole.physicsBody?.isDynamic = false
                yellowHole.physicsBody?.affectedByGravity = false
                yellowHole.physicsBody?.contactTestBitMask = 1
                yellowHole.name = "yellowHole"
                
                whiteHole.physicsBody?.isDynamic = false
                whiteHole.physicsBody?.affectedByGravity = false
                whiteHole.physicsBody?.contactTestBitMask = 1
                whiteHole.name = "whiteHole"
                
                blueHoleNode = blueHole
                redHoleNode = redHole
                yellowHoleNode = yellowHole
                whiteHoleNode = whiteHole
                
                addChild(blueHole)
                addChild(redHole)
                addChild(yellowHole)
                addChild(whiteHole)
                
                let timeLabel = SKLabelNode(fontNamed: "Arial")
                timeLabel.text = "30 seconds left"
                timeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                timeLabel.fontSize = 144
                timeLabel.fontColor = UIColor.black
                addChild(timeLabel)
                
                var int = 30
                
                var timer : Timer?
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                    int -= 1
                    if (int == 0) {
                        timer?.invalidate()
                        timeLabel.text = "Time's up! Tap the screen to continue!"
                        timeLabel.fontSize = 50
                        self.advanceAllowed = true
                        self.canTimGetPoints = false
                        self.motionManager.stopAccelerometerUpdates()
                    } else {
                        timeLabel.text = "\(int)"
                    }
                })
                
                self.physicsWantedContact = blueHole.name!
                
                originalBackgroundColor = self.backgroundColor
                
                self.backgroundColor = UIColor.blue
                
                let xRange = SKRange(lowerLimit: 0, upperLimit: size.width)
                let yRange = SKRange(lowerLimit: 0, upperLimit: size.height)
                self.mainSprite!.constraints = [SKConstraint.positionX(xRange, y: yRange)]
                
                motionManager.accelerometerUpdateInterval = 0.3
                motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, error in
                    if (self.stage != .roll) {
                        return
                    }
                    
                    if (error != nil) {
                        print ("error while handing accelerometer: \(error!)")
                        self.advanceAllowed = true
                        self.touchesBegan([], with: nil)
                        return
                    }
                    
                    let accel = data!.acceleration
                    self.mainSprite?.run(SKAction.moveBy(x: CGFloat(accel.y * 100), y: -CGFloat(accel.x * 100), duration: 0.5))
                })
            } else {
                let done = SKLabelNode(fontNamed: "Arial")
                done.text = "Uh oh! You don't have an accelerometer, so you can't play this one."
                done.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                addChild(done)
                
                lowerStatusLabel = SKLabelNode(fontNamed: "Arial")
                lowerStatusLabel.text = "Tap to skip (or get a device with an accelerometer, because this game is my favorite!)"
                lowerStatusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
                lowerStatusLabel.fontColor = UIColor.white
                lowerStatusLabel.fontSize = 15
                addChild(lowerStatusLabel)
                
                advanceAllowed = true
            }
        } else if (stage == .roll) {
            stage = .done
            advanceAllowed = false
            clearAll()
            
            self.backgroundColor = self.originalBackgroundColor!
            
            let done = SKLabelNode(fontNamed: "Arial")
            done.text = "That's all folks!"
            done.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            addChild(done)
            
            let thatsAll = SKSpriteNode(imageNamed: "thatsall")
            thatsAll.position = done.position
            thatsAll.position.y = thatsAll.position.y + 150
            addChild(thatsAll)
            
            spriteArray.mainSprite = SKSpriteNode(texture: SKTexture(image: UIImage(named: "me")!))
            spriteArray.mainSprite!.name = "me"
            addChild(spriteArray.mainSprite!)
            spriteArray.mainSpritePosition = CGPoint(x: self.frame.midX, y: self.frame.midY - 300)
            spriteArray.mainSpritePosition!.x = spriteArray.mainSpritePosition!.x - 300
            spriteArray.children.removeAll()
            
            for _ in 0...3 {
                let options = ["c1.png", "c2.png", "c3.png", "c4.png"]
                let crown = SKSpriteNode(imageNamed: options[Int(arc4random_uniform(UInt32(options.count)))])
                crown.name = "crown"
                self.addChild(crown)
                self.spriteArray.children.append(crown)
                self.spriteArray.updatePositions()
            }
            
            lowerStatusLabel = SKLabelNode(fontNamed: "Arial")
            lowerStatusLabel.text = "Thank you for reviewing my application, I can't wait to see the results :)"
            lowerStatusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
            lowerStatusLabel.fontColor = UIColor.white
            lowerStatusLabel.fontSize = 15
            addChild(lowerStatusLabel)
            
            let scores = SKLabelNode(fontNamed: "Arial")
            scores.text = "Cat silenced in \(self.catSeconds) seconds • Crowns Collected: \(self.meSuccessTaps)/10 • Tim Points: \(self.timPoints)"
            scores.position = lowerStatusLabel.position
            scores.position.y = scores.position.y - 25
            scores.fontSize = 15
            addChild(scores)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if bodyA.node != nil && bodyB.node != nil {
            let nodeA = bodyA.node!
            let nodeB = bodyB.node!
            if let nodeAName = nodeA.name, let nodeBName = nodeB.name {
                if (stage == .roll) {
                    if nodeAName == "cook" && nodeBName == self.physicsWantedContact && canTimGetPoints {
                        let options = ["blueHole", "redHole", "yellowHole", "whiteHole"]
                        let selected = randomOption(array: options, previous: self.physicsWantedContact)
                        self.physicsWantedContact = selected
                        self.mainLabel?.fontColor = UIColor.white
                    
                        let blueBody = self.blueHoleNode!.physicsBody!
                        let redBody = self.redHoleNode!.physicsBody!
                        let yellowBody = self.yellowHoleNode!.physicsBody!
                        let whiteBody = self.whiteHoleNode!.physicsBody!
                    
                        self.blueHoleNode!.physicsBody = nil
                        self.redHoleNode!.physicsBody = nil
                        self.yellowHoleNode!.physicsBody = nil
                        self.whiteHoleNode!.physicsBody = nil
                    
                        self.blueHoleNode!.position = CGPoint(x: randomX(maxX: Int(self.frame.width)), y: randomY(maxY: Int(self.frame.height)))
                        self.redHoleNode!.position = CGPoint(x: randomX(maxX: Int(self.frame.width)), y: randomY(maxY: Int(self.frame.height)))
                        self.yellowHoleNode!.position = CGPoint(x: randomX(maxX: Int(self.frame.width)), y: randomY(maxY: Int(self.frame.height)))
                        self.whiteHoleNode!.position = CGPoint(x: randomX(maxX: Int(self.frame.width)), y: randomY(maxY: Int(self.frame.height)))
                    
                        self.blueHoleNode!.physicsBody = blueBody
                        self.redHoleNode!.physicsBody = redBody
                        self.yellowHoleNode!.physicsBody = yellowBody
                        self.whiteHoleNode!.physicsBody = whiteBody
                    
                        if (self.children.contains(lowerStatusLabel)) {
                            removeChildren(in: [lowerStatusLabel])
                        }
                    
                        run(SKAction.playSoundFileNamed("ding", waitForCompletion: false))
                    
                        timPoints += 10
                        self.mainLabel?.text = "\(timPoints) Tim Points"
                    
                        switch (selected) {
                        case "blueHole":
                            self.backgroundColor = UIColor.blue
                            break
                        case "redHole":
                            self.backgroundColor = UIColor.red
                            break
                        case "yellowHole":
                            self.backgroundColor = UIColor.yellow
                            self.mainLabel?.fontColor = UIColor.black
                            break
                        case "whiteHole":
                            self.backgroundColor = UIColor.white
                            self.mainLabel?.fontColor = UIColor.black
                            break
                        default:
                            break
                        }
                    } else if (nodeAName == "cook" && canTimGetPoints) {
                        timPoints -= 10
                        if (timPoints < 0) {
                            timPoints = 0
                        }
                    
                        run(SKAction.playSoundFileNamed("fail", waitForCompletion: false))
                    
                        self.mainLabel?.text = "\(timPoints) Tim Points"
                    }
                }
            }
        } else {
            print ("nil")
        }
    }
    
    func randomOption(array: [String], previous: String) -> String {
        var selected = array[Int(arc4random_uniform(UInt32(array.count)))]
        if (selected == previous) {
            selected = randomOption(array: array, previous: previous)
        }
        
        return selected
    }
    
    func handleMeAction() {
        self.lowerStatusLabel.text = "\(self.meSuccessTaps) crowns grabbed, \(self.meFailedTaps) crowns lost"
        if (self.meSuccessTaps + self.meFailedTaps == 10) {
            self.lowerStatusLabel.alpha = 0
            
            let done = SKLabelNode(fontNamed: "Arial")
            done.text = "You collected \(self.meSuccessTaps)/10 flower crowns!"
            done.fontColor = UIColor.black
            done.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            addChild(done)
            
            lowerStatusLabel = SKLabelNode(fontNamed: "Arial")
            lowerStatusLabel.text = "Tap to continue!"
            lowerStatusLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 25)
            lowerStatusLabel.fontColor = UIColor.black
            lowerStatusLabel.fontSize = 15
            addChild(lowerStatusLabel)
            
            var cycle = 1
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run {
                    if (cycle == 1) {
                        cycle += 1
                        self.spriteArray.mainSpritePosition!.x = self.frame.midX
                    } else if (cycle == 2) {
                        cycle += 1
                        self.spriteArray.mainSpritePosition!.x = self.spriteArray.mainSpritePosition!.x + 100
                    } else if (cycle == 3) {
                        cycle = 1
                        self.spriteArray.mainSpritePosition!.x = self.spriteArray.mainSpritePosition!.x - 200
                    }
                }
                ])))
            
            self.advanceAllowed = true
        }
    }
    
    func flowerDrop(waitFor: TimeInterval) {
        run(SKAction.run {
            let options = ["c1.png", "c2.png", "c3.png", "c4.png"]
            let xOptions = [200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 825]
            let x = xOptions[Int(arc4random_uniform(UInt32(xOptions.count)))]
            let crown = SKSpriteNode(imageNamed: options[Int(arc4random_uniform(UInt32(options.count)))])
            crown.name = "crown"
            self.addChild(crown)
            
            crown.position = CGPoint(x: CGFloat(x), y: self.frame.midY + 400)
            crown.run(SKAction.moveTo(y: self.frame.midY - 400, duration: 7.0), completion: { _ in
                crown.removeFromParent()
                self.meFailedTaps+=1
                self.handleMeAction()
            })
        }, withKey: "meFlowerDrop")
    }
    
    // Utility Functions
    
    // Returns random y position
    func randomY(maxY: Int) -> CGFloat {
        let randomY = CGFloat(Int(arc4random()) % maxY)
        return randomY
    }
    
    // Returns random x position
    // Do not use for small objects like the flower crowns because it could cause them to go off screen
    func randomX(maxX: Int) -> CGFloat {
        let randomX = CGFloat(Int(arc4random()) % maxX)
        return randomX
    }
    
    // Removes all pending actions, children, or anything currently running
    func clearAll() {
        self.removeAllActions()
        self.removeAllChildren()
    }
    
}

class SKSpriteArray {
    var mainSprite : SKSpriteNode?
    var mainSpritePosition : CGPoint? {
        didSet {
            updatePositions()
        }
    }
    var children = [SKNode]()
    func updatePositions() {
        mainSprite?.position = mainSpritePosition!
        var prevAdd = 70
        for child in children {
            child.position = mainSpritePosition!
            child.position.y = child.position.y + CGFloat(prevAdd)
            prevAdd += 17
        }
    }
}

enum Stage {
    case welcome
    case catInstructions
    case cat
    case meInstructions
    case me
    case rollInstructions
    case roll
    case done
}


// Generate the frame and the scene
let frame = CGRect(x: 0, y: 0, width: 1024, height: 786)
let scene = Scene(size: frame.size)
scene.scaleMode = .aspectFit

// Display on the playground assistant editor
let view = SKView(frame: frame)
view.ignoresSiblingOrder = true
view.showsFPS = false
view.showsNodeCount = false
view.presentScene(scene)
PlaygroundPage.current.liveView = view

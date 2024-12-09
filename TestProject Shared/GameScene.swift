import SpriteKit

class GameScene: SKScene {
    var player: SKSpriteNode!
    var bulletSpeed: CGFloat = 600
    var enemySpawnRate: TimeInterval = 2.0
    
    override func didMove(to view: SKView) {
        setupPlayer()
        spawnEnemies()
    }
    
    func setupPlayer() {
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: size.width / 2, y: 100)
        addChild(player)
    }
    
    func fireBullet(at position: CGPoint) {
        let bullet = SKSpriteNode(color: .yellow, size: CGSize(width: 10, height: 30))
        bullet.position = player.position
        addChild(bullet)
        
        let moveAction = SKAction.move(to: CGPoint(x: position.x, y: size.height + bullet.size.height), duration: TimeInterval(size.height / bulletSpeed))
        let removeAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func spawnEnemies() {
        let spawn = SKAction.run { [weak self] in
            self?.createEnemy()
        }
        let wait = SKAction.wait(forDuration: enemySpawnRate)
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence))
    }
    
    func createEnemy() {
        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
        let xPosition = CGFloat.random(in: 0...size.width)
        enemy.position = CGPoint(x: xPosition, y: size.height)
        addChild(enemy)
        
        let moveAction = SKAction.move(to: CGPoint(x: xPosition, y: -enemy.size.height), duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkCollisions()
    }
    
    func checkCollisions() {
        enumerateChildNodes(withName: "*") { node, _ in
            if let enemy = node as? SKSpriteNode, enemy.color == .red {
                self.enumerateChildNodes(withName: "*") { bulletNode, _ in
                    if let bullet = bulletNode as? SKSpriteNode, bullet.color == .yellow {
                        if enemy.frame.intersects(bullet.frame) {
                            enemy.removeFromParent()
                            bullet.removeFromParent()
                        }
                    }
                }
            }
        }
    }
}

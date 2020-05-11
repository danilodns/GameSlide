//
//  GameAPI.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-04.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import Foundation
import UIKit

class GameAPI {
    
    var listOfBlocks: [BlockGame] = []
    
    var fullImage: UIImage!
    let originalImage: UIImage
    var blockHeight = 0
    var blockWidth = 0
    let rows: Int
    let columns: Int
    var emptyPosition = 0
    
    init(image: UIImage, rows: Int, cols: Int) {
        self.originalImage = image
        self.rows = rows
        self.columns = cols
    }
    /// Start the game
    /// Resize the image, split in blocks and randomize
    /// - Parameters:
    ///     - imageViewSize: Maximum size for the image
    /// - Returns: List of small images randomized
    func startGame(imageViewSize: CGSize) -> [BlockGame] {
        resizingImg(size: imageViewSize)
        repeat {
            randomizeBlock()
        } while !isSolvable()
        return listOfBlocks
    }
    
    /// Rotate the game
    /// Resize the image, split in blocks and keep the same position
    /// - Parameters:
    ///     - size: Maximum size for the image
    /// - Returns: List of small images
    func rotateGame(size: CGSize) -> [BlockGame] {
        resizingImg(true, size: size)
        return listOfBlocks
    }
    
    /// Move the block
    /// Check if that block can move and change position with the empty space
    /// - Parameters:
    ///     - position: Current position of the block which tries to move
    func moveBlock(position: Int) {
        if checkIfCanMove(blockPosition: position) {
            guard let blockView = listOfBlocks.filter({$0.currentPosition == position}).first else {
                return
            }
            SoundsManager.shared.play(sound: .move_block)
            let tempLoc = emptyPosition
            
            let emptyPoint = getPointFromPosition(position: emptyPosition)
            
            emptyPosition = position
            blockView.currentPosition = tempLoc
            UIView.animate(withDuration: 0.4) {
                blockView.frame = CGRect(x: emptyPoint.x, y: emptyPoint.y, width: CGFloat(self.blockWidth), height: CGFloat(self.blockHeight))
            }
        } else {
            
        }
    }
    
    /// Check if the game is over
    /// Chec if all blocks are in the final positon
    /// - Returns: True if it's over
    func checkWin() -> Bool{
        var finished = true
        for block in listOfBlocks {
            if block.currentPosition != block.finalPosition {
                finished = false
            }
        }
        return finished
    }
    
    /// Check if the block can move
    ///
    /// - Parameters:
    ///     - blockPosition: Current position of the block
    /// - Returns: True if it's adjacent of the empty space
    private func checkIfCanMove(blockPosition: Int) -> Bool {
        if (blockPosition / columns == emptyPosition / columns) {
            if (blockPosition == emptyPosition + 1 || blockPosition == emptyPosition - 1) {
                return true
            }
        } else if blockPosition - emptyPosition == columns || emptyPosition - blockPosition == columns {
            return true
        }
        return false
    }
    
    /// Get origin point of the specific block position
    ///
    /// - Parameters:
    ///     - position: Position of the block
    /// - Returns: Origin point of the block
    private func getPointFromPosition(position: Int) -> CGPoint {
        var point = CGPoint()
        point.y =  CGFloat(blockHeight * (position / columns))
        point.x = CGFloat(blockWidth * (position % columns))
        
        return point
    }
    
    private func splitImage(_ keepPosition: Bool = false) {
        let width: CGFloat
        let height: CGFloat
        
        switch fullImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = fullImage.size.height
            height = fullImage.size.width
        default:
            width = fullImage.size.width
            height = fullImage.size.height
        }
        
        blockHeight = Int((height / CGFloat(rows)).rounded())
        blockWidth = Int((width / CGFloat(columns)).rounded())
        
        var blockGames: [BlockGame] = []
        var position = 0
        blockGames.reserveCapacity(rows * columns)
        guard let cgImage = fullImage.cgImage else { return }
        (0..<rows).forEach { row in
            (0..<columns).forEach { column in
                if column == (columns - 1) && row == (rows - 1){
                    return
                }
                
                if row == rows-1 && height.truncatingRemainder(dividingBy: CGFloat(rows)) != 0 {
                    blockHeight = Int(height - height / CGFloat(rows) * (CGFloat(rows)-1))
                }
                if column == columns-1 && width.truncatingRemainder(dividingBy: CGFloat(columns)) != 0 {
                    blockWidth = Int(width - (width / CGFloat(columns) * (CGFloat(columns)-1)))
                }
                let origin = CGPoint(x: column * blockWidth, y:  row * blockHeight)
                let size = CGSize(width: blockWidth, height: blockHeight)
                
                if let image = cgImage.cropping(to: CGRect(origin: origin, size: size)) {
                    let block = BlockGame(finalPosition: position, image: UIImage(cgImage: image, scale: fullImage.scale, orientation: fullImage.imageOrientation))
                    if keepPosition {
                        block.currentPosition = listOfBlocks.filter({$0.finalPosition == position}).first!.currentPosition
                        let point = getPointFromPosition(position: block.currentPosition)
                        block.frame = CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
                        block.isUserInteractionEnabled = true
                    }
                    blockGames.append(block)
                    position += 1
                }
            }
        }
        self.listOfBlocks = blockGames
    }
    
    private func resizingImg(_ keepPositions: Bool = false, size: CGSize) {
        fullImage = originalImage
        let originalSize = originalImage.size
        let wRatio: CGFloat = size.width / originalSize.width
        let hRatio: CGFloat  = size.height / originalSize.height
        
        var newSize: CGSize
        if(wRatio > hRatio) {
            newSize = CGSize(width: originalSize.width * hRatio, height: originalSize.height * hRatio)
        } else {
            newSize = CGSize(width: originalSize.width * wRatio,  height: originalSize.height * wRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        fullImage.draw(in: rect)
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            fullImage = newImage
        }
        splitImage(keepPositions)
    }
    
    private func randomizeBlock() {
        var numbers = Array(0...listOfBlocks.count)
        
        listOfBlocks.forEach { (blockGame) in
            let pos = Int (arc4random()) % numbers.count
            blockGame.currentPosition = numbers[pos]
            
            let blockPoint = getPointFromPosition(position: blockGame.currentPosition)
            
            blockGame.frame = CGRect(x: blockPoint.x, y: blockPoint.y, width: CGFloat(blockWidth), height: CGFloat(blockHeight))
            blockGame.isUserInteractionEnabled = true
            
            numbers.remove(at: pos)
        }
        emptyPosition = numbers[0]
        listOfBlocks.sort { (t1, t2) -> Bool in
            t1.currentPosition < t2.currentPosition
        }
    }
    /// Calculate if the puzzle is solvable
    ///
    /// - Note:
    ///         - It's solvable when the number of blocks and inversion are even or;
    ///         - if the number of blocks are odds the distance of the empty space from the bottom of the puzzle must have different Parity from the inversion
    ///
    /// - Returns: True if the puzzle can be solved
    private func isSolvable() -> Bool {
        var isSolvable = false
        if listOfBlocks.count % 2 == 0 && calculateInversion() % 2 == 0{
            isSolvable = true
        } else if listOfBlocks.count % 2 != 0 {
            let emptyFromBottom: Int = rows - (emptyPosition / rows)
            if (emptyFromBottom % 2 == 0 && calculateInversion() % 2 != 0) ||  (emptyFromBottom % 2 != 0 && calculateInversion() % 2 == 0 ) {
                isSolvable = true
            } else {
                isSolvable = false
            }
        }
        return isSolvable
    }
    
    /// Calculate the inversion of the puzzle
    ///
    /// - Returns: Number of inversions of the puzzle
    private func calculateInversion () -> Int {
        var numberOfInversion = 0
        
        for i in 0..<listOfBlocks.count {
            for j in (i + 1)..<listOfBlocks.count {
                if listOfBlocks[i].finalPosition > listOfBlocks[j].finalPosition {
                    numberOfInversion += 1
                }
            }
        }
        return numberOfInversion
    }
}

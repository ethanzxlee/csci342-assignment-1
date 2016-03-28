//
//  GameModel.swift
//  Match The Tiles
//
//  Created by Zhe Xian Lee on 28/03/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit
import GameplayKit

///
protocol GameModelDelegate {
    func gameDidReset(gameModel: GameModel)
    func gameDidComplete(gameModel: GameModel)
    func didMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int)
    func didFailToMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int)
    func scoreDidUpdate(gameModel: GameModel, newScore: Int)
}

/// Handles the game state
class GameModel : CustomStringConvertible {
    
    /**
     This structure represents the state for one single tile
     */
    struct TileData : CustomStringConvertible {
        var imageIdentifier : Int?
        var image : UIImage?
        
        var description : String {
            get {
                return "\(imageIdentifier)"
            }
        }
    }
    
    /// Index of last tile tapped
    var lastTapped : Int?
    
    /// Index of second last tile tapped
    var secondLastTapped : Int?
    
    /// Holds the tile data
    var tileData : [TileData]?
    
    /// Indicates whether it's the first or second turn
    var isSecondTurn : Bool?
    
    /// Counter for the number of matched tiles
    var matchedTileCount : Int?
    
    /// Holds the game's score
    var gameScore : Int?
    
    /// Holds the number of tiles
    var tileCount: Int
    
    /// Holds the provided images
    var providedImages : [UIImage?]
    
    /// Holds the delegate
    var delegate : GameModelDelegate?
    
    var matchCount : Int?
    
    let MATCH_SCORE = 200
    
    let FAIL_SCORE = -100
    
    /**
        Initialse a game model with provided number of tiles and their images
        It will fail if the number of tiles is no even
     
        - Parameters:
            - tileCount: The number of tiles that you plan to have in your game (must be even)
            - images: The array of images you with to use in the game
    */
    init?(tileCount: Int, images: [UIImage?], delegate: GameModelDelegate) {
        self.tileCount = tileCount
        self.providedImages = [UIImage]()
        self.providedImages.appendContentsOf(images)
        
        // Check if number of tiles is even
        if (self.tileCount % 2 != 0) {
            return nil
        }
        
        self.delegate = delegate
        self.reset();
    }
    
    
    /**
        Responsibles for setting up the game to initial state
    */
    func reset() {
        // Resets all game state variables
        self.lastTapped = nil
        self.secondLastTapped = nil
        self.isSecondTurn = nil
        self.matchedTileCount = 0
        self.gameScore = 0
        self.matchCount = 0
        self.tileData = [TileData]()
        
        // Populates tileData
        for index in 0..<(tileCount/2) {
            self.tileData?.append(
                TileData(imageIdentifier: index % providedImages.count, image: providedImages[index % providedImages.count])
            )
            self.tileData?.append(
                TileData(imageIdentifier: index % providedImages.count, image: providedImages[index % providedImages.count])
            )
        }
        
        // Shuffle tileData by using funtions in GameplayKit
        self.tileData = GKRandomSource().arrayByShufflingObjectsInArray(Array(0..<self.tileData!.count)).map{
            self.tileData![$0 as! Int]
        }
        
        self.delegate?.gameDidReset(self)
        self.delegate?.scoreDidUpdate(self, newScore: self.gameScore!)
    }
    
    
    /**
        Informs the model as to which tile was tapped
        
        - Parameters:
            - index: Index of the tile
     */
    func pushTileIndex(index: Int) {
        if (self.lastTapped == nil) {
            if (index < tileData!.count) {
                self.lastTapped = index
            }
        }
        else if (index != self.lastTapped){
            self.secondLastTapped = lastTapped
            self.lastTapped = index
            
            if (index < tileData!.count) {
                let secondLastTappedTileData = self.tileData![secondLastTapped!]
                let lastTappedTileData = self.tileData![lastTapped!]
                
                if (secondLastTappedTileData.imageIdentifier! == lastTappedTileData.imageIdentifier!) {
                    self.delegate?.didMatchTile(self, tileIndex: self.lastTapped!, previousTileIndex: self.secondLastTapped!)
                    
                    self.gameScore? += MATCH_SCORE
                    self.delegate?.scoreDidUpdate(self, newScore: self.gameScore!)
                    
                    self.matchCount? += 1
                    if (self.matchCount >= self.tileCount / 2) {
                        self.delegate?.gameDidComplete(self)
                    }
                }
                else {
                    self.delegate?.didFailToMatchTile(self, tileIndex: self.lastTapped!, previousTileIndex: self.secondLastTapped!)
                    
                    self.gameScore? += FAIL_SCORE
                    self.delegate?.scoreDidUpdate(self, newScore: self.gameScore!)
                }
                
                self.secondLastTapped = nil
                self.lastTapped = nil
            }
        }
        else {
            self.lastTapped = nil
        }
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description : String {
        get {
            var desc = ""
            for tile in tileData! {
                desc += "\(tile.description) "
            }
            return desc
        }
    }
}

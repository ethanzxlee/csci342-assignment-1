//
//  ViewController.swift
//  Match The Tiles
//
//  Created by Zhe Xian Lee on 28/03/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TileViewDelegate, GameModelDelegate {
    
    let tileImages = [
        UIImage(named: "baldhill"),
        UIImage(named: "lake"),
        UIImage(named: "cathedral")
    ]
    
    var gameModel : GameModel?
    var tileCount : Int?
    var tileViews : [TileView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Count the number of tiles
        self.tileCount = 0
        for subviewLevel0 in self.view.subviews {
            if let mainStackView = subviewLevel0 as? UIStackView {
                for subviewLevel1 in mainStackView.subviews {
                    if let childStackView = subviewLevel1 as? UIStackView {
                        tileCount? += childStackView.subviews.count
                    }
                }
            }
        }
        
        // Retrieve the tileviews
        self.tileViews = [TileView]()
        for index in 1...self.tileCount! {
            if let _tileView = self.view.viewWithTag(index) as? TileView {
                self.tileViews?.append(_tileView)
            }
        }
        
        // Initialise gameModel
        self.gameModel = GameModel(tileCount: self.tileCount!, images: tileImages, delegate: self)        
    }
    
    // MARK:- IBActions & IBOutlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGameButton(sender: AnyObject) {
        self.gameModel?.reset()
    }
    
    // MARK:- TileViewDelegate
    
    func didSelectTile(tileView: TileView) {
        if let tappedIndex = tileViews?.indexOf(tileView) {
            self.gameModel?.pushTileIndex(tappedIndex)
        }
    }

    
    // MARK:- GameModelDelegate
    
    func gameDidReset(gameModel: GameModel) {
        // Set the imageview on the tile according to the gameModel
        for index in 0..<self.tileCount! {
            self.tileViews?[index].tileImage = gameModel.tileData?[index].image
            self.tileViews?[index].delegate = self
            self.tileViews?[index].resetTile()
        }
    }
    
    func gameDidComplete(gameModel: GameModel) {
        let alert = UIAlertController(title: "Game Over", message: "Score: \(gameModel.gameScore!)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .Default, handler: { (_) -> Void in
            gameModel.reset()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func didMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int) {
        self.tileViews?[tileIndex].hideTile(1)
        self.tileViews?[previousTileIndex].hideTile(1)
    }
    
    func didFailToMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int) {
        self.tileViews?[tileIndex].coverImage(1)
        self.tileViews?[previousTileIndex].coverImage(1)
    }
    
    func scoreDidUpdate(gameModel: GameModel, newScore: Int) {
        self.scoreLabel.text = "Score: \(newScore)"
    }

}


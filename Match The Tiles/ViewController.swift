//
//  ViewController.swift
//  Match The Tiles
//
//  Created by Zhe Xian Lee on 28/03/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let a = GameModel(tileCount: 12, images: [UIImage(named: "baldhill")!, UIImage(named: "lake")!, UIImage(named: "question")!])
        print(a?.description)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


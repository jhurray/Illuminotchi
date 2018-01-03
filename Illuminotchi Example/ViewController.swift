//
//  ViewController.swift
//  Illuminotchi Example
//
//  Created by Jeff Hurray on 12/20/17.
//  Copyright © 2017 Jeff Hurray. All rights reserved.
//

import UIKit
import Illuminotchi

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Illuminotchi.theyreWatchingYourScreenshots()
    }
}


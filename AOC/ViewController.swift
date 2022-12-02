//
//  ViewController.swift
//  AOC
//
//  Created by mfaani on 12/1/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let day = Day2()
        print(day.solveA())
        print(day.solveB())
    }
}


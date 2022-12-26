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
        let day = Y2022.Day15B()
        print("final:", day.solve())
        
    }
}

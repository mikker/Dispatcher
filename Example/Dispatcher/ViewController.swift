//
//  ViewController.swift
//  Dispatcher
//
//  Created by Mikkel Malmberg on 06/21/2015.
//  Copyright (c) 06/21/2015 Mikkel Malmberg. All rights reserved.
//

import UIKit
import Dispatcher

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Dispatcher.instance.register { (payload) -> Void in
            debugPrint("recieved \(payload)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dispatch(sender: AnyObject?) {
        Dispatcher.instance.dispatch(["message": "Here I am!"])
    }
    
}


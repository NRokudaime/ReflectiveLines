//
//  ViewController.swift
//  Test22
//
//  Created by NRokudaime on 04.02.17.
//  Copyright © 2017 NRokudaime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tapView: TappedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapView = view as! TappedView
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        tapView.tapPoint = touch.location(in: tapView)
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapView.tapPoint = nil
    }
    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tapView.tapPoint = nil
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

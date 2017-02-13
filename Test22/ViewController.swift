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
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapView.removeTouches(touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapView.removeTouches(touches: touches)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapView.setTouches(touches: touches)
    }
}

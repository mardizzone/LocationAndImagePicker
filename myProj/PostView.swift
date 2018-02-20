//
//  PostView.swift
//  Dolo
//
//  Created by Michael Ardizzone on 2/17/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import UIKit

class PostView: UIView {
    
    @IBOutlet var postButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var postDelegate : PostViewDelegate?

    @IBAction func photoPressed(_ sender: Any) {
        print("photo")
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        print("cancel")
    }
    
    @IBAction func postPressed(_ sender: Any) {
        print("post")
    }
    
    
}

//
//  ViewController.swift
//  SWIFTCocoaPods
//
//  Created by 乐天 on 2017/10/7.
//  Copyright © 2017年 乐天. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.yellow;
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        RCAlertView.alert(withTitle: "提示", message: "abner是好人", orAttributedMessage: nil, buttonTitleArray: ["相机","相册"], buttonColorArray: [UIColor.red,UIColor.red]) { (buttonIndex, buttonTitle) in
            if buttonIndex == 0
            {
                print(buttonTitle ?? "")
            }
            else if buttonIndex == 1
            {
                print(buttonTitle ?? "")
            }
            else
            {
                print(buttonTitle ?? "")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


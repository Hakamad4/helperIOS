//
//  Alerts.swift
//  Helper
//
//  Created by Edson Hakamada on 30/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit

class MyAlerts{
    static func alertMessage(usermessage : String, view :UIViewController){
        let myAlert = UIAlertController(title:"Alerta ⚠️", message: usermessage
            , preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        view.present(myAlert, animated: true, completion: nil);
    }
    static func opsMessage(usermessage : String, view :UIViewController){
        let myAlert = UIAlertController(title:"Ops...😅", message: usermessage
            , preferredStyle: UIAlertControllerStyle.alert);
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) -> Void in
            exit(0)
        }))
        view.present(myAlert, animated: true, completion: nil);
    }
    
}

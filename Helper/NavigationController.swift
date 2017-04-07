//
//  NavigationController.swift
//  Helper
//
//  Created by Edson Hakamada on 31/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var pessoa : Pessoa?
    var nextScene : InfoVC?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("Meu nome e goku 2")
        nextScene?.pessoa = self.pessoa
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoPrepare" {
                let nextScene = segue.destination as! InfoVC
                print("oi eu sou o goku 33")
                nextScene.pessoa = self.pessoa
        }
    }
}

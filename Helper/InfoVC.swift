//
//  InfoVC.swift
//  Helper
//
//  Created by Edson Hakamada on 30/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit

class InfoVC: UINavigationController {
    
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelPago: UILabel!

    
    
    var pessoa : Pessoa?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pessoa != nil {
        labelNome.text = pessoa?.nome
        labelData.text = pessoa?.data?.replacingOccurrences(of: ".", with: "/")
        labelPago.text = "R$ \(String(describing: pessoa?.pagamento))!"
        }
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

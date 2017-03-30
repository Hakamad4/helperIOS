//
//  ViewController.swift
//  Helper
//
//  Created by Edson Hakamada on 29/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit
import Firebase
struct pessoa {
    let nome : String!
    let pagamento : String!
}

class ViewController: UIViewController, UITextFieldDelegate ,UITableViewDataSource{
    
    let pessoas : [pessoa]
    
    @IBOutlet weak var filedNome: UITextField!
    @IBOutlet weak var fieldPag: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var myList:[String] = []
    
    var ref :FIRDatabaseReference?
    
    var handle : FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        handle = ref?.child("Nomes").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            let nome = snapshot.value("nome")
            let pag = snapshot.value("pagamento")
            
            self.pessoas.insert(struct, at: <#T##Int#>)
        })
        filedNome.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        let nome = filedNome.text
        let pag = fieldPag.text
        let cad : [String : AnyObject] = ["nome":nome as AnyObject, "pagamento":pag as AnyObject]
        if nome != ""{
            ref?.child("Nomes").childByAutoId().setValue(cad)
            
            filedNome.text = ""
            fieldPag.text = ""
        }
        
    }
    
    
    //config tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pessoas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    
    
    //config textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    filedNome.resignFirstResponder()
    return (true)
    }
}


//
//  ViewController.swift
//  Helper
//
//  Created by Edson Hakamada on 29/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate ,UITableViewDataSource{

    
    @IBOutlet weak var filedNome: UITextField!
    @IBOutlet weak var fieldPag: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref :FIRDatabaseReference?
    var handle : UInt?
    
    var pessoas = [Pessoa]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        buscar()
        filedNome.endEditing(true)
        fieldPag.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let nome = filedNome.text
        let pag = fieldPag.text?.replacingOccurrences(of: ",", with: ".")
        let cad : [String : AnyObject] = ["nome":nome as AnyObject, "pagamento":pag as AnyObject]
        if nome != ""{
            ref?.child("Pessoa").childByAutoId().setValue(cad)
            
            filedNome.text = ""
            fieldPag.text = ""
        }
        
    }
    
    //aqui
    func buscar(){
        handle = ref?.child("Pessoa").observe(.childAdded, with: {(snapshot) in
            if let dic = snapshot.value as? [String : AnyObject]{
                let pessoa = Pessoa()
                
                print(dic)
                
                pessoa.setValuesForKeys(dic)
                self.pessoas.append(pessoa)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
        
    }
    
    //config tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pessoas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.nome?.text = pessoas[indexPath.row].nome
        cell.pag.text = "R$" + pessoas[indexPath.row].pagamento!
        return cell
    }
    //ate aqui
    
    //config textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    filedNome.resignFirstResponder()
    return (true)
    }
}


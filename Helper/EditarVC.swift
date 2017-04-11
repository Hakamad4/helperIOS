//
//  EditarVC.swift
//  Helper
//
//  Created by Edson Hakamada on 08/04/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit
import Firebase

class EditarVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var fieldNome: UITextField!
    @IBOutlet weak var fieldValor: UITextField!
    
    var ref : FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldNome.delegate = self
        fieldNome.text = pes?.nome
        fieldNome.tag = 0
        fieldNome.returnKeyType = UIReturnKeyType.next
        
        fieldValor.delegate = self
        fieldValor.text = String((pes?.pagamento)!)
        fieldValor.tag = 1
        fieldValor.returnKeyType = UIReturnKeyType.next
        
        //firebase reference
        ref = FIRDatabase.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    @IBAction func editAction(_ sender: Any) {
        var nome = fieldNome.text
        let cash = fieldValor.text
        nome = Util.removeSpecialCharsFromString(text: nome!)
        if nome == ""{
            MyAlerts.alertMessage(usermessage: "Nome Invalido, tente novamente", view: self)
        }else if cash == ""{
            MyAlerts.alertMessage(usermessage: "Valor Invalido, tente novamente", view: self)
        }else{
            let novaP = pes
            if nome?.characters.last! == " "{
                nome?.characters.removeLast()
            }
            novaP?.nome = nome
            novaP?.pagamento = String(format: "%.2f",Double((cash?.replacingOccurrences(of: ",", with: "."))!)!)
            let edt : [String : AnyObject] = ["id":novaP?.id as AnyObject, "nome":novaP!.nome as AnyObject, "pagamento":novaP?.pagamento as AnyObject, "data":novaP?.data as AnyObject]
            ref?.child("Pessoa").child((novaP?.id)!).setValue(edt)
        }
    }
    
    
}

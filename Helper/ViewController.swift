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

class ViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var filedNome: UITextField!
    @IBOutlet weak var fieldPag: UITextField!
    
    
    var ref :FIRDatabaseReference?
    var handle : UInt?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        filedNome.delegate = self
        filedNome.tag = 0
        filedNome.returnKeyType = UIReturnKeyType.next
        
        fieldPag.delegate = self
        fieldPag.tag = 1
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        save()
    }
    public func save(){
        var nome = filedNome.text
        let cash = fieldPag.text
        nome = Util.removeSpecialCharsFromString(text: nome!)
        
        if nome == ""{
            MyAlerts.alertMessage(usermessage: "Nome Invalido, tente novamente", view: self)
            return
        }else if cash == "" {
            MyAlerts.alertMessage(usermessage: "Valor Invalido, tente novamente", view: self)
            return
        }else{
            //formatando Pagamento
            let pagForm : String?
            if cash != "0" {
                pagForm = String(format: "%.2f",Double((cash?.replacingOccurrences(of: ",", with: "."))!)!)
            }else {
                pagForm = "0.00"
            }
            
            if nome?.characters.last! == " " {
                nome?.characters.removeLast()
            }
            
            let p = Pessoa()
            p.nome = nome
            p.pagamento = pagForm
            //gerando id
            p.id = ref?.child("Pessos").childByAutoId().key
            //Formatando Data
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/YYYY HH:MM"
            //Gerando data de entrada
            p.data = dateFormat.string(from: Date())
            //Gerando o codigo
            p.codigo = " ";
            //Gerando o pessoa
            let pess : [String : AnyObject] = ["id":p.id as AnyObject, "nome":p.nome as AnyObject, "pagamento":p.pagamento as AnyObject, "data":p.data as AnyObject, "codigo":p.codigo as AnyObject]
            //Instancia de pesso
            
            ref?.child("Pessoa").child((p.id)!).setValue(pess)
            
            filedNome.text = ""
            fieldPag.text = ""
        }
    }
    
    //config textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 5
        guard let text = fieldPag.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
}


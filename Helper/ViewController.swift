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
    
    var pessoas = [Pessoa]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        filedNome.delegate = self
        filedNome.tag = 0
        filedNome.returnKeyType = UIReturnKeyType.next
        
        fieldPag.delegate = self
        fieldPag.tag = 1
        fieldPag.returnKeyType = UIReturnKeyType.next
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
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
            
            
            //gerando id
            let key = ref?.child("Pessos").childByAutoId().key
            //Formatando Data
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/YYYY HH:MM"
            let dataResult = dateFormat.string(from: Date())
            let cad : [String : AnyObject] = ["id":key as AnyObject, "nome":nome as AnyObject, "pagamento":pagForm as AnyObject, "data":dataResult as AnyObject]
            
            
            ref?.child("Pessoa").child(key!).setValue(cad)
            
            filedNome.text = ""
            fieldPag.text = ""
        }
        //TODO: limpar aqui
        
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


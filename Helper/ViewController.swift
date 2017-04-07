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
    @IBOutlet weak var fieldData: UITextField!
    
    var ref :FIRDatabaseReference?
    var handle : UInt?
    
    var pessoas = [Pessoa]()
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        filedNome.delegate = self
        fieldPag.delegate = self
        fieldData.delegate = self
        
        createDataPicker()
    }
    
    
    //config DatePicker
    func createDataPicker(){
        //formatando date
        datePicker.datePickerMode = .date
        
        //toolbal
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneItem], animated: false)
        
        fieldData.inputAccessoryView = toolbar
        fieldData.inputView = datePicker
        
        
    }
    func donePressed(){
        let dataFormatter = DateFormatter()
        dataFormatter.dateStyle = .short
        dataFormatter.timeStyle = .none
        
        fieldData.text = dataFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let nome = filedNome.text
        let pag = fieldPag.text?.replacingOccurrences(of: ",", with: ".")
        let key = ref?.child("Pessos").childByAutoId().key
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.YYYY HH:MM"
        let dataResult = dateFormat.string(from: date)
        let cad : [String : AnyObject] = ["id":key as AnyObject, "nome":nome as AnyObject, "pagamento":pag as AnyObject, "data":dataResult as AnyObject]
        if nome != ""{
            ref?.child("Pessoa").child(key!).setValue(cad)
            
            filedNome.text = ""
            fieldPag.text = ""
        }else{
            MyAlerts.alertMessage(usermessage: "Falha ao cadstrar, tente novamente", view: self)
        }
        
    }
    
    //config textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    filedNome.resignFirstResponder()
    return (true)
    }
    let limitLength = 5
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = fieldPag.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    

}


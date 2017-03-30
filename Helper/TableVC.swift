//
//  TableVC.swift
//  Helper
//
//  Created by Edson Hakamada on 30/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TableVC: UIViewController ,UITextFieldDelegate ,UITableViewDataSource{
    
    var pessoas = [Pessoa]()
    var ref :FIRDatabaseReference?
    var handle : UInt?
    var grana = 0.0
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var totalPessoas: UILabel!
    @IBOutlet weak var totalGrana: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//         self.clearsSelectionOnViewWillAppear = false
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        ref = FIRDatabase.database().reference()
        buscar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pessoas.count
    }
    
    func buscar(){
        handle = ref?.child("Pessoa").observe(.childAdded, with: {(snapshot) in
            if let dic = snapshot.value as? [String : AnyObject]{
                let pessoa = Pessoa()
                
//                print(dic)
                
                pessoa.setValuesForKeys(dic)
                self.pessoas.append(pessoa)
                let pago = pessoa.pagamento
                let din = Double(pago!)!
                print(pago!)
                self.grana += din
                print("Grana = ")
                print(self.grana)
                self.totalGrana.text = "R$" + String(self.grana)
                DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                })
            
            }
        })
        totalPessoas.text = String(pessoas.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.nome?.text = pessoas[indexPath.row].nome
        let pago = pessoas[indexPath.row].pagamento
        cell.pag.text = "R$" + pago!
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

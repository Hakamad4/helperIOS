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

var pes : Pessoa?
var totalItens = 0
var totalCash = "R$ 0.00"
var myIndex = 0

class TableVC: UIViewController ,UITextFieldDelegate,UITableViewDataSource , UITableViewDelegate{
    
    var pessoas : [Pessoa] = []
    var filterPessoas : [Pessoa] = []
    
    var ref :FIRDatabaseReference?
    var handle : UInt?
    var grana = 0.0
    var detailViewController: InfoVC?
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let refresh = UIRefreshControl()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var totalPessoas: UILabel!
    @IBOutlet weak var totalGrana: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? InfoVC
//        }
        
        ref = FIRDatabase.database().reference()
        buscar()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        
        definesPresentationContext = true
        myTableView.tableHeaderView = searchController.searchBar
        myTableView.refreshControl = self.refresh
        self.refresh.addTarget(self, action: #selector(TableVC.didRefreshList), for: .valueChanged)
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didRefreshList(){
        buscar()
        self.refresh.endRefreshing()
    }
    
    func filtrar(text:String ,scope : String = "All"){
        filterPessoas = pessoas.filter{ pessoa in
            return (pessoa.nome?.lowercased().contains(text.lowercased()))!
        }
        myTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterPessoas.count
        }
        return pessoas.count
    }
    
    func buscar(){
        pessoas.removeAll()
        grana = 0.0
        handle = ref?.child("Pessoa").observe(.childAdded, with: {(snapshot) in
            if let dic = snapshot.value as? [String : AnyObject]{
                let pessoa = Pessoa()
                
                //print(dic)
                
                pessoa.setValuesForKeys(dic)
                self.pessoas.append(pessoa)
                self.pessoas = self.pessoas.sorted{$0.nome! < $1.nome!}
                let pago = pessoa.pagamento
                let din = Double(pago!)!
                self.grana += din
                self.totalGrana.text = "R$" + String(format:"%.2f",self.grana)
                self.totalPessoas.text = String(self.pessoas.count)
                
                DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                })
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let p : Pessoa
        if searchController.isActive && searchController.searchBar.text != "" {
            p = (filterPessoas[indexPath.row])
        }else{
            p = pessoas[indexPath.row]
        }
        cell.nome?.text = p.nome
        let pago = p.pagamento
        cell.pag.text = "R$" + pago!
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let p = pessoas[indexPath.row]
        if editingStyle == .delete {
            
            // Delete the row from the data source
            ref?.child("Pessoa").child(p.id!).removeValue(completionBlock: {(Error,ref)in
                if Error != nil{
                    MyAlerts.alertMessage(usermessage:"Erro ao deletar.",view: self)
                    print(Error.debugDescription)
                    return
                }
                
                self.pessoas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.grana -= Double(p.pagamento!)!
                self.totalGrana.text = "R$" + String(self.grana)
                self.totalPessoas.text = String(self.pessoas.count)
                
            }
                
        )}
    }
    
    func tableView(tableView: UITableView, editActionsForRowIndexPath indexPath:NSIndexPath) -> [AnyObject]?{
        let shareAction = UITableViewRowAction(style: .normal, title: "Deletar", handler: {(action: UITableViewRowAction!,indexPath) -> Void in
            let firstActivityItem = self.pessoas[indexPath.row].nome
            
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
            
            
        })
        shareAction.backgroundColor = UIColor.darkGray
        return [shareAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            pes = self.filterPessoas[indexPath.row]
        }else{
            pes = self.pessoas[indexPath.row]
        }
        totalItens = pessoas.count
        totalCash = totalGrana.text!
        buscar()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension TableVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filtrar(text: searchController.searchBar.text!)
    }
}

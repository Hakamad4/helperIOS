//
//  InfoVC.swift
//  Helper
//
//  Created by Edson Hakamada on 30/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelPago: UILabel!
    @IBOutlet weak var imageCode: UIImageView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    //Bottom bar
    @IBOutlet weak var labelItensTotal: UILabel!
    @IBOutlet weak var labelCashTotal: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelItensTotal.text = String(totalItens)
        labelCashTotal.text = totalCash
        
        labelNome.text = pes?.nome
        labelData.text = pes?.data?.replacingOccurrences(of: ".", with: "/")
        labelPago.text = "R$ " + String((pes?.pagamento)!)
        
        imageCode.image = gerarQRCodePorString(string: (pes?.id)!)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gerarQRCodePorString(string : String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        let output = filter?.outputImage?.applying(transform)
        if output != nil {
            return UIImage(ciImage: output!)
        }else{
            //Alerta
            MyAlerts.alertMessage(usermessage: "Insira algo a ser convertido em codigo QR", view: self)
        }
        return nil
    }
    func gerarCodBarraPorString(string : String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        let output = filter?.outputImage?.applying(transform)
        if output != nil {
            return UIImage(ciImage: output!)
        }else{
            //Alerta
            MyAlerts.alertMessage(usermessage: "Insira algo a ser convertido em codigo de barra", view: self)
        }
        return nil
    }

    
    
    @IBAction func changeCode(_ sender: Any) {
        let xImage = imageCode.frame.origin.x
        print(xImage)
        if segControl.selectedSegmentIndex == 0{
            imageCode.frame = CGRect.init(x: xImage + 25, y: imageCode.frame.origin.y, width: 150, height: 150);
            imageCode.image = gerarQRCodePorString(string: (pes?.id)!)
        }
        
        if segControl.selectedSegmentIndex == 1{
            imageCode.frame = CGRect.init(x: xImage - 25, y: imageCode.frame.origin.y, width: 200, height: 150);
            imageCode.image = gerarCodBarraPorString(string: (pes?.id)!)
        }
    }
    
    
    
    
}

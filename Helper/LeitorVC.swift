//
//  LeitorVC.swift
//  Helper
//
//  Created by Edson Hakamada on 09/04/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class LeitorVC: UIViewController , AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var messageLabel: UILabel!
    var handle : UInt?
    //MARK: Session Management
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    //Firebase reference
    var ref :FIRDatabaseReference?
    //Codigos suportados
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    //Readed Code
    var code : String?
    
    let pessoa = Pessoa()
    var finded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        //Instancia do AVCaptureDevice, AVMediatype como parametro
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Pegando a instancia do AVCaptureDeviceInput e usando nosso captureDevice como parametro
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Inicializando o obj captureSession.
            captureSession = AVCaptureSession()
            // Setanto o input da capture session.
            captureSession?.addInput(input)
            
            // Inicializando o obj AVCaptureMetadataOutput e setanto o output device da capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Setando o delegate e usando o dispatch queue default para executar
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            
            // Detetectando todas os codigos suportados
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Inicializando o video preview layer e add como uma sublayer a view layer viewPreview.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Ligagando a camera para captura
            captureSession?.startRunning()
            
            // Mover a messageLabel ao top view
            view.bringSubview(toFront: messageLabel)
            
            // Inicializando QR Code Frame
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // Se ocorrer algum erro manda um msg ao usuario e manda o erro no log.
            MyAlerts.opsMessage(usermessage: "Houve algum problema ao abrir a camera. Melhor tentar mais tarde.", view: self)
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation)->AVCaptureVideoOrientation?{
        switch deviceOrientation {
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: return AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight: return AVCaptureVideoOrientation.landscapeLeft
        default: return nil
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Verificar se o metadataObjects array é nulo
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Código não encontrado."
            return
        }
        
        // Pegar metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        // Verificando se o metadataObj é suportado
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //Passando o codigo
                code = metadataObj.stringValue
                messageLabel.text = code
                buscar()
                if finded == false{
                    let myAlert = UIAlertController(title:"Codigo Não Encontrado.🔍", message: "Item escaneado não encontrado. O que deseja fazer?", preferredStyle: UIAlertControllerStyle.alert);
                    myAlert.addAction(UIAlertAction(title: "Cadastrar", style: UIAlertActionStyle.default, handler: { (action) in
                        self.cadastrarAlert()
                        return
                    }))
                    myAlert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(myAlert, animated: true, completion: nil);
                }
            }
        }
    }
    func buscar(){
        //buscando dados de "Pessoa" no firebase
        handle = ref?.child("Pessoa").observe(.childAdded, with: {(snapshot) in
            //criando um array de Pessoas
            if let dic = snapshot.value as? [String : AnyObject]{
                //print(dic)
                //Colocando o valor de cada pessoa buscada no obj pessoa
                
                self.pessoa.setValuesForKeys(dic)
                
                //caso o codigo da pessoa seja igual ao codigo escaniado
                //exibira um alerta com opçao de editar ou excluir
                if(self.pessoa.codigo == self.code){
                    
                    let myAlert = UIAlertController(title:"Codigo Encontrado.🔍", message: "Percebemos que o item \(String(describing: self.pessoa.nome)) tem o mesmo codigo encontrado. O que deseja fazer?", preferredStyle: UIAlertControllerStyle.alert);
                    myAlert.addAction(UIAlertAction(title: "Editar", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) -> Void in
                        self.editAlert()
                    }))
                    myAlert.addAction(UIAlertAction(title: "Excluir", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) -> Void in
                        let alert = UIAlertController(title:"Você tem certeza?", message: "Tem certeza que deseja excluir este item?", preferredStyle: UIAlertControllerStyle.alert);
                        alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: { (action) in
                            self.ref?.child("Pessoa").child(self.pessoa.id!).removeValue(completionBlock: {
                                (Error,ref) in
                                if Error != nil{
                                    MyAlerts.alertMessage(usermessage:"Erro ao deletar.",view: self)
                                    print(Error.debugDescription)
                                    return
                                }
                            }
                        )}))
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil);
                    }))
                    self.present(myAlert, animated: true, completion: nil);
                    self.finded = true
                    return
                    //caso não encontre o codigo escaniado na busca
                    //exbira um alerta com a opção de cadastrar ou escanear denovo
                } else {
                    self.finded = false
                }
            }
        })
    }
    func editAlert(){
        let editAlert = UIAlertController(title:"Editando 📝", message: "Insira as informações a abaixo.", preferredStyle: UIAlertControllerStyle.alert);
        
        editAlert.addTextField(configurationHandler: { (itemNome:UITextField) in
            itemNome.placeholder = "Insira o nome"
            itemNome.tag = 0
        })
        editAlert.addTextField(configurationHandler: { (itemValor:UITextField) in
            itemValor.keyboardType = UIKeyboardType.decimalPad
            itemValor.placeholder = "Insira o valor"
            itemValor.tag = 1
        })
        editAlert.addAction(UIAlertAction(title: "Editar", style: UIAlertActionStyle.default, handler: { (action) in
            var nome = editAlert.textFields?[0].text
            let cash = editAlert.textFields?[1].text
            
            nome = Util.removeSpecialCharsFromString(text: nome!)
            if nome == ""{
                MyAlerts.alertMessage(usermessage: "Nome Invalido, tente novamente", view: self)
            }else if cash == ""{
                MyAlerts.alertMessage(usermessage: "Valor Invalido, tente novamente", view: self)
            }else{
                let novaP = self.pessoa
                if nome?.characters.last! == " "{
                    nome?.characters.removeLast()
                }
                novaP.nome = nome
                novaP.pagamento = String(format: "%.2f",Double((cash?.replacingOccurrences(of: ",", with: "."))!)!)
                let edt : [String : AnyObject] = ["id":novaP.id as AnyObject, "nome":novaP.nome as AnyObject, "pagamento":novaP.pagamento as AnyObject, "data":novaP.data as AnyObject, "codigo":novaP.codigo as AnyObject]
                self.ref?.child("Pessoa").child((novaP.id)!).setValue(edt)
            }
        }))
        self.present(editAlert, animated: true, completion: nil);
    }
    func cadastrarAlert(){
        let cadAlert = UIAlertController(title:"Cadastrando 📝", message: "Insira as informações a abaixo.", preferredStyle: UIAlertControllerStyle.alert);
        cadAlert.addTextField(configurationHandler: { (itemNome:UITextField) in
            itemNome.placeholder = "Insira o nome"
            itemNome.tag = 0
        })
        cadAlert.addTextField(configurationHandler: { (itemValor:UITextField) in
            itemValor.keyboardType = UIKeyboardType.decimalPad
            itemValor.placeholder = "Insira o valor"
            itemValor.tag = 1
        })
        cadAlert.addAction(UIAlertAction(title: "Cadastrar", style: UIAlertActionStyle.default, handler: { (action) in
            var nome = cadAlert.textFields?[0].text
            let cash = cadAlert.textFields?[1].text
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
                p.id = self.ref?.child("Pessos").childByAutoId().key
                //Formatando Data
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd/MM/YYYY HH:MM"
                //Gerando data de entrada
                p.data = dateFormat.string(from: Date())
                //Gerando o codigo
                p.codigo = self.code;
                //Gerando o pessoa
                let pess : [String : AnyObject] = ["id":p.id as AnyObject, "nome":p.nome as AnyObject, "pagamento":p.pagamento as AnyObject, "data":p.data as AnyObject, "codigo":p.codigo as AnyObject]
                //Instancia de pesso
                
                self.ref?.child("Pessoa").child((p.id)!).setValue(pess)
                
            }
        }))
        cadAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(cadAlert, animated: true, completion: nil)
    }
    
}

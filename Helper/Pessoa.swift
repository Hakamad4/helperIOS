//
//  Pessoa.swift
//  Helper
//
//  Created by Edson Hakamada on 30/03/17.
//  Copyright © 2017 Erik Hakamada. All rights reserved.
//

import UIKit

class Pessoa : NSObject{
    var id : String?
    var nome : String?
    var pagamento : String?
    var data : String?
    var codigo : String?
    
    override init() {
        
    }
    
    init(id : String?,nome : String?,pagamento : String?,data : String?, codigo : String?){
        self.id = id
        self.nome = nome
        self.pagamento = pagamento
        self.data = data
        self.codigo = codigo
    }
    
}

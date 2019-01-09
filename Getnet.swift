//
//  GetNet.swift
//
//  Created by Lucca Zenóbio on 15/10/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
class GetNet{
    //requests
    let requests = Request()

    //URL
    let BASE_URL = "https://api-homologacao.getnet.com.br"
    
    var token : String

    
    let SELLER_ID = ""
    let CLIENT_ID = ""
    let CLIENT_SECRET = ""
    
    //Autenticacao
    func getToken(completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let authorization = (CLIENT_ID + ":" + CLIENT_SECRET).toBase64()
        let headers: HTTPHeaders = ["Content-type": "application/x-www-form-urlencoded", "Authorization" : "Basic \(authorization)"]
        let parameters : Parameters = ["scope" : "oob", "grant_type" : "client_credentials"]
        let url_f = BASE_URL + "/auth/oauth/v2/token"
        let url = try? url_f.asURL()
        requests.Post(url: url!, parameters: parameters, headers: headers, completionHandler: completionHandler)
        
    }
    
    //Cadastrar Cliente Cofre
    func cadastrarCliente(cliente: Cliente, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Content-Type" : "application/json", "Authorization" : "Bearer \(self.token)", "seller_id" : SELLER_ID]
        let endereco : Parameters = ["street" : cliente.street, "number" : cliente.number, "complement" : cliente.complement, "district" : cliente.district, "city" : cliente.city, "state" : cliente.state, "country" : "Brasil", "postal_code" : cliente.postal_code]
        let parameters : Parameters = ["seller_id" : SELLER_ID, "first_name" : cliente.first_name, "last_name" : cliente.last_name, "document_type" : cliente.document_type, "document_number" : cliente.document_number, "address" : endereco]
        let url_f = BASE_URL + "/v1/customers"
        let url = try? url_f.asURL()
       requests.PostJSON(url: url!, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    //Retornar Cliente
    func retornarCliente(customer_id : String, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(self.token)", "seller_id" : SELLER_ID]
        let url_f = BASE_URL + "/v1/customers/" + customer_id
        let url = try? url_f.asURL()
        requests.Get(url: url!, headers: headers, completionHandler: completionHandler)
    
    }
    
    //Retornar Cartoes
    func retornarCartoes(customer_id : String, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(self.token)", "seller_id" : SELLER_ID]
        let url_f = BASE_URL + "/v1/cards/?customer_id=" + customer_id
        let url = try? url_f.asURL()
        requests.Get(url: url!, headers: headers, completionHandler: completionHandler)
    }
    
    //Retorar Token do Cartao
    func genCartaoToken(card_number: String, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Content-Type" : "application/json", "Authorization" : "Bearer \(self.token)", "seller_id" : SELLER_ID]
        let parameters : Parameters = ["card_number" : card_number]
        let url_f = BASE_URL + "/v1/tokens/card"
        let url = try? url_f.asURL()
        requests.PostJSON(url: url!, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    //Salvar Cartao no Cofre
    func saveCartaoCofre(cartao_token: String, customer_id : String, cartao : Cartao , cvv: String, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Content-Type" : "application/json", "Authorization" : "Bearer \(self.token)", "seller_id" : SELLER_ID]
        let parameters : Parameters = ["number_token" : cartao_token, "cardholder_name" : cartao.card_name, "expiration_month" : cartao.exp_month, "expiration_year" : cartao.exp_yer, "customer_id" : customer_id, "security_code" : cvv, "verify_card" : "true"]
        let url_f = BASE_URL + "/v1/cards"
        let url = try? url_f.asURL()
        
        requests.PostJSON(url: url!, parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    //Remover Cartao Cofre
    func removerCartao(card_id : String, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(self.token)"]
        let url_f = BASE_URL + "/v1/cards/" + card_id
        let url = try? url_f.asURL()
        requests.Delete(url: url!, headers: headers, completionHandler: completionHandler)
    }
    
    //Pagar Cartao de Credito
    func pagarCartaoCredito(cvv: String, cliente : Cliente, preco : Int, cartao : Cartao, pedido: Pedido, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        let headers: HTTPHeaders = ["Content-Type" : "application/json", "Authorization" : "Bearer \(self.token)"]
        let order : Parameters = ["order_id" : pedido.id]
        let address : Parameters = ["street" : cliente.street, "number" : cliente.number, "complement" : cliente.complement, "district" : cliente.district, "city" : cliente.city, "state" : cliente.state, "country" : cliente.country, "postal_code" : cliente.postal_code]
        let customer : Parameters = ["customer_id" : cliente.customer_id, "billing_address" : address]
        let card : Parameters = ["number_token" : cartao.number_token , "cardholder_name" : cartao.card_name, "security_code" : cvv, "expiration_month" : cartao.exp_month, "expiration_year" : cartao.exp_yer]
        let credit : Parameters = ["delayed" : "false", "save_card_data" : "false", "transaction_type" : "FULL", "number_installments" : "1", "card" : card]
        let parameters : Parameters = ["seller_id" : SELLER_ID, "amount" : preco, "order" : order, "customer" : customer , "credit" : credit]
        let url_f = BASE_URL + "/v1/payments/credit"
        let url = try? url_f.asURL()
        print(parameters)
        
        requests.PostJSON(url: url!, parameters: parameters, headers: headers, completionHandler: completionHandler)
    
    }
    
   
    
    

    
}
//usefull
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

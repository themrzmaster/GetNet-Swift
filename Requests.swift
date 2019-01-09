//
//  Requests.swift
//
//  Created by Lucca Zenóbio on 08/09/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Request{
    func PostJSON(url: URL, parameters: Parameters, headers: HTTPHeaders, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                switch response.result{
                    case .success(let value):
                        completionHandler(JSON(value), response.response?.statusCode, nil)
                    case .failure(let error):
                        completionHandler(nil,response.response?.statusCode, error)
                }
        }
    }
    func Post(url: URL, parameters: Parameters, headers: HTTPHeaders, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
            .responseJSON{ response in
                switch response.result{
                case .success(let value):
                    completionHandler(JSON(value), response.response?.statusCode, nil)
                case .failure(let error):
                    completionHandler(nil,response.response?.statusCode, error)
                }
        }
    }
 
    func Get(url: URL, headers: HTTPHeaders, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        Alamofire.request(url, method: .get, headers: headers)
            .responseJSON{ response in
                switch response.result{
                case .success( let value):
                    completionHandler(JSON(value), response.response?.statusCode, nil)
                case .failure(let error):
                    completionHandler(nil,response.response?.statusCode, error)
                }
        }
    }
    func Delete(url: URL, headers: HTTPHeaders, completionHandler:@escaping (JSON?, Int?, Error?) -> ()){
        Alamofire.request(url, method: .delete, headers: headers)
            .responseJSON{ response in
                switch response.result{
                case .success( let value):
                    completionHandler(JSON(value), response.response?.statusCode, nil)
                case .failure(let error):
                    completionHandler(nil,response.response?.statusCode, error)
                }
        }
    }
    
    
    
    

    
   
    
}

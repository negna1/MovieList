//
//  ServiceCall.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit


//This is main status for service call. If response is good it must be success , and it is generic. if not it would be error wuth it's type
//if internet connection is bad there is internetConnection case , and if service data not wrapped it has notHaveData.
enum Status <T>{
    case success(T)
    case fail(ErrorType)
}

enum ErrorType {
    case internetConnection
    case notHaveData
}

class Service : NSObject{
  
    func get<T: Decodable>(_ url: URL, respType: T.Type, withCompletion completion: @escaping (Status<Any>) -> Void)  {
        let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
             
                if error != nil || response == nil {
                    completion(Status.fail(ErrorType.internetConnection))
                    return
                }
                guard let data = data else {
                    completion(Status.fail(ErrorType.internetConnection))
                    return
                }
                let wrapper = try? JSONDecoder().decode(T.self
                                                        , from: data)
                if let wrapper = wrapper {
                    completion(Status.success(wrapper))
                }else{
                    completion(Status.fail(ErrorType.notHaveData))
                }
                } )
            task.resume()
    }

}

//
//  Photo.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/12/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

enum PhotoError: Error {
    case failedToCreate
}

struct Photo {
    static func create() -> Promise<JSON> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.createPhoto).validate().responseJSON { response in
                if response.result.isSuccess,
                    let json = response.result.value as? JSON
                {
                    fulfill(json)
                } else {
                    reject(PhotoError.failedToCreate)
                }
            }
        }
    }
}

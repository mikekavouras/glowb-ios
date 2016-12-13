//
//  S3ImageUploader.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/12/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

enum S3ImageUploadError: Error {
    case couldNotConstructURL
}

struct S3ImageUploader {
    static func uploadImage(jpeg: Data, params: JSON) -> Promise<Void> {
        return Promise { fulfill, reject in
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "electrolamp-photos.s3.amazonaws.com"
            
            let queryItems: [URLQueryItem] = Array(params.keys).flatMap { key in
                guard let value = params[key] as? String else { return nil }
                if key == "x-requested-with" { return nil }
                if key == "utf8" { return nil }
                return URLQueryItem(name: key, value: value)
            }
            
            components.queryItems = queryItems
            
            guard let url = components.url else {
                reject(S3ImageUploadError.couldNotConstructURL)
                return
            }
            
            Alamofire.upload(jpeg, to: url, method: .post)
                .uploadProgress { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }
                .response { response in
                    print(response)
                    fulfill()
                }
        }
    }
}

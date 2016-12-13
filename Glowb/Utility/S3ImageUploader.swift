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
    case failedToUploadImage(String)
}

struct S3ImageUploader {
    
    static let url: String = "https://electrolamp-photos.s3.amazonaws.com"
    
    static func uploadImage(jpeg: Data, params: JSON) -> Promise<Void> {
        
        return Promise { fulfill, reject in
            
            Alamofire.upload(multipartFormData: { data -> Void in
                for (key, value) in params {
                    guard let value = value as? String,
                        let valueData = value.data(using:.utf8) else
                    { continue }
                    
                    data.append(valueData, withName: key)
                }
                
                data.append(InputStream(data: jpeg), withLength: UInt64(jpeg.count), headers: [:])
            }, to: url, method: .post) { result in
                
                switch result {
                case .success(let request, _, _ ):
                    request.uploadProgress(closure: S3ImageUploader.handleProgress).response { response in
                        fulfill()
                    }
                case .failure( let encodingError ):
                    reject(S3ImageUploadError.failedToUploadImage(encodingError.localizedDescription))
                }

            }
        }
    }
    
    private static func handleProgress(_ progress: Progress) {
        print("Upload Progress: \(progress.fractionCompleted)")
    }
}

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
import SWXMLHash

enum S3ImageUploadError: Error {
    case failedToUploadImage(String)
    case failedToParseXMLResponse
}

struct S3ImageUploader {
    
    static let url: String = "https://electrolamp-photos.s3.amazonaws.com"
    static let headers: HTTPHeaders = [
        "Content-Disposition": "form-data; name=\"file\"",
        "Content-Type": "application/octet-stream"
    ]
    
    static func uploadImage(jpeg: Data, params: JSON, progressHandler: ((Progress) -> Void)? = S3ImageUploader.handleProgress) -> Promise<String> {
        
        return Promise { fulfill, reject in
            
            Alamofire.upload(multipartFormData: { data -> Void in
                for (key, value) in params {
                    guard let value = value as? String,
                        let valueData = value.data(using:.utf8) else
                    { continue }
                    
                    data.append(valueData, withName: key)
                }
                
                data.append(InputStream(data: jpeg), withLength: UInt64(jpeg.count), headers: headers)
            }, to: url, method: .post) { result in
                
                switch result {
                case .success(let request, _, _ ):
                    request.uploadProgress(closure: progressHandler!).response { response in
                        let xml = SWXMLHash.parse(response.data!)
                        let eTag = xml["PostResponse"]["ETag"]
                        guard let eTagElement = eTag.element else
                        {
                            reject(S3ImageUploadError.failedToParseXMLResponse)
                            return
                        }
                        let eTagText = eTagElement.text
                        
                        fulfill(eTagText)
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

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
            Alamofire.upload(multipartFormData: { data -> Void in
                let stream = InputStream(data: jpeg)
                let length = UInt64(jpeg.count)
                let headers = ["Content-Disposition": "form-data; name=\"file\"",
                               "Content-Type": "application/octet-stream"]
                
                for (key, value) in params {
                    if let value = value as? String {
                        data.append(value.data(using: .utf8)!, withName: key)
                    }
                }
                data.append(stream, withLength: length, headers: headers)
            }, to: "https://electrolamp-photos.s3.amazonaws.com", method: .post, encodingCompletion: { result in
                switch result {
                case .success(let request, _, _ ):
                    
                    request.uploadProgress { progress in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        }
                        .downloadProgress { progress in
                            print("Download Progress: \(progress.fractionCompleted)")
                        }
                        .response { response in
                            print(response)
                            fulfill()
                    }
                

                case .failure( let encodingError ):
                    print( "===== ERROR ENCODING PNG =====" )
                    print( encodingError )
                    reject(S3ImageUploadError.couldNotConstructURL)
                }

            })
        }
    }
}

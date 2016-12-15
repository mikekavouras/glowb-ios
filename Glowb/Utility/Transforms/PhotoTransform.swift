//
//  PhotoTransform.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/14/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import ObjectMapper

struct PhotoJSONTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Photo? {
        
        guard let included = value as? [JSON] else {
            return nil
        }
        
//        let photoJSON = included.filter { item in
//            guard let type = item["type"] as? String else { return false }
//            return type == "photo"
//        }
        
        return nil
    }
    
    func transformToJSON(_ value: Photo?) -> String? {
        return "photo"
    }
}

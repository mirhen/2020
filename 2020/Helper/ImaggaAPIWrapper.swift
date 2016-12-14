//
//  ImaggaAPIWrapper.swift
//  2020
//
//  Created by Miriam Hendler on 12/8/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ImaggaAPIWrapper {
    
    func getAllTags(image: UIImage, callback: @escaping (Waste) -> ()) {
        
        let headers = ["Authorization": "Basic YWNjXzMxMjRjNTUyYjRhNmMzMzo0Njc4NDQwY2IzYTBhMGFhZGI3NmMyYWI0OGFkZjc3Yw=="]
        let contentURL = "https://api.imagga.com/v1/content"
        let taggingURL = "https://api.imagga.com/v1/tagging"
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        //        let URL = try! URLRequest(url: url, method: .post, headers: headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "xyz", fileName: "file.jpeg", mimeType: "image/jpeg")
        }, to: contentURL, method: .post, headers: headers)
        { (result) in
            //result
            print(result)
            switch result {
            case .success(let upload, _, _):
                print("success")
                upload.responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        let json = JSON(value: response.result.value!)
                        let content_id = json["uploaded"][0]["id"].string!
                        print("Content ID: \(content_id)")
                        let params = [ "content" : content_id ]
                        Alamofire.request(taggingURL, method: .get, parameters: params, headers: headers).responseJSON(completionHandler: { (response) in
                            if response.result.isSuccess {
                                let json = JSON(value: response.result.value!)
                                print(json)
                                var tags: [String] = []
                                let results = json["results"][0]["tags"]
                                for tag in 0..<results.count {
                                    if results[tag]["confidence"].int! >= 15 {
                                        let tagString = results[tag]["tag"].string!
                                        tags.append(tagString)
                                    }
                                }
                                print(tags)
                                if self.checkWasteType(.compost, tags: tags) {
                                    callback(.compost)
                                } else if self.checkWasteType(.recycle, tags: tags) {
                                    callback(.recycle)
                                } else if self.checkWasteType(.landfill, tags: tags) {
                                    callback(.landfill)
                                } else {
                                    callback(.none)
                                }
                            }
                        })
                    }
                })
            case .failure(let encodedError):
                print(encodedError)
            }
        }
    }
    
    //MARK: Helper Functions
    
    func checkWasteType(_ wasteType: Waste, tags: [String]) -> Bool {
        
        let recArray: [String] = ["can", "tin", "box", "card", "carton", "milk", "glass", "lid", "plastic", "bottle", "container", "steel", "aluminum", "jar", "tub", "tray", "pot", "newspaper", "magazine", "envelope", "mail", "shampoo", "water", "bleach", "cup", "drink", "beverage", "liquid", "tea", "coffee", "bag", "basket", "hamper", "box", "vessel", "pill bottle", "water bottle", "drink", "tissue", "book", "napkin", "towel", "wrap", "paper bag", "metal container", "beer", "jug", "plate", "newspaper", "cardboard", "utensil", "steel", "magazine", "foil", "spoon", "paper", "tissues"]
        let comArray: [String] = ["meal", "cuisine","cream","sauce","vegetable", "pizza box", "leave", "flower", "weed"]
        let lanArray: [String] = ["chip bag", "wrapper", "candy wrapper","ceramic","microwave","battery"]
        var wasteTypeArray: [String] = []
        //a vision for the future
        switch wasteType {
        case .recycle:
            wasteTypeArray = recArray
        case .compost:
            wasteTypeArray = comArray
        case .landfill:
            wasteTypeArray = lanArray
        default:
            break
        }

        for waste in wasteTypeArray {
            for tag in tags {
                if tag == waste {
                    return true
                }
            }
        }
        return false
    }
}



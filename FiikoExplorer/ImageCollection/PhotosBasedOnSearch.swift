//
//  imagesBasedOnSearch.swift
//  FiikoExplorer
//
//  Created by Viraj on 03/04/17.
//  Copyright © 2017 Viraj. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PhotosBasedOnSearch {
    
    fileprivate var photoList = PhotoList()
    
    func loadPhotoList(searchTerm: String, completion: @escaping ([PhotoItem]?) -> ()) {
        let photoListUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(searchTerm)&per_page=500&format=json&nojsoncallback=1"
        Alamofire.request(photoListUrl).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let jsonPhotoListTemp = JSON(value)
                    let jsonPhotoList = jsonPhotoListTemp["photos"]["photo"]
                    let totalNumber = jsonPhotoListTemp["photos"]["total"].intValue
                    if totalNumber == 0 {
                        completion(nil)
                    } else {
                        // prepare to load photo
                        let returnPhotos = self.photoList.addPhotoToList(jsonPhotoList: jsonPhotoList)
                        completion(returnPhotos)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

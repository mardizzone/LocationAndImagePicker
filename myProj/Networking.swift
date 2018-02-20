//
//  Networking.swift
//  myProj
//
//  Created by Michael Ardizzone on 2/18/18.
//  Copyright © 2018 Michael Ardizzone. All rights reserved.
//

import Foundation
import Alamofire


class Networking {
    
    //oauth_token=M4SLKM0RRYS3CL3OCGHN4CKKDWUX4NJWGD1024MPZCTLMSL2&v=20180218
    //https://api.foursquare.com/v2/venues/search
    //ll=40.7484,-73.9857
    
   class func getNearbyVenues(latitude: Double, longitude: Double, completionHandler : @escaping (FoursquareModel) -> Void) {
        let coordinates = "\(latitude),\(longitude)"
        let params: Parameters = ["ll" : coordinates, "oauth_token" : "M4SLKM0RRYS3CL3OCGHN4CKKDWUX4NJWGD1024MPZCTLMSL2", "v" : "20180218"]
    Alamofire.request("https://api.foursquare.com/v2/venues/search", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
        switch response.result {
        case .success(let value):
            if let returnedData = parseJSON.parseInstagramData(data: value) {
                completionHandler(returnedData)
            }
        case .failure(let error):
            print(error)
        }
    }
    }

}

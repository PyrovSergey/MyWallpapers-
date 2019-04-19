//
//  NetworkManagerDelegate.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate{
    
    func successRequest(result: [PhotoItem])
    
    func errorRequest(errorMessage: String)
    
}

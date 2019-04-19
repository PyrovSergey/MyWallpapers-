//
//  NetworkManager.swift
//  MyWallpapers°
//
//  Created by Sergey on 17/04/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Reachability

class NetworkManager: NSObject {
    private static let instance = NetworkManager()
    private let apiKey: String = "563492ad6f91700001000001a339a6814c384995974312ac8533c8e5"
    private let baseUrlForRequest: String = "https://api.pexels.com/v1/search"
    private let perPage: Int = 50
    private var numberOfCurrentPage = 1
    private var totalResult: Int = 0
    private var totalPages: Int = 0
    private var currentCategory: String = ""
    var reachability: Reachability!
    
    private override init() {
        super.init()
        // Initialise reachability
        reachability = Reachability()!
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    static func getInstance() -> NetworkManager {
        return instance
    }
    
    func clearCounts() {
        currentCategory = ""
        numberOfCurrentPage = 1
        totalResult = 0
        totalPages = 0
    }
    
    func getRequest(category: String, manager: NetworkManagerDelegate) {
        if currentCategory != category {
            currentCategory = category
            numberOfCurrentPage = 1
            totalResult = 0
            totalPages = 0
        }
        
        let headers = [
            "Authorization": apiKey]
        
        let params: [String : String] = [
            "query" : category.lowercased(),
            "per_page" : String(perPage),
            "page" : String(numberOfCurrentPage)
        ]
        
        print("\(baseUrlForRequest)?query=\(category)&per_page=\(perPage)&page=\(numberOfCurrentPage)")
        
        Alamofire.request(baseUrlForRequest, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success response!")
                let responseJSON : JSON = JSON(response.result.value!)
                var resultArrayPhotos = [PhotoItem]()
                if let total = responseJSON["total_results"].int {
                    if self.totalResult == 0 {
                        self.totalResult = total
                        var resultPages = self.totalResult / self.perPage
                        if total % 2 == 0 {
                            resultPages += 1
                        }
                        self.totalPages = resultPages
                        print("totalPages  -- >> \(self.totalPages)")
                    }
                }
                if let responsePhotosArray = responseJSON["photos"].array {
                    if !responsePhotosArray.isEmpty {
                        for responseObject in responsePhotosArray {
                            resultArrayPhotos.append(PhotoItem(
                                photographer: responseObject["photographer"].string ?? "",
                                original: responseObject["src"]["original"].string ?? "",
                                large2x: responseObject["src"]["large2x"].string ?? "",
                                large: responseObject["src"]["large"].string ?? "",
                                medium: responseObject["src"]["medium"].string ?? "",
                                small: responseObject["src"]["small"].string ?? "",
                                portrait: responseObject["src"]["portrait"].string ?? "",
                                square: responseObject["src"]["square"].string ?? "",
                                landscape: responseObject["src"]["landscape"].string ?? "",
                                tiny: responseObject["src"]["tiny"].string ?? ""
                            ))
                        }
                        
                    }
                    if self.totalPages > self.numberOfCurrentPage {
                        self.numberOfCurrentPage += 1
                        manager.successRequest(result: resultArrayPhotos)
                    }
                } else {
                    manager.errorRequest(errorMessage: "Response in errorr \(response.error!)")
                }
            }
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.getInstance().reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.getInstance().reachability).connection != .none {
            completed(NetworkManager.getInstance())
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.getInstance().reachability).connection == .none {
            completed(NetworkManager.getInstance())
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.getInstance().reachability).connection == .cellular {
            completed(NetworkManager.getInstance())
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.getInstance().reachability).connection == .wifi {
            completed(NetworkManager.getInstance())
        }
    }
}


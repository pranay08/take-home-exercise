//
//  Server.swift
//  Fetch Recipes
//
//  Created by Pranay Kothlapuram on 5/30/25.
//

import Foundation

struct Server {
    let scheme: String
    let host: String
    var port: Int?
    
    static let dev: Server = .init(scheme: "https", host: "d3jbb8n5wk0qxi.cloudfront.net")
}

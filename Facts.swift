//
//  Facts.swift
//  Facts
//
//  Created by Sailaja Rallapalli on 28/02/18.
//  Copyright © 2018 SoftSol. All rights reserved.
//

import Foundation

struct Facts: Codable {
    let title: String
    let rows: [Row]
}

struct Row: Codable {
    let title: String
    let description: String
    let imageHref: String
}

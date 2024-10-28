//
//  Content.swift
//  PhotoTaker
//
//  Created by Denis Haritonenko on 25.10.24.
//

import Foundation

struct ContentItem: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let image: String?
}

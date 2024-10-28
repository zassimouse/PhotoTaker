//
//  ContentResponse.swift
//  PhotoTaker
//
//  Created by Denis Haritonenko on 26.10.24.
//

import Foundation

struct ContentResponse: Codable {
    let page: Int
    let pageSize: Int
    let totalElements: Int
    let totalPages: Int
    let content: [ContentItem]
}

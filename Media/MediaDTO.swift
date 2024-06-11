//
//  MediaDTO.swift
//  MediaDTO
//
//  Created by NERO on 6/10/24.
//

import Foundation

struct MovieDTO: Decodable {
    var results: [Result]
    let total_pages: Int
}

struct Result: Decodable {
    let id: Int
    let title: String
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String?
    let vote_average: Float?
    let overview: String?
}

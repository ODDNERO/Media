//
//  MediaDTO.swift
//  MediaDTO
//
//  Created by NERO on 6/10/24.
//

import Foundation

struct MovieDTO: Decodable {
    let results: [Result]
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

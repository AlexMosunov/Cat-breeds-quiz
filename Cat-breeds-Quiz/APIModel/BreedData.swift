//
//  BreedData.swift
//  Cat-breeds-Quiz
//
//  Created by Alex Mosunov on 02.05.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import Foundation

struct BreedData: Codable {
    let breeds: [Breeds]
    let url: String
}

struct Breeds: Codable {
    let name: String
    let temperament: String
    let description: String
    let wikipedia_url: String
}

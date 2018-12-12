//
//  CountryModel.swift
//  ContactTest
//
//  Created by Raja on 12/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

typealias CountryCode = [CountryModel]

struct CountryModel: Codable {
    let name: String
    let topLevelDomain: [String]
    let alpha2Code, alpha3Code: String
    let callingCodes: [String]
    let capital: String
    let altSpellings: [String]
    let region: Region
    let subregion: String
    let population: Int
    let latlng: [Double]
    let demonym: String
    let area, gini: Double?
    let timezones, borders: [String]
    let nativeName: String
    let numericCode: String?
    let currencies, languages: [String]
    let translations: Translations
    let relevance: String?
}

enum Region: String, Codable {
    case africa = "Africa"
    case americas = "Americas"
    case asia = "Asia"
    case empty = ""
    case europe = "Europe"
    case oceania = "Oceania"
    case polar = "Polar"
}

struct Translations: Codable {
    let de, es, fr, ja: String?
    let it: String?
}

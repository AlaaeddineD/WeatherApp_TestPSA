//
//  ApiCallError.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation

enum ApiCallError: Error{
    case url_not_found
    case unexpected_error(String)
}

extension ApiCallError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .url_not_found:
            return "Couldn't create a valid URL"
        case .unexpected_error(let message):
            return message
        }
    }
}

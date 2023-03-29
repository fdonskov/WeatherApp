//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import Foundation

class NetworkService {
    
    // https://api.weatherapi.com/v1/current.json?key=9da93b4c507f441a88f230306232803&q=Moscow&aqi=no

    static let shared = NetworkService()
    
    private let baseURLString = "https://api.weatherapi.com/v1"
    private let apiKey = "9da93b4c507f441a88f230306232803"

    func fetchWeatherData(city: String, completion: @escaping (Result<Data, Error>) -> Void) {

        let urlString = "\(baseURLString)/current.json?key=\(apiKey)&q=\(city)&aqi=no"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(data))
        }

        task.resume()
    }
}

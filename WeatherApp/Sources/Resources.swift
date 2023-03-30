//
//  Resources.swift
//  WeatherApp
//
//  Created by Федор Донсков on 30.03.2023.
//

import Foundation

enum Resources {
    enum NetworkService {
        static let baseURL: String = "https://api.weatherapi.com/v1"
        static let apiKey: String = "9da93b4c507f441a88f230306232803"
        
        static let invalodUrl: String = "Invalid URL"
        static let noData: String = "No data received"
    }
    
    enum TabBar {
        static let weatherItemName: String = "Weather"
        static let weatherItemImage: String = "cloud.fill"
        
        static let favoritsItemName: String = "Favorits"
        static let favoritsItemImage: String = "star.fill"
        
        static let weatherTeg: Int = 0
        static let favoritsTeg: Int = 1
        
        static let standartOffSet: CGFloat = 0
    }
    
    enum WeatherView {
        static let collectionViewLeadingAnchor: CGFloat = 10
        
        static let forKeyWeatherData: String = "favoriteWeatherData"
        static let updateFavoriteData: String = "updateFavoriteData"
        
        static let cityNameLabelSize: CGFloat = 18
        static let temperatureLabel: CGFloat = 16
        static let descriptionWeatherLabelSize: CGFloat = 12.5
        static let addFavoritesButtonTextSize: CGFloat = 16
        
        static let viewCornerRadius: CGFloat = 10
    }
    
    enum Errors {
        static let required: String = "init(coder:) has not been implemented"
    }
}

//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Павел Попов on 27.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

struct NetworkWeatherManager {
    func fetchCurrentWeather(forCity city: String, comlectionHandler: @escaping (CurrentWeather) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    comlectionHandler(currentWeather)
                }
            }
        }
        task.resume()
    }

    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}


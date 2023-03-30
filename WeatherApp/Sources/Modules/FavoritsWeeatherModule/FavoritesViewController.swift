//
//  FavoritsViewController.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    var favoriteWeatherData: [WeatherData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(FavoritsTableViewCell.self, forCellReuseIdentifier: FavoritsTableViewCell.identifier)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Favorits"
        
        favoriteWeatherData = loadFavoritesData()
        
        configureTableView()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteWeatherData = loadFavoritesData()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadFavoritesData() -> [WeatherData] {
        if let data = UserDefaults.standard.data(forKey: Resources.WeatherView.forKeyWeatherData) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([WeatherData].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    private func postFavoriteDataUpdateNotification() {
        let userInfo = ["favoriteWeatherData": favoriteWeatherData]
        NotificationCenter.default.post(name: Notification.Name("updateFavoriteData"), object: nil, userInfo: userInfo)
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let weatherData = favoriteWeatherData[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritsTableViewCell.identifier, for: indexPath) as? FavoritsTableViewCell else { return UITableViewCell() }
        
        if indexPath.row < favoriteWeatherData.count {
            let weatherData = favoriteWeatherData[indexPath.row]
            cell.configure(with: weatherData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let deletedWeatherData = favoriteWeatherData.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            postFavoriteDataUpdateNotification()
            tableView.endUpdates()
            
            print("Deleted weather data: \(deletedWeatherData)")
        }
    }
}

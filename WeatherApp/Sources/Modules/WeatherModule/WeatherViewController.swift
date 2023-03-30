//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var weatherData: [WeatherData] = []
    private var favoriteWeatherData: [WeatherData] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width / 2)-15,
                                 height: (view.frame.size.width / 2.5)-5)
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather(cities: ["Moscow", "London", "Istanbul", "Tokyo", "Singapore", "SanFrancisco", "Rotterdam", "Riga", "Rome", "Odessa", "Milan", "Minsk", "Madrid", "Cairo", "Yerevan", "Havana", "Washington", "Valencia", "Berlin", "Bangkok"])
        
        subscribeToFavoriteDataUpdates()
        
        setupHierarchy()
        configureCollectionView()
        configureConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupHierarchy() {
        view.backgroundColor = .white
        self.title = "Weather"
        
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resources.WeatherView.collectionViewLeadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resources.WeatherView.collectionViewLeadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func saveFavoritesData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteWeatherData) {
            UserDefaults.standard.set(encoded, forKey: Resources.WeatherView.forKeyWeatherData)
            UserDefaults.standard.synchronize()
        }
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
    
    private func subscribeToFavoriteDataUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteData(_:)), name: Notification.Name(Resources.WeatherView.updateFavoriteData), object: nil)
    }
    
    func updateFavoritesData(_ data: [WeatherData]) {
        favoriteWeatherData = data
        saveFavoritesData()
        collectionView.reloadData()
    }
}

// MARK: - Actions

extension WeatherViewController {
    @objc
    func updateFavoriteData(_ notification: Notification) {
        if let favoriteWeatherData = notification.userInfo?[Resources.WeatherView.forKeyWeatherData] as? [WeatherData] {
            self.favoriteWeatherData = favoriteWeatherData
            collectionView.reloadData()
        }
    }
}

// MARK: - Network methods

extension WeatherViewController {
    
    func fetchWeather(cities: [String]) {
        let group = DispatchGroup()
        for city in cities {
            group.enter()
            NetworkService.shared.fetchWeatherData(city: city) { [weak self] result in
                defer { group.leave() }
                switch result {
                case .success(let data):
                    do {
                        
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(WeatherData.self, from: data)
                        self?.weatherData.append(weatherData)
                    } catch {
                        print("Error parsing weather data: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ячейка \(indexPath.row)")
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
        
        let viewModel = weatherData[indexPath.row]
        cell.configure(with: viewModel)
        
        cell.addFavoritesButtonAction = { [weak self] in
            
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            let weatherData = self?.weatherData[indexPath.row]
            if let data = weatherData {
                self?.favoriteWeatherData.append(data)
                self?.saveFavoritesData()
                self?.collectionView.reloadItems(at: [indexPath])
            }
        }
        return cell
    }
}

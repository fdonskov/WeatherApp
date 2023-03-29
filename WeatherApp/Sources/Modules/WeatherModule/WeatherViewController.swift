//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import UIKit

final class WeatherViewController: UIViewController, FavoriteWeatherDelegate {
    
    // MARK: - Private properties
    
    weak var favoriteDelegate: FavoriteWeatherDelegate?
    
    private var weatherData: [WeatherData] = []
    
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
        
        fetchWeather(cities: ["Moscow", "Moscow", "Moscow", "Moscow", "Moscow", "Moscow", "Moscow", "Moscow", "Moscow", "Moscow"])
        
        setupHierarchy()
        configureCollectionView()
        configureConstraints()
    }
    
    // MARK: - Private properties
    
    private func setupHierarchy() {
        view.backgroundColor = .white
        self.title = "Weather"
        
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
//    private func addCityToFavorites(_ weatherData: WeatherData) {
//        let favoritesVC = FavoritsViewController()
//            favoriteDelegate = self
//            favoritesVC.favoriteWeatherData.append(weatherData)
////            navigationController?.pushViewController(favoritesVC, animated: true)
//    }
    
    func didAddWeatherToFavorite(_ weatherData: WeatherData) {
        let favoritesVC = FavoritsViewController()
            favoriteDelegate = self
            favoritesVC.favoriteWeatherData.append(weatherData)
    }
}

// MARK: - Network

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
            guard let weatherData = self?.weatherData[indexPath.row] else { return }
            self?.didAddWeatherToFavorite(weatherData)
            print([weatherData].count)
        }
        
        return cell
    }
}

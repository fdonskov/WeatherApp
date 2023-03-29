//
//  FavoritsViewController.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import UIKit

protocol FavoriteWeatherDelegate: AnyObject {
    func didAddWeatherToFavorite(_ weatherData: WeatherData)
}

final class FavoritsViewController: UIViewController {
    
    var favoriteWeatherData: [WeatherData] = []
    
    // MARK: - Private properties
    
    lazy var tableView: UITableView = {
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
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureConstraints()
    }
    
    // MARK: - Private methods
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavoritsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FavoritsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritsTableViewCell.identifier, for: indexPath) as? FavoritsTableViewCell else { return UITableViewCell() }
        
        let viewModel = favoriteWeatherData[indexPath.row]
        print(viewModel)
        cell.configure(with: viewModel)
        
        return cell
    }
}

extension FavoritsViewController: FavoriteWeatherDelegate {
    func didAddWeatherToFavorite(_ weatherData: WeatherData) {
        favoriteWeatherData.append(weatherData)
        tableView.reloadData()
    }
}

//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: WeatherCollectionViewCell.self)
    
    // MARK: - Private properties
    
    private lazy var weatherImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemCyan
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.text = "Краснодар"
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.text = "15"
        return label
    }()
    
    private lazy var descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.text = "Ясно"
        return label
    }()
    
    private lazy var addFavoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("В избранное", for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemOrange
        button.addTarget(self, action: #selector(addFavoritesButtonCompletion), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGreen
        
        contentView.addSubview(weatherImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionWeatherLabel)
        contentView.addSubview(addFavoritesButton)

        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        weatherImageView.layer.cornerRadius = 10
        weatherImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = nil
        cityNameLabel.text = nil
        temperatureLabel.text = nil
        descriptionWeatherLabel.text = nil
    }
}

// MARK: - Methods
extension WeatherCollectionViewCell {
    
//    func configure(with viewModel: NewsTableViewCellViewModel) {
//        newsTitleLabel.text = viewModel.title
//        subtitleLabel.text = "Просмотрено: "
//        //        subtitleLabel.text = viewModel.subtitle
//
//        if let data = viewModel.imageData {
//            newsImageView.image = UIImage(data: data)
//        } else if let url = viewModel.imageURL {
//            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//                guard let data = data, error == nil else { return }
//                viewModel.imageData = data
//
//                DispatchQueue.main.async {
//                    self?.newsImageView.image = UIImage(data: data)
//                }
//            }.resume()
//        }
//    }
    
    private func configureConstraints() {
        
        NSLayoutConstraint.activate([
            
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            cityNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            weatherImageView.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 5),
            weatherImageView.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 80),
            weatherImageView.heightAnchor.constraint(equalToConstant: 80),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherImageView.topAnchor, constant: 10),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            descriptionWeatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            descriptionWeatherLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            descriptionWeatherLabel.trailingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor),
            descriptionWeatherLabel.bottomAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: -10),
            
            addFavoritesButton.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
            addFavoritesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            addFavoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            addFavoritesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - Extension ProfileView

extension WeatherCollectionViewCell {
    @objc
    private func addFavoritesButtonCompletion() {
        print("Tap")
    }
}

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
    
    private var weatherData: WeatherData?
    
    private lazy var weatherImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Resources.WeatherView.cityNameLabelSize, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Resources.WeatherView.temperatureLabel, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Resources.WeatherView.descriptionWeatherLabelSize, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var addFavoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Resources.WeatherView.addFavoritesButtonTextSize)
        button.setTitle("В избранное", for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addFavoritesButtonCompletion), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = Resources.WeatherView.viewCornerRadius
        
        contentView.addSubview(weatherImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionWeatherLabel)
        contentView.addSubview(addFavoritesButton)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Resources.Errors.required)
    }
    
    // MARK: - Actions
    
    var addFavoritesButtonAction: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        weatherImageView.layer.cornerRadius = Resources.WeatherView.viewCornerRadius
        weatherImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = nil
        cityNameLabel.text = nil
        temperatureLabel.text = nil
        descriptionWeatherLabel.text = nil
    }
    
    // MARK: - Private methods
    
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

// MARK: - Configure

extension WeatherCollectionViewCell {
    
    func configure(with viewModel: WeatherData) {
        
        self.cityNameLabel.text = viewModel.location.name
        self.descriptionWeatherLabel.text = viewModel.current.condition.text
        
        self.temperatureLabel.text = "\(viewModel.current.tempC) °C"
        
        let imageName = viewModel.current.condition.icon
        let imageUrlString = "https:\(imageName)"
        if let imageUrl = URL(string: imageUrlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: imageUrl, completionHandler: { data, response, error in
                if let error = error {
                    print("Error loading image: \(error)")
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherImageView.image = image
                    }
                }
            })
            task.resume()
        }
    }
}

// MARK: - Extension WeatherCollectionViewCell

extension WeatherCollectionViewCell {
    @objc
    private func addFavoritesButtonCompletion() {
        print("Tap")
        addFavoritesButtonAction?()
    }
}

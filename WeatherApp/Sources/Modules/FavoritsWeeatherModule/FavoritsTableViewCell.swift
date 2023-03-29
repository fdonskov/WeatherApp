//
//  FavoritsTableViewCell.swift
//  WeatherApp
//
//  Created by Федор Донсков on 29.03.2023.
//

import UIKit

final class FavoritsTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FavoritsTableViewCell.self)
    
    private lazy var nameCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var speedWindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setupHierarhy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // MARK: - Private methods

    private func setupHierarhy() {
        contentView.addSubview(nameCityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(speedWindLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            nameCityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            nameCityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            temperatureLabel.topAnchor.constraint(equalTo: nameCityLabel.bottomAnchor, constant: 3),
            temperatureLabel.leadingAnchor.constraint(equalTo: nameCityLabel.leadingAnchor),
            
            speedWindLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 3),
            speedWindLabel.leadingAnchor.constraint(equalTo: nameCityLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: speedWindLabel.bottomAnchor, constant: 3),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameCityLabel.leadingAnchor)
            
        ])
    }
}

// MARK: - Configure

extension FavoritsTableViewCell {
    func configure(with viewModel: WeatherData) {
        self.nameCityLabel.text = "Город: \(viewModel.location.name)"
        self.temperatureLabel.text = "Температура: \(viewModel.current.tempC) °C"
        self.descriptionLabel.text = "Описание: \(viewModel.current.condition.text)"
        self.speedWindLabel.text = "Скорость ветра: \(viewModel.current.windKph) км/ч"
    }
}

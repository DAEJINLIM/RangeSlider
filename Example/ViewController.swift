//
//  ViewController.swift
//
//  Created by DAEJINLIM on 11/8/23.
//

import UIKit

class ViewController: UIViewController {
    private let rangeSlider: RangeSlider = {
        let slider = RangeSlider()
        slider.minRange = -10
        slider.maxRange = 50
        return slider
    }()
    
    private let rangeSlider2: RangeSlider = {
        let slider = RangeSlider()
        slider.thumbTintColor = .orange
        slider.trackHighlightTintColor = .black
        slider.trackTintColor = .brown
        slider.roundness = 0.5
        return slider
    }()
    
    private let text: UILabel = {
        let label = UILabel()
        label.text = "value"
        label.textAlignment = .center
        return label
    }()
    
    private var value: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        value.text = "\(rangeSlider.minValue) ~ \(rangeSlider.maxValue)"
    }
    
    func addSubviews() {
        view.addSubview(rangeSlider)
        view.addSubview(text)
        view.addSubview(value)
        view.addSubview(rangeSlider2)
    }
    
    func setupConstraints() {
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider2.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        value.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.widthAnchor.constraint(equalToConstant: 50),
            text.heightAnchor.constraint(equalToConstant: 50),
            
            value.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 30),
            value.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            value.widthAnchor.constraint(equalToConstant: 250),
            value.heightAnchor.constraint(equalToConstant: 30),
            
            rangeSlider.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 50),
            rangeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rangeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -200),
            rangeSlider.heightAnchor.constraint(equalToConstant: 30),
            
            rangeSlider2.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 50),
            rangeSlider2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rangeSlider2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -115),
            rangeSlider2.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        value.text = "\(rangeSlider.minValue) ~ \(rangeSlider.maxValue)"
    }
}

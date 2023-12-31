//
//  RangeSlider.swift
//
//  Created by DAEJINLIM on 11/8/23.
//

import UIKit

final class RangeSlider: UIControl {
    private let backgroundBar = UIView()
    private let sliderBar = UIView()
    private let rangeBar = UIView()
    private let minThumb = UIView()
    private let maxThumb = UIView()
    
    private var initialCenter = CGPoint()
    private var minPoint = Int()
    private var maxPoint = Int()
    private var layoutFlag = false
    
    var thumbSize = 27 {
        didSet {
            minThumb.frame = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
            maxThumb.frame = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
            updateThumbShape()
        }
    }
    var trackTintColor: UIColor = .lightGray.withAlphaComponent(0.3) {
        didSet {
            backgroundBar.backgroundColor = trackTintColor
        }
    }
    
    var trackHighlightTintColor: UIColor = .systemBlue {
        didSet {
            rangeBar.backgroundColor = trackHighlightTintColor
        }
    }
    
    var thumbTintColor: UIColor = .white {
        didSet {
            minThumb.backgroundColor = thumbTintColor
            maxThumb.backgroundColor = thumbTintColor
        }
    }
    
    var roundness: CGFloat = 1.0 {
        didSet {
            if roundness < 0.0 { roundness = 0.0 }
            if roundness > 1.0 { roundness = 1.0 }
            updateThumbShape()
        }
    }
    
    var minValue: Int = 0 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    var maxValue: Int = 5 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    var minRange: Int = 0 {
        didSet {
            if minValue < minRange {
                minRange = minValue
            }
        }
    }
    var maxRange: Int = 10 {
        didSet {
            if maxValue > maxRange {
                maxRange = maxValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        makeConstraints()
        configUI()
        configGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layoutFlag == false {
            minPoint = calculatePointFromValue(minValue)
            maxPoint = calculatePointFromValue(maxValue)
            updateRangeStick()
            layoutFlag = true
        }
    }
    
    private func addSubView() {
        addSubview([backgroundBar, sliderBar, rangeBar, minThumb, maxThumb])
    }
    
    private func makeConstraints() {
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        sliderBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBar.heightAnchor.constraint(equalToConstant: 4),
            
            sliderBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            sliderBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(thumbSize / 2)),
            sliderBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat(thumbSize / 2)),
            sliderBar.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    private func configUI() {
        backgroundBar.backgroundColor = trackTintColor
        backgroundBar.layer.cornerRadius = 1.5
        rangeBar.backgroundColor = trackHighlightTintColor
        
        [minThumb, maxThumb].forEach { ball in
            ball.frame = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
            ball.backgroundColor = thumbTintColor
            ball.layer.cornerRadius = ball.frame.width * roundness / 2
            ball.layer.shadowColor = UIColor.black.cgColor
            ball.layer.shadowOffset = CGSize(width: 0, height: 0)
            ball.layer.shadowRadius = 5
            ball.layer.shadowOpacity = 0.2
            ball.layer.masksToBounds = false
        }
    }
    
    private func configGesture() {
        let leftBallPanGesture = UIPanGestureRecognizer(target: self, action: #selector(leftBallPan(_:)))
        minThumb.addGestureRecognizer(leftBallPanGesture)
        minThumb.isUserInteractionEnabled = true
        
        let rightBallPanGesture = UIPanGestureRecognizer(target: self, action: #selector(rightBallPan(_:)))
        maxThumb.addGestureRecognizer(rightBallPanGesture)
        maxThumb.isUserInteractionEnabled = true
    }
    
    private func moveBall(gesture: UIPanGestureRecognizer, ball: UIView) {
        let translation = gesture.translation(in: ball)
        let newCenterX = initialCenter.x + translation.x
        
        switch gesture.state {
        case .began:
            initialCenter = ball.center
        case .changed:
            if ball == minThumb {
                minPoint = Int(newCenterX)
                if minPoint < 0 {
                    minPoint = 0
                }
                if minPoint > (maxPoint - 1) {
                    minPoint = maxPoint - 1
                }
                updateRangeStick()
                minValue = (minPoint) * (maxRange - minRange) / Int(sliderBar.frame.width) + minRange
                if minValue >= maxValue {
                    minValue = maxValue - 1
                }
            }
            if ball == maxThumb {
                maxPoint = Int(newCenterX)
                if maxPoint > Int(sliderBar.frame.width) {
                    maxPoint = Int(sliderBar.frame.width)
                }
                if maxPoint < (minPoint + 1) {
                    maxPoint = minPoint + 1
                }
                maxValue = (maxPoint) * (maxRange - minRange) / Int(sliderBar.frame.width) + minRange
                updateRangeStick()
                if maxValue <= minValue {
                    maxValue = minValue + 1
                }
            }
        case .ended:
            break
        default:
            break
        }
    }
    
    private func calculatePointFromValue(_ value: Int) -> Int {
        return Int((Double(value - minRange) / Double(maxRange - minRange)) * Double(sliderBar.frame.width))
    }
    
    private func updateRangeStick() {
        minThumb.frame.origin.x = CGFloat(minPoint)
        minThumb.center.y = sliderBar.center.y
        
        maxThumb.frame.origin.x = CGFloat(maxPoint)
        maxThumb.center.y = sliderBar.center.y
        
        rangeBar.frame.origin.x = CGFloat(minPoint)
        rangeBar.frame.size.width = CGFloat(maxPoint - minPoint)
        rangeBar.frame.size.height = 4
    }

    
    private func updateThumbShape() {
        let cornerRadius = CGFloat(thumbSize) * roundness / 2
        minThumb.layer.cornerRadius = cornerRadius
        maxThumb.layer.cornerRadius = cornerRadius
    }
    
    @objc func leftBallPan(_ gesture: UIPanGestureRecognizer) {
        moveBall(gesture: gesture, ball: minThumb)
        bringSubviewToFront(minThumb)
    }
    
    @objc func rightBallPan(_ gesture: UIPanGestureRecognizer) {
        moveBall(gesture: gesture, ball: maxThumb)
        bringSubviewToFront(maxThumb)
    }
}

extension UIView {
    func addSubview(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

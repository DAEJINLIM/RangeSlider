//
//  RangeSlider.swift
//
//  Created by DAEJINLIM on 11/8/23.
//

import UIKit

public class RangeSlider: UIControl {
    private let backgroundBar = UIView()
    private let sliderBar = UIView()
    private let rangeBar = UIView()
    private let leftBall = UIView()
    private let rightBall = UIView()
    private let thumbSize = 27
    
    private var initialCenter = CGPoint()
    private var minPoint = Int()
    private var maxPoint = Int()
    private var layoutFlag = false
    
    public var trackTintColor: UIColor = .lightGray.withAlphaComponent(0.3) {
        didSet {
            backgroundBar.backgroundColor = trackTintColor
        }
    }
    
    public var trackHighlightTintColor: UIColor = .systemBlue {
        didSet {
            rangeBar.backgroundColor = trackHighlightTintColor
        }
    }
    
    public var thumbTintColor: UIColor = .white {
        didSet {
            leftBall.backgroundColor = thumbTintColor
            rightBall.backgroundColor = thumbTintColor
        }
    }
    
    public var roundness: CGFloat = 1.0 {
        didSet {
            if roundness < 0.0 { roundness = 0.0 }
            if roundness > 1.0 { roundness = 1.0 }
            updateThumbShape()
        }
    }
    
    public var minValue: Int = 0 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    public var maxValue: Int = 5 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    public var minRange: Int = 0 {
        didSet {
            if minValue < minRange {
                minRange = minValue
            }
        }
    }
    public var maxRange: Int = 10 {
        didSet {
            if maxValue > maxRange {
                maxRange = maxValue
            }
        }
    }
    
    public override init(frame: CGRect) {
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if layoutFlag == false {
//            minPoint = calculatePointFromValue(minValue)
//            maxPoint = calculatePointFromValue(maxValue)
//            updateRangeStick()
//            layoutFlag = true
//        }
//    }
    
    private func addSubView() {
        addSubview([backgroundBar, sliderBar, rangeBar, leftBall, rightBall])
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
        
        [leftBall, rightBall].forEach { ball in
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
        leftBall.addGestureRecognizer(leftBallPanGesture)
        leftBall.isUserInteractionEnabled = true
        
        let rightBallPanGesture = UIPanGestureRecognizer(target: self, action: #selector(rightBallPan(_:)))
        rightBall.addGestureRecognizer(rightBallPanGesture)
        rightBall.isUserInteractionEnabled = true
    }
    
    private func moveBall(gesture: UIPanGestureRecognizer, ball: UIView) {
        let translation = gesture.translation(in: ball)
        let newCenterX = initialCenter.x + translation.x
        
        switch gesture.state {
        case .began:
            initialCenter = ball.center
        case .changed:
            if ball == leftBall {
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
            if ball == rightBall {
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
        leftBall.frame.origin.x = CGFloat(minPoint)
        leftBall.center.y = sliderBar.center.y
        
        rightBall.frame.origin.x = CGFloat(maxPoint)
        rightBall.center.y = sliderBar.center.y
        
        rangeBar.frame.origin.x = CGFloat(minPoint)
        rangeBar.frame.size.width = CGFloat(maxPoint - minPoint)
        rangeBar.frame.size.height = 4
    }

    
    private func updateThumbShape() {
        let cornerRadius = CGFloat(thumbSize) * roundness / 2
        leftBall.layer.cornerRadius = cornerRadius
        rightBall.layer.cornerRadius = cornerRadius
    }
    
    @objc func leftBallPan(_ gesture: UIPanGestureRecognizer) {
        moveBall(gesture: gesture, ball: leftBall)
        bringSubviewToFront(leftBall)
    }
    
    @objc func rightBallPan(_ gesture: UIPanGestureRecognizer) {
        moveBall(gesture: gesture, ball: rightBall)
        bringSubviewToFront(rightBall)
    }
}

extension UIView {
    func addSubview(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}

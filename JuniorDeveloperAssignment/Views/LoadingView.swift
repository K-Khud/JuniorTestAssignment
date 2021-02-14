//
//  LoadingView.swift
//  ReaktorJDAssignment
//
//  Created by Ekaterina Khudzhamkulova on 28.11.2020.
//

import UIKit

class LoadingView: UIView {
	// Layer for displaying loading progress
	private let shapeLayer = CAShapeLayer()
	// Layer for displaying loading curve path
	private let trackLayer = CAShapeLayer()
	private var loadingProgress = 0

	private let label: UILabel = {
		let label 			= UILabel()
		label.font 			= UIFont.systemFont(ofSize: 30)
		label.text 			= "Loading"
		label.textColor 	= UIColor.systemGray4
		label.textAlignment = .center
		return label
	}()

    override func draw(_ rect: CGRect) {
		let circularPath = UIBezierPath(
			arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2),
			radius: 100,
			startAngle: -CGFloat.pi / 2,
			endAngle: 3 * CGFloat.pi / 2,
			clockwise: true)
		shapeLayer.path 		= circularPath.cgPath
		shapeLayer.strokeColor 	= UIColor.systemPink.cgColor
		shapeLayer.lineWidth 	= 10
		shapeLayer.opacity 		= 0.8
		shapeLayer.lineCap 		= .round
		shapeLayer.fillColor 	= UIColor.clear.cgColor

		trackLayer.path 		= circularPath.cgPath
		trackLayer.strokeColor 	= UIColor.gray.cgColor
		trackLayer.opacity 		= 0.2
		trackLayer.lineWidth 	= 8
		trackLayer.fillColor 	= UIColor.clear.cgColor

		layer.addSublayer(trackLayer)
		layer.addSublayer(shapeLayer)
    }

	override func layoutSubviews() {
		pulsingAnimation()
		strokeEndAnimation()
		setupLabel()
	}
// MARK: - Private methods
	private func strokeEndAnimation() {
		let animation 					= CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
		animation.fromValue 			= 0
		animation.toValue 				= 1
		animation.duration 				= 0.7
		animation.fillMode 				= .forwards
		animation.isRemovedOnCompletion = false
		shapeLayer.add(animation, forKey: "strokeEndAnimation")
	}

	private func pulsingAnimation() {
		let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
		animation.fromValue 		= 8
		animation.toValue 			= 30
		animation.duration 			= 1
		animation.autoreverses 		= true
		animation.repeatCount 		= .infinity
		trackLayer.add(animation, forKey: "pulsingAnimation")
	}

	private func setupLabel() {
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
	}
}

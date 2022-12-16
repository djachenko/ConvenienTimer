//
// Created by justin on 14.12.2022.
//

import UIKit

extension UIView {
    var boundsCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}

protocol CircleViewDelegate: AnyObject {
    func didChangeValue()
}

class CircleView: UIView {
    @IBInspectable private var lineWidth: CGFloat = 0 {
        didSet {
            relayout()
        }
    }

    @IBInspectable private var color: UIColor = .black {
        didSet {
            relayout()
        }
    }

    private var shapeLayer: CAShapeLayer?
    private var backgroundLayer: CAShapeLayer?

    private(set) var value: CGFloat = 0

    weak var delegate: CircleViewDelegate?

    var debounceTimer:Timer?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        relayout()
        setupGestures()
    }

    func relayout() {
        backgroundLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()

        backgroundLayer = buildLayer(color: color.withAlphaComponent(0.1), strokeEnd: 1)
        shapeLayer = buildLayer(color: color, strokeEnd: value)

        layer.addSublayer(backgroundLayer!)
        layer.addSublayer(shapeLayer!)
    }

    private func setupGestures() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
    }

    private func buildLayer(color: UIColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let startAngle: CGFloat = -.pi / 2
        let endAngle: CGFloat = -2 * .pi + startAngle

        let path = UIBezierPath(
                arcCenter: boundsCenter,
                radius: (bounds.width - lineWidth) / 2,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
        )

        let shapeLayer = CAShapeLayer()

        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor

        return shapeLayer
    }

    func set(value: CGFloat) {
        if value == 0 {
            self.value = 0.0001
        } else {
            self.value = value
        }

        animateEnd()
    }

    static let animationKey = "stroke end"

    private func animateEnd() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.toValue = value //?
        animation.duration = CFTimeInterval(1)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true

        shapeLayer?.strokeEnd = value

        shapeLayer?.add(animation, forKey: CircleView.animationKey)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let radius = sqrt(pow(point.x - boundsCenter.x, 2) + pow(point.y - boundsCenter.y, 2))

        let answer = abs((bounds.width - lineWidth) / 2 - radius) < lineWidth

        return answer
    }

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
//        debounceTimer?.invalidate()
//        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { [weak self] _ in
//            guard let self else {
//                return
//            }

            let location = sender.location(in: self)

            let dx = location.x - self.boundsCenter.x
            let dy = location.y - self.boundsCenter.y

            let radius = sqrt(pow(dx, 2) + pow(dy, 2))

            let cosAngle = acos(-dy / radius)

            let angle: Double

            if dx > 0 {
                angle = 2 * .pi - cosAngle
            } else {
                angle = cosAngle
            }

            let t = angle / (2 * .pi)

            self.value = t

            self.delegate?.didChangeValue()
//        }
    }
}

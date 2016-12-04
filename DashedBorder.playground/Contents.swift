import UIKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 100, height: 200)
let dashedView = UIView(frame: frame)
dashedView.backgroundColor = .black

let shapeLayer = CAShapeLayer()

let path = CGMutablePath()
path.addRect(frame)
shapeLayer.path = path
shapeLayer.backgroundColor = UIColor.purple.cgColor
shapeLayer.frame = frame
shapeLayer.position = dashedView.center
shapeLayer.strokeColor = UIColor.yellow.cgColor
shapeLayer.lineWidth = 4.0
shapeLayer.lineDashPattern = [8, 8]
shapeLayer.cornerRadius = 20

dashedView.layer.addSublayer(shapeLayer)
dashedView
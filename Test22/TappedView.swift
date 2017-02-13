//
//  TappedView.swift
//  Test22
//
//  Created by NRokudaime on 04.02.17.
//  Copyright © 2017 NRokudaime. All rights reserved.
//

import UIKit

class TappedView: UIView {
    
    fileprivate enum Surface {
        case xMax
        case yMax
        case yMin
        case xMin
    }
    fileprivate var touches: Set<UITouch>?
    
    func setTouches(touches: Set<UITouch>) {
        if self.touches != nil {
            for touch in touches {
                self.touches?.insert(touch)
            }
        } else {
            self.touches = touches
        }
        setNeedsDisplay()
    }
    
    func removeTouches(touches: Set<UITouch>) {
        for touch in touches {
            _ = self.touches?.remove(touch)
        }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(),
            let touches = touches {
            context.setLineWidth(3)
            for touch in touches {
                let tapPoint = touch.location(in: self)
                context.setStrokeColor(color)
                let angle = angleBetween(startPoint: center, endPoint: tapPoint)
                let centerX = Float(center.x)
                let centerY = Float(center.y)

                let hipo = Float((bounds.width / 2)) / cos(angle)
                var endPoint = CGPoint(x: Double(cos(angle) * abs(hipo) + centerX),
                                       y: Double(sin(angle) * abs(hipo) + centerY))
                endPoint = clipPoint(point: endPoint)
                
                context.addLines(between: [center, endPoint])
                var startPoint = center
                for _ in (0..<2) {
                    if let newPoint = mirrorPoint(for: startPoint, endPoint: endPoint) {
                        context.addLines(between: [endPoint, newPoint])
                        startPoint = endPoint
                        endPoint = newPoint
                    }
                }
            }
            context.strokePath()
        }
    }
    
     fileprivate func mirrorPoint(for startPoint: CGPoint, endPoint: CGPoint) -> CGPoint? {
        let coeffX = abs(endPoint.x - startPoint.x) / abs(endPoint.y - startPoint.y)
        let coeffY = abs(endPoint.y - startPoint.y) / abs(endPoint.x - startPoint.x)
        var newPoint = CGPoint.zero
        
        if let surf = getSurface(point: endPoint) {
            switch surf {
            case .xMax:
                if endPoint.y < bounds.height / 2 {
                    
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < endPoint.y
                    
                    newPoint.x = 0
                    newPoint.y = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newPoint.y = endPoint.y - bounds.width / coeffX
                    } else {
                        newPoint.x = endPoint.x - endPoint.y / coeffY
                    }
                } else {
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < bounds.height - endPoint.y
                    
                    newPoint.x = 0
                    newPoint.y = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newPoint.y = endPoint.y + bounds.width / coeffX
                    } else {
                        newPoint.x = endPoint.x - endPoint.y / coeffY
                    }
                }
            case .xMin:
                if endPoint.y < bounds.height / 2 {
                    
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < endPoint.y
                    
                    newPoint.x = bounds.width
                    newPoint.y = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newPoint.y = endPoint.y - bounds.width / coeffX
                    } else {
                        newPoint.x = endPoint.x + endPoint.y / coeffY
                    }
                } else {
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < bounds.height - endPoint.y
                    newPoint.x = bounds.width
                    newPoint.y = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newPoint.y = endPoint.y + bounds.width / coeffX
                    } else {
                        newPoint.x = (bounds.height - endPoint.y) / coeffY
                    }
                }
            case .yMax:
                if endPoint.x < bounds.width / 2 {
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < endPoint.x
                    
                    newPoint.x = startPoint.x > endPoint.x ? 0 : bounds.width
                    newPoint.y = startPoint.x > endPoint.x ? 0 : bounds.height
                    if nextEdgeIsY {
                        newPoint.x = endPoint.x - bounds.height / coeffY
                    } else {
                        newPoint.y = endPoint.y - endPoint.x / coeffX
                    }
                } else {
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < (bounds.width - endPoint.x)
                    
                    newPoint.x = startPoint.x > endPoint.x ? 0 : bounds.width
                    newPoint.y = 0
                    if nextEdgeIsY {
                        newPoint.x = endPoint.x + bounds.height / coeffY
                    } else {
                        newPoint.y = endPoint.y - (bounds.width - endPoint.x) / coeffX
                    }
                }
            case .yMin:
                if endPoint.x < bounds.width / 2 {
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < endPoint.x
                    newPoint.x = startPoint.x < endPoint.x ? bounds.width : 0
                    newPoint.y = bounds.height
                    if nextEdgeIsY {
                        newPoint.x = endPoint.x - bounds.height / coeffY
                    } else {
                        newPoint.y = endPoint.y + endPoint.x / coeffX
                    }
                } else {
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < (bounds.width - endPoint.x)
                    
                    newPoint.x = startPoint.x < endPoint.x ? bounds.width : 0
                    newPoint.y = startPoint.x < endPoint.x ? bounds.height : 0
                    if nextEdgeIsY {
                        newPoint.x = endPoint.x + bounds.height / coeffY
                    } else {
                        newPoint.y = (bounds.width - endPoint.x) / coeffX
                    }
                }
            }
        }
        return newPoint
    }
    
    fileprivate func angleBetween(startPoint: CGPoint, endPoint: CGPoint) -> Float {
        let originPoint = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
        return atan2f(Float(originPoint.y), Float(originPoint.x))
    }
    
    fileprivate func clipPoint(point: CGPoint) -> CGPoint {
        var normalizedPoint = point
        if point.y < 0 || point.y > bounds.height {
            let yLenth = abs(point.y - center.y)
            let xLenth = abs(point.x - center.x)
            let coefficient = max(yLenth, xLenth) / min(yLenth, xLenth)
            let edgeY = point.y <= 0 ? 0 : bounds.height
            let distanceYToEdge = abs(edgeY - point.y)
            let unsignedXOffset = distanceYToEdge/coefficient
            let xOffset = point.x == 0 ? -unsignedXOffset : unsignedXOffset
            let xPoint = point.x - xOffset
            normalizedPoint = CGPoint(x: xPoint, y: edgeY)
        }
        if normalizedPoint.x < 0 || normalizedPoint.x > bounds.width {
            let xLenth = abs(normalizedPoint.x - center.x)
            let yLenth = abs(normalizedPoint.y - center.y)
            let coefficient = xLenth/yLenth
            let edgeX = normalizedPoint.x < 0 ? 0 : bounds.width
            let distanceXToEdge = abs(edgeX - normalizedPoint.x)
            let unsignedYOffset = distanceXToEdge/coefficient
            let yOffset = normalizedPoint.y == 0 ? -unsignedYOffset : unsignedYOffset
            let yPoint = normalizedPoint.y - yOffset
            normalizedPoint = CGPoint(x: edgeX, y: yPoint)
        }
        return normalizedPoint
    }
    
    fileprivate func getSurface(point: CGPoint) -> Surface? {
        if point.x <= 0 {
            return .xMin
        } else if point.x >= bounds.width {
            return .xMax
        } else if point.y <= 0 {
            return .yMin
        } else if point.y >= bounds.height {
            return .yMax
        }
        return nil
    }
    
    var color: CGColor {
        let hue:CGFloat = ( CGFloat(arc4random() % 256) / 256 )
        let saturation:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        let brightness:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        return color.cgColor
    }
}

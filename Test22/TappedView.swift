//
//  TappedView.swift
//  Test22
//
//  Created by NRokudaime on 04.02.17.
//  Copyright © 2017 NRokudaime. All rights reserved.
//

import UIKit

class TappedView: UIView {
    
    enum Surface {
        case xMax
        case yMax
        case yMin
        case xMin
    }
    var touches: [UITouch]?

    var tapPoint: CGPoint? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(),
            let tapPoint = tapPoint {
            context.setLineWidth(3)
            context.setStrokeColor(UIColor.black.cgColor)
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
            context.strokePath()
        }
    }
    
    func mirrorPoint(for startPoint: CGPoint, endPoint: CGPoint) -> CGPoint? {
        let coeffX = abs(endPoint.x - startPoint.x) / abs(endPoint.y - startPoint.y)
        let coeffY = abs(endPoint.y - startPoint.y) / abs(endPoint.x - startPoint.x)
        
        if let surf = getSurface(point: endPoint) {
            switch surf {
            case .xMax:
                if endPoint.y < bounds.height / 2 {
                    
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < endPoint.y
                    
                    var newX:CGFloat = 0
                    var newY:CGFloat = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newY = endPoint.y - bounds.width / coeffX
                    } else {
                        newX = endPoint.x - endPoint.y / coeffY
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                } else {
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < bounds.height - endPoint.y
                    
                    var newX:CGFloat = 0
                    var newY:CGFloat = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newY = endPoint.y + bounds.width / coeffX
                    } else {
                        newX = endPoint.x - endPoint.y / coeffY
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                }
            case .xMin:
                if endPoint.y < bounds.height / 2 {
                    
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < endPoint.y
                    
                    var newX:CGFloat = bounds.width
                    var newY:CGFloat = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newY = endPoint.y - bounds.width / coeffX
                    } else {
                        newX = endPoint.x + endPoint.y / coeffY
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                } else {
                    let xx = bounds.width / coeffX
                    let nextEdgeIsX = xx < bounds.height - endPoint.y
                    
                    var newX:CGFloat = bounds.width
                    var newY:CGFloat = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsX {
                        newY = endPoint.y + bounds.width / coeffX
                    } else {
                        newX = (bounds.height - endPoint.y) / coeffY
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                }
            case .yMax:
                if endPoint.x < bounds.width / 2 {
                    
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < endPoint.x
                    
                    var newX:CGFloat = startPoint.x > endPoint.x ? 0 : bounds.width
                    var newY:CGFloat = startPoint.x > endPoint.x ? 0 : bounds.height
                    if nextEdgeIsY {
                        newX = endPoint.x - bounds.height / coeffY
                    } else {
                        newY = endPoint.y - endPoint.x / coeffX
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                } else {
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < (bounds.width - endPoint.x)
                    
                    var newX:CGFloat = startPoint.x > endPoint.x ? 0 : bounds.width
                    var newY:CGFloat = startPoint.x > endPoint.x ? 0 : bounds.height
                    if nextEdgeIsY {
                        newX = endPoint.x + bounds.height / coeffY
                    } else {
                        newY = endPoint.y - (bounds.width - endPoint.x) / coeffX
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                }
            case .yMin:
                if endPoint.x < bounds.width / 2 {
                    
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < endPoint.x
                    
                    var newX:CGFloat = bounds.width
                    var newY:CGFloat = startPoint.y > endPoint.y ? 0 : bounds.height
                    if nextEdgeIsY {
                        newX = endPoint.x - bounds.height / coeffY
                    } else {
                        newY = endPoint.y + endPoint.x / coeffX
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                } else {
                    let yy = bounds.height / coeffY
                    let nextEdgeIsY = yy < (bounds.width - endPoint.x)
                    
                    var newX:CGFloat = startPoint.x < endPoint.x ? bounds.width : 0
                    var newY:CGFloat = startPoint.x < endPoint.x ? bounds.height : 0
                    if nextEdgeIsY {
                        newX = endPoint.x + bounds.height / coeffY
                    } else {
                        newY = (bounds.width - endPoint.x) / coeffX
                    }
                    let newPoint = CGPoint(x: newX, y: newY)
                    return newPoint
                }
            }
        }
        return nil
    }
    
    func angleBetween(startPoint: CGPoint, endPoint: CGPoint) -> Float {
        let originPoint = CGPoint(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y)
        return atan2f(Float(originPoint.y), Float(originPoint.x))
    }
    
    func clipPoint(point: CGPoint) -> CGPoint {
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
    
    func getSurface(point: CGPoint) -> Surface? {
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
}

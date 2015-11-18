/*

    ARに関する処理
    　クラスメソッドしか作っていない

*/

import Foundation
import UIKit

class ARHelper {
    
    static let VIEW_ANGLE : Double  =  M_PI / 6.0 //30°
    static let NOT_EXIST  : Double  =  1000
    static let EARTH_R    : Double  = 6371
    
    
    // パブリック関数
    class func isExist(#viewPOI : POI , posPOI : POI , heading : Double ) -> Double {
        
        let angle = getAngle(viewLat: viewPOI.latitude, viewLon: viewPOI.longitude
            , posLat: posPOI.latitude , posLon: posPOI.longitude)
        let trueHeading = degToRad(getRegularAngle(heading))
        var target_azimuth = trueHeading - angle

        
        //正規化
        if target_azimuth <= (-1.0) * M_PI {
            target_azimuth += 2 * M_PI
        }
        
        if target_azimuth >= ( M_PI) {
            target_azimuth -= 2 * M_PI
        }
        
        
        if getRegularRad(target_azimuth) < VIEW_ANGLE && (-VIEW_ANGLE) < getRegularRad(target_azimuth) {
            
            
            return radToDeg(target_azimuth)
        } else {
            //println("")
            return NOT_EXIST
        }
    }
    
    class func getVerticalAngle(#viewPOI : POI , posPOI : POI) -> Double {
        let angle =
            atan2( viewPOI.altitude - posPOI.altitude,
            getDistance(viewLat: viewPOI.latitude, viewLon: viewPOI.longitude, posLat: posPOI.latitude, posLon: posPOI.longitude))
        
        return angle
    }
    
    /**
    0 <= x < 360から -180 < 0 <= 180に角度を変更する
    
    - parameter angle: 0 <= x < 360の角度
    */
    class func getRegularAngle(angle : Double ) -> Double {
        if angle <= 180 {
            return angle
        } else {
            return angle - 360
        }
    }
    
    class func getRegularRad(rad : Double) -> Double {
        if rad <= M_PI {
            return rad
        } else {
            return rad - 2 * M_PI
        }
    }
    
    // プライベート関数
    class private func getAngle(#viewLat : Double , viewLon : Double , posLat : Double , posLon : Double) -> Double {
        
        let lonDiff = degToRad(posLon - viewLon)
        let latDiff = degToRad(posLat - viewLat)
        let azimuth = (M_PI_2) - atan(latDiff / lonDiff)
        
        if lonDiff > 0 {
            return azimuth
        } else if lonDiff < 0 {
            return azimuth + M_PI
        } else if latDiff < 0 {
            return M_PI
        }
        
        return 0.0
    }
    
    class private func getDistance(#viewLat : Double , viewLon : Double , posLat : Double , posLon : Double) -> Double {
        let distance = EARTH_R * acos( sin(viewLat) * sin(posLat) + cos(viewLat) * cos(posLat) * cos(viewLat - posLat) )
        //println("distance : \(distance)")
        return distance
    }
    
    class private func getVector(#viewLat : Double , viewLon : Double , posLat : Double , posLon : Double) -> (dx : Double , dy : Double) {
        let theta      : Double = degToRad(viewLon)
        let deltaTheta : Double = degToRad(posLon - viewLon)
        let deltaPhi   : Double = degToRad(posLat - viewLat)
        
        let dx         : Double = deltaPhi * cos(theta)
        let dy         : Double = deltaTheta
        
        //print("vector dy:\(dy) , dx:\(dx) ")
        
        return (dx : dx , dy : dy)
    }
    
    class func degToRad(degree : Double) -> Double {
        return degree * M_PI / 180.0
    }
    
    class func radToDeg(radian : Double) -> Double {
        return radian * 180.0 / M_PI
    }
    
    class private func diffAngle(rad1 : Double , rad2 : Double) -> Double {
        return  ( rad2 - rad1 )
    }

    
}
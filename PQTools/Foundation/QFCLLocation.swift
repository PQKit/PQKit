

import Foundation
import CoreLocation

public struct PQLocation<T>: PQType {
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension CLLocation {
    public var pq: PQLocation<CLLocation> {
        return PQLocation(pq: self)
    }
}

public extension PQLocation where WrapperType == CLLocation {
    var toString: String {
        
        let latitude = String(format: "%.3f", pq.coordinate.latitude)
        let longitude = String(format: "%.3f", pq.coordinate.longitude)
        
        return "\(latitude), \(longitude)"
    }
}

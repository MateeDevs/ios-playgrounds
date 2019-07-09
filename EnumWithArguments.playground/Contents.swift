import UIKit

/// Array of vehicle reports
public enum VehicleHealthReports {
    case v1([VehicleHealthReportV1])
    case v2([VehicleHealthReportV2])
}

/// Report entity from vehicle health.
public protocol VehicleHealthReport { }

/// Report entity from vehicle health.
///
/// - Note: Version 1 (MOD2), older reports available via id.
///
public struct VehicleHealthReportV1: VehicleHealthReport {
    
    /// identifier of report
    public let id: String
    /// timestamp of report
    public let timestamp: Date
    /// mileage of report
    public let mileage: Int
    
    public init(id: String, timestamp: Date, mileage: Int) {
        self.id = id
        self.timestamp = timestamp
        self.mileage = mileage
    }
    
}

/// Report entity from vehicle health.
///
/// - Note: Version 2 (MOD3), only current report is available.
///
public struct VehicleHealthReportV2: VehicleHealthReport {
    
    /// timestamp of report
    public let timestamp: Date
    /// mileage of report
    public let mileage: Int
    
    public init(timestamp: Date, mileage: Int) {
        self.timestamp = timestamp
        self.mileage = mileage
    }
    
}

let reportV1 = VehicleHealthReportV1(id: "id", timestamp: Date(), mileage: 100)

let reports: VehicleHealthReports = .v1([reportV1])

if case .v1(let reps) = reports {
    print(reps.first?.id ?? "")
}

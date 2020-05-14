import Foundation

public struct Property: Codable {
    
    public let id: String
    private let parametersString: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case parameters
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        
        // It is not possible to directly use the value of "parameters"
        // We have to decode "parameters" from JSON, encode back to JSON and save as a string
        if let parametersArray = try container.decodeIfPresent([PropertyParameter].self, forKey: .parameters),
            let jsonData = try? JSONEncoder().encode(parametersArray),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            parametersString = jsonString
        } else {
            parametersString = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(parameters, forKey: .parameters)
    }
}

extension Property {
    public var parameters: [PropertyParameter]? {
        guard let jsonData = parametersString?.data(using: .utf8) else { return nil }
        do {
            return try JSONDecoder().decode([PropertyParameter].self, from: jsonData)
        } catch {
            return nil
        }
    }
}

public enum PropertyParameterName: String, Codable {
    case unknown
    case floor
    case countOfFloor
    case ownership
    case structure
    case terrace
    case balcony
    case garage
    case lift
    case cellar
}

// Solution 1: value as String

//public struct PropertyParameter: Codable {
//    public let name: PropertyParameterName
//    public let value: String
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case value
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decodeIfPresent(PropertyParameterName.self, forKey: .name) ?? .unknown
//
//        if let value = try? container.decodeIfPresent(Int.self, forKey: .value) {
//            self.value = String(value)
//        } else if let value = try? container.decodeIfPresent(Bool.self, forKey: .value) {
//            self.value = value ? "true" : "false"
//        } else {
//            self.value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(name.rawValue, forKey: .name)
//
//        if let value = Int(value) {
//            try container.encodeIfPresent(value, forKey: .value)
//        } else if value == "true" {
//            try container.encodeIfPresent(true, forKey: .value)
//        } else if value == "false" {
//            try container.encodeIfPresent(false, forKey: .value)
//        } else {
//            try container.encodeIfPresent(value, forKey: .value)
//        }
//    }
//}
//
//extension Property {
//    public var floor: Int? { Int(getValue(for: .floor) ?? "") }
//
//    private func getValue(for name: PropertyParameterName) -> String? {
//        guard let parameters = parameters else { return nil }
//        return parameters.filter({ $0.name == name }).first?.value ?? nil
//    }
//}

// Solution 2: value as Any

//public struct PropertyParameter: Codable {
//    public let name: PropertyParameterName
//    public let value: Any?
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case value
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decodeIfPresent(PropertyParameterName.self, forKey: .name) ?? .unknown
//
//        if let value = try? container.decodeIfPresent(Int.self, forKey: .value) {
//            self.value = value
//        } else if let value = try? container.decodeIfPresent(Bool.self, forKey: .value) {
//            self.value = value
//        } else if let value = try? container.decodeIfPresent(String.self, forKey: .value) {
//            self.value = value
//        } else {
//            self.value = nil
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(name.rawValue, forKey: .name)
//
//        if let value = value as? Int {
//            try container.encodeIfPresent(value, forKey: .value)
//        } else if let value = value as? Bool {
//            try container.encodeIfPresent(value, forKey: .value)
//        } else if let value = value as? String {
//            try container.encodeIfPresent(value, forKey: .value)
//        }
//    }
//}
//
//extension Property {
//    public var floor: Int? { getValue(for: .floor) as? Int }
//
//    private func getValue(for name: PropertyParameterName) -> Any? {
//        guard let parameters = parameters else { return nil }
//        return parameters.filter({ $0.name == name }).first?.value ?? nil
//    }
//}

// Solution 3: value as enum with associated values
// https://stackoverflow.com/a/48388443

public struct PropertyParameter: Codable {
    public let name: PropertyParameterName
    public let value: PropertyParameterValue
}

public enum PropertyParameterValue: Codable {
    case unknown
    case int(Int)
    case bool(Bool)
    case string(String)

    public init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(value)
        } else if let value = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(value)
        } else {
            self = .unknown
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        default:()
        }
    }

    var intValue: Int? {
        switch self {
        case .int(let value): return value
        default: return nil
        }
    }
}

extension Property {
    public var floor: Int? { getValue(for: .floor).intValue }

    private func getValue(for name: PropertyParameterName) -> PropertyParameterValue {
        guard let parameter = parameters?.filter({ $0.name == name }).first else { return .unknown }
        return parameter.value
    }
}

let jsonString = """
{
  "id": "abc",
  "parameters": [
    {
      "name": "floor",
      "value": 4
    },
    {
      "name": "ownership",
      "value": "COOPERATIVE"
    },
    {
      "name": "structure",
      "value": "BRICK"
    },
    {
      "name": "terrace",
      "value": true
    },
    {
      "name": "balcony",
      "value": false
    },
    {
      "name": "garage",
      "value": false
    },
    {
      "name": "lift",
      "value": false
    }
  ]
}
"""
let jsonData = jsonString.data(using: String.Encoding.utf8)!

// Convert from JSON to Property
if let property = try? JSONDecoder().decode(Property.self, from: jsonData) {
    print(property)
    print("-----")
    print(property.parameters ?? "")
    print("-----")
    print(property.floor ?? "")
    print("-----")
    
    // Convert from Property back to JSON
    if let jsonData = try? JSONEncoder().encode(property),
        let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }
}

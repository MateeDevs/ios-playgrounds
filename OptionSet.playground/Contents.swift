import Foundation

// Step 1: Define a new set with options
public struct UserIdentity: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let connect = UserIdentity(rawValue: 1 << 0)
    public static let smartlink = UserIdentity(rawValue: 1 << 1)
}

// Step 2: Create a new instance of that set according to some conditions
public var userIdentity: [UserIdentity] {
    var identity: [UserIdentity] = []
    if true {
        identity.append(.connect)
    }
    if false {
        identity.append(.smartlink)
    }
    return identity
}

// Step 3: Use it wherever you want
if userIdentity.contains(.connect) {
    print("User has connect identity")
}
if userIdentity.contains(.smartlink) {
    print("User has smartlink identity")
}

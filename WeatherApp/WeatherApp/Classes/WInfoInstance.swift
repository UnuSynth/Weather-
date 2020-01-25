import Foundation

class WInfoInstance: NSObject
{
    var key: String;
    var location: String;
    
    init(with key: String, location: String)
    {
        self.key = key;
        self.location = location;
    }
}

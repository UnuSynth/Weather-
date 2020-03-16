import Foundation
import UIKit

class WeatherAgent: NSObject
{
    public var json: [String: AnyObject];
    
    override init()
    {
        json = [:];
        super.init();
    }
    
    func requestForData(instance: WInfoInstance, sign: DispatchSemaphore)
    {
        let urlString = "http://api.weatherstack.com/current?access_key=\(instance.key)&query=\(instance.location.replacingOccurrences(of: " ", with: "%20"))";
        
        let url = URL(string: urlString);
        
        let task = URLSession.shared.dataTask(with: url!)
        {
            (data, response, error) in
            do
            {
                self.json = try JSONSerialization.jsonObject(with: data!,
                                                             options: .mutableContainers) as! [String : AnyObject];
                
                sign.signal();
            }
            
            catch let JSONError
            {
                print(JSONError);
            }
        }
        
        task.resume();
        
    }
    
    func getLocation() -> String?
    {
        var locationName:String? = "Nothing to show";
        
        if let location = self.json["location"]
        {
            locationName = location["name"] as? String;
        }
        
        return locationName;
    }
    
    func getTemp() -> Double
    {
        var temp: Double? = 0;
        
        if let current = self.json["current"]
        {
            temp = current["temperature"] as? Double;
        }
        
        return temp!;
    }
    
    func getWeatherCodeAndDescription() -> (code: Int, description: String)
    {
        var code: Int? = 0;
        var description: String? = "";
        
        if let current = self.json["current"]
        {
            code = current["weather_code"]! as? Int;
            
            if let descriptions = current["weather_descriptions"]
            {
                for tempDescription in (descriptions as? NSMutableArray)!
                {
                    description?.append(contentsOf: tempDescription as! String)
                }
            }
        }
        
        return (code!, description!);
    }
    
    func isErrorOccured() -> [String:String]?
    {
        if let error = json["error"]
        {
            let errors = ["type":error["type"] as! String ,
                          "info":error["info"] as! String];
            
            return errors;
        }
        
        return nil;
    }
}

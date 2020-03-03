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
    
    func getWeatherIcon() -> UIImage
    {
        var imageURLStr: String? = nil;
        var image: UIImage? = nil;
        let sign = DispatchSemaphore(value: 0);
        
        if let current = self.json["current"]
        {
            let imageURLsArr = current["weather_icons"] as! NSArray;
            imageURLStr = imageURLsArr[0] as? String;
        }
        
        let url = URL(string: imageURLStr!);
        
        let task = URLSession.shared.dataTask(with: url!)
        {
            (data, response, error) in
            image = UIImage(data: data!);
            
            sign.signal();
            
            // TODO problems with converting data into image
        }
        
        task.resume();
        
        sign.wait();
        
        return image!;
    }
    
    func isErrorOccured() -> Bool
    {
        if (self.json["error"] != nil)
        {
            return true;
        }
        
        return false;
    }
}

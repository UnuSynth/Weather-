import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    let key = "2a102e7a45649e720aabba7b8b830e16";
    let agent = WeatherAgent();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        searchBar.delegate = self;
        
        backgroundImageView.image = nil; //TODO - Find suitable sketch and add background image!
    }
    
    func createAlert(alertTitle: String,
                     alertMessage: String,
                     alertType: String) -> UIAlertController
    {
        let alert: UIAlertController;
        switch alertType
        {
        case "Error":
            alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil));
            
        case "ShowCode":
            alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil));
            
        //TODO когда понадобятся алерты с выбором действия, тогда добавить сюда обработчик для соответствующего алерта
        default:
            alert = UIAlertController(title: "Error!",
                                      message: "An unidentified error has occured!",
                                      preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil));
        }
        
        return alert;
    }
    
    func setWeatherIcon(code: Int)
    {
        switch code
        {
        case 113:
            weatherIcon.image = #imageLiteral(resourceName: "CuteIcons-Sunny");
            
        case 116:
            weatherIcon.image = #imageLiteral(resourceName: "CuteIcons-CloudySun");
            
        case 119:
            weatherIcon.image = #imageLiteral(resourceName: "CuteIcons-Cloudy");
            
        case 122:
            weatherIcon.image = #imageLiteral(resourceName: "CuteIcons-Clouds");
            
        case 143:
            weatherIcon.image = #imageLiteral(resourceName: "4894545 - cloud clouds day summer sun sunny weather");
            
        case 248:
            weatherIcon.image = #imageLiteral(resourceName: "BlueIcons-Fog");
            
        default:
            weatherIcon.image = #imageLiteral(resourceName: "Background 2");
        }
    }
}

extension ViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder();
        
        let infoInstance = WInfoInstance(with: key,
                                         location: searchBar.text!);
        
        let sign = DispatchSemaphore(value: 0);
        
        agent.requestForData(instance: infoInstance,
                             sign: sign);
        
        sign.wait();
        
        if let agentError = agent.isErrorOccured()
        {
            self.present(createAlert(alertTitle: agentError["type"]!,
                                     alertMessage: agentError["info"]!,
                                     alertType: "Error"),
                         animated: true,
                         completion: nil);
        }
            
        else
        {
            self.placeLabel.text = agent.getLocation();
            self.tempLabel.text = "\(agent.getTemp())˚C";
            self.setWeatherIcon(code: agent.getWeatherCode());
            self.present(createAlert(alertTitle: "Weather code",
                                     alertMessage: "\(agent.getWeatherCode())",
                                     alertType: "ShowCode"),
                         animated: true,
                         completion: nil);
            self.tempLabel.isHidden = false;
        }
    }
}

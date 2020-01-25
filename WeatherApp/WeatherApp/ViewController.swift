import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    let key = "2a102e7a45649e720aabba7b8b830e16";
    let agent = WeatherAgent();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        searchBar.delegate = self;
    }
}

extension ViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder();
        
        let infoInstance = WInfoInstance(with: key, location: searchBar.text!);
    
        let sign = DispatchSemaphore(value: 0);
        
        agent.requestForData(instance: infoInstance, sign: sign);
        
        sign.wait();
        
        if agent.isErrorOccured()
        {
            placeLabel.text = "An error occured!";
            tempLabel.isHidden = true;
        }
            
        else
        {
            self.placeLabel.text = agent.getLocation();
            self.tempLabel.text = "\(agent.getTemp())";
            self.tempLabel.isHidden = false;
        }
    }
}

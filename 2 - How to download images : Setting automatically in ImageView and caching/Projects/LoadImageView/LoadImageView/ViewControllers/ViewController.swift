import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cachaImageView: CacheImageView! //Class is CacheImageView not UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cachaImageView.loadImageFrom(urlString: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1200px-Apple_logo_black.svg.png")
    }


}


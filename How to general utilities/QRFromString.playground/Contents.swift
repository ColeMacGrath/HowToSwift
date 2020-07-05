//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 200, height: 200)
        
        let qrText = "My Custom Text"
        
        if let ciImage = qrText.qrImage(using: .darkGray) {
            imageView.image = UIImage(ciImage: ciImage)
        }
        
        
        view.addSubview(imageView)
    }
}

extension String {
    func qrImage(using color: UIColor) -> CIImage? {
        return qrImage?.tinted(using: color)
    }

    var qrImage: CIImage? {
        
        let data = self.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let ciImage = filter?.outputImage
        let transform = CGAffineTransform(scaleX: 30, y: 30)
        let transformImage = ciImage?.transformed(by: transform)
        return transformImage
    }
}


extension CIImage {
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }

    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }

    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }

    func tinted(using color: UIColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage!
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

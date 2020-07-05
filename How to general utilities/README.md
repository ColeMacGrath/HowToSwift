# General Utilities

## Remove extra lines of UITableView

```swift
extension UITableView {
  func removeExtraLines() {
    self.tableFooterView = UIView()
  }
}
```

### Ussage

```swift
self.tableView.removeExtraLines()
```

## Convert string to date

```swift
extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    var extendedDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
}

```

### Ussage

```swift
let stringDate = "2020-12-12"
if let date = stringDate.toDate {
    print(date)
}

let extendedStringDate = "2020-12-12 10:23:34"
if let date = extendedStringDate.extendedDate {
    print(date)
}
```

## How check regex for mail in String

```swift
extension String {
    var isMail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
```

### Ussage

```swift
let mailString = "myMail@mail.com"
if mailString.isMail {
    print("\(mailString) is valid mail")
}
```

## Underline UITextField

```swift
enum LINE_POSITION {
    case top
    case bottom
}

extension UIView {
    func addLine(position: LINE_POSITION = .bottom, color: UIColor = UIColor.lightGray, width: Double = 1.0) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
```

### Ussage

```swift
textFiled.addLine()
```

## QR From String

```swift
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
```

### Ussage

```swift
let qrText = "My Custom Text"
if let ciImage = qrText.qrImage(using: .darkGray) {
  imageView.image = UIImage(ciImage: ciImage)
}
```

## Custom layout size for CollectionView

* Select Collection View Flow Layout and set Estimated Size to None in Interface Builder

```swift
//Add UICollectionViewDelegateFlowLayout to your class
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  let height = view.frame.size.height
  let width = view.safeAreaLayoutGuide.layoutFrame.size.width
  
  let device = UIDevice.current
  
  if device.userInterfaceIdiom == .phone { //If device is an iPhone
    if device.orientation.isLandscape { //If device is Landscaoe
      return CGSize(width: width * 0.45, height: height * 0.4)
    }
    return CGSize(width: width * 0.95, height: height * 0.3)
  }
  return CGSize(width: width * 0.48, height: height * 0.35) //If device is iPad
}
```

## Add support for IOS 12 in Xcode 11 projects

* Add @available sentence in SceneDelegate.swift

```swift
import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
}
```

* Add @available sentence in AppDelegate.swift

```swift
@available(iOS 13.0, *)
func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

@available(iOS 13.0, *)
func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
```

* Add window in AppDelegate.swift

```swift
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}
```


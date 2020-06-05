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

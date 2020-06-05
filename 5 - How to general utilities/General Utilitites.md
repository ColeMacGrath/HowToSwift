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

## Convert String to date


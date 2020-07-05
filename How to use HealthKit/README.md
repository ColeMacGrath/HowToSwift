# Get read basic data

## Add HealthKit capabilitie to your project

* Select your project (blue icon at top with your's project name)
* Select your target
* Select Signing & Capabilities
* Select + Capability
* Find and select HealthKit

## Request permissions in Info.plist

* Privacy - Health Share Usage Description

## Create a helper class

```swift
import HealthKit

enum HealthKitError: Error {
    case deviceNotCompatible(description: String?)
    case notAuthorized(description: String)
    case healthTypeNotAvailable
    case genericError
}

class HealthKitService {
    
    private static let _shared = HealthKitService()
    private let healthKitStore = HKHealthStore()
    
    static var shared: HealthKitService {
        return self._shared
    }
    
    private var isHealthKitAvailable: Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        return true
    }
    
    func requestDataTypes(handler: @escaping (_ data: HealthKitError?) -> Void) {
        if self.isHealthKitAvailable {
            guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                handler(HealthKitError.healthTypeNotAvailable)
                return
            }
            
            let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, bloodType, biologicalSex, bodyMassIndex, height, bodyMass, activeEnergyBurned, .workoutType()]
            
            HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
                if error != nil {
                    handler(HealthKitError.genericError)
                    return
                }
                handler(nil)
            }
        } else {
            handler(HealthKitError.deviceNotCompatible(description: "Device not compatible with HealthKit"))
            return
        }
    }
    
    func getBiologicalSex(handler: @escaping (_ biologicalSex: HKBiologicalSexObject?, _ error: Error?) -> Void) {
        do {
            let biologicalSex = try self.healthKitStore.biologicalSex()
            handler(biologicalSex, nil)
        } catch {
            handler(nil, error)
        }
    }
    
}
```

### Ussage

```swift
HealthKitService.shared.requestDataTypes { (error) in
            if let error = error {
                print(error)
                //Request to download
            } else {
                HealthKitService.shared.getBiologicalSex { (biologicalSex, _) in
                    guard let biologicalSex = biologicalSex else { return }
                    var sex = ""
                    switch biologicalSex.biologicalSex {
                    case .notSet:
                        sex = "NonSet"
                    case .female:
                        sex = "Female"
                    case .male:
                        sex = "Male"
                    case .other:
                        sex = "Other"
                    @unknown default:
                        sex = ""
                    }
                }
            }
        }
```

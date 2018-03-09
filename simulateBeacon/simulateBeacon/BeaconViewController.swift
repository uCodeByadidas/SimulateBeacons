import UIKit
import CoreBluetooth
import CoreLocation

class BeaconViewController: UIViewController {

    var peripheralManager: CBPeripheralManager!
    var region: CLBeaconRegion!
    var data: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBeacon()
    }
}

private extension BeaconViewController{
    
    func initBeacon() {
        if region != nil {
            stopSimulating()
        }
        
        let uuidString = "Enter here the UUID"
        let major: CLBeaconMajorValue = 123
        let minor: CLBeaconMinorValue = 456
        
        guard let uuid = UUID(uuidString: uuidString) else {
            return
        }
        
        region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: "My region ID")
        
        data = region.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopSimulating() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        data = nil
        region = nil
    }
}

extension BeaconViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
        case .poweredOn:
            peripheralManager.startAdvertising(data as? [String: Any])
            break;
            
        case .poweredOff:
            peripheralManager.stopAdvertising()
            break;
            
        case .unsupported:
            break;
            
        default:
            break;
        }
    }
}


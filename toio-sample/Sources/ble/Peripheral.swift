import CoreBluetooth

protocol PeripheralNotifyDelegate: class {
    func onReady()
    func notify(_ characteristic: CBCharacteristic, _ data: Data)
}

class Peripheral: NSObject, CBPeripheralDelegate {
    public var rawPeripheral: CBPeripheral!
    private var characteristics: [CBUUID:CBCharacteristic] = [:]

    public var delegate: PeripheralNotifyDelegate!

    init(_ rawPeripheral: CBPeripheral) {
        super.init()

        self.rawPeripheral = rawPeripheral
        self.rawPeripheral.delegate = self
        self.rawPeripheral.discoverServices(nil)
    }

    func peripheral(_ rawPeripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = rawPeripheral.services else {
            return
        }

        for service in services {
            rawPeripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ rawPeripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            self.characteristics[characteristic.uuid] = characteristic
        }

        guard delegate != nil else {
            return
        }

        delegate.onReady()
    }
    
    func write(characteristicUuid: CBUUID, data: Data, withoutResponse: Bool) {
        guard let characteristic = self.characteristics[characteristicUuid] else {
            return
        }

        self.rawPeripheral.writeValue(data,
                                      for: characteristic,
                                      type: withoutResponse ?
                                        CBCharacteristicWriteType.withoutResponse :
                                        CBCharacteristicWriteType.withResponse)
    }

    func startNotification(characteristicUuid: CBUUID) {
        guard let characteristic = self.characteristics[characteristicUuid] else {
            return
        }

        rawPeripheral.setNotifyValue(true, for: characteristic)
    }

    func peripheral(_ rawPeripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            return
        }

        guard let value = characteristic.value else {
            return
        }

        self.delegate?.notify(characteristic, value)
    }
}

import CoreBluetooth
import Combine

public class CoreCube: PeripheralNotifyDelegate, Identifiable, ObservableObject {
    public let serviceUuid = CBUUID(string: "10B20100-5B3B-4571-9508-CF3EFCD7BBAE")

    public let characteristicUuids = [
        "id": CBUUID(string: ToioId.characteristicUuid),
        "motor": CBUUID(string: "10B20102-5B3B-4571-9508-CF3EFCD7BBAE")
    ]

    private var peripheral: Peripheral!

    public var data: Data!

    private static var index = 0
    public var id: Int = 0

    @Published public var x: Int = 0
    @Published public var y: Int = 0
    @Published public var direction: Int = 0

    public init() {
        self.id = CoreCube.index
        CoreCube.index += 1
    }

    public func connect() {
        Ble.instance.discover(serviceUuid: self.serviceUuid, { peripheral in
            self.peripheral = peripheral
            self.peripheral.delegate = self
        })
    }
    
    public func disconnect() {
        guard self.peripheral != nil else {
            return
        }
        
        Ble.instance.disconnect(peripheral: self.peripheral)
        
        self.peripheral = nil
    }

    public func onReady() {
        guard let characteristicUuid = self.characteristicUuids["id"] else {
            return
        }

        self.peripheral.startNotification(characteristicUuid: characteristicUuid)
    }

    public func getId() -> String {
        return String(self.id)

        guard let peripheral = self.peripheral else {
            return ""
        }

        guard let rawPeripheral = peripheral.rawPeripheral else {
            return ""
        }

        return rawPeripheral.identifier.uuidString
    }

    func notify(_ characteristic: CBCharacteristic, _ data: Data) {
        let type = data[0]
        switch type {
        case ToioId.positionId:
            (self.x, self.y, self.direction) = ToioId.convertPositionId(data)

        default:
            break
        }
    }

    public func move(leftSpeed: Int, rightSpeed: Int, duration: Double) {
        guard peripheral != nil else {
            return
        }

        guard let characteristicUuid = characteristicUuids["motor"] else {
            return
        }

        let leftSign: UInt8 = leftSpeed >= 0 ? 1 : 2
        let rightSign: UInt8 = rightSpeed >= 0 ? 1 : 2

        let leftValue: UInt8 = UInt8(abs(leftSpeed))
        let rightValue: UInt8 = UInt8(abs(rightSpeed))

        let data = Data([2, 1, leftSign, leftValue, 2, rightSign, rightValue, UInt8(duration * 100)])

        peripheral.write(characteristicUuid: characteristicUuid, data: data, withoutResponse: true)
    }
}

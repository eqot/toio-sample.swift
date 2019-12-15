import Foundation
import CoreBluetooth

class Ble: Operation, CBCentralManagerDelegate {
    static let instance = Ble()

    private var central: CBCentralManager!

    public var queue: OperationQueue!

    public var _ready = false

    private override init() {
        super.init()

        self.central = CBCentralManager(delegate: self, queue: nil)

        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 1
        self.queue.qualityOfService = .userInitiated

        self.queue.addOperation(WaitForReadyOperation())
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            Ble.instance._ready = true
        }
    }

    func discover(serviceUuid: CBUUID, _ completion: @escaping (Peripheral) -> Void) {
        let operation = ConnectOperation(central: self.central, serviceUuid: serviceUuid, completion)
        self.queue.addOperation(operation)
    }
    
    func disconnect(peripheral: Peripheral) {
        self.central.cancelPeripheralConnection(peripheral.rawPeripheral)
    }

    class WaitForReadyOperation: Operation {
        override func main() {
            while (!Ble.instance._ready) {
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
    }

    class ConnectOperation: Operation, CBCentralManagerDelegate {
        private var central: CBCentralManager!
        private var serviceUuid: CBUUID!
        private var completion: ((Peripheral) -> Void)!

        private var peripheral: CBPeripheral! = nil
        private var rssi = NSNumber(-1000)

        private let endDate: Date = Date(timeIntervalSinceNow: 1)

        private var _executing: Bool = false
        override var isExecuting: Bool {
            get {
                return _executing
            }
            set {
                if _executing != newValue {
                    self.willChangeValue(for: \ConnectOperation.isExecuting)
                    _executing = newValue
                    self.didChangeValue(for: \ConnectOperation.isExecuting)
                }
            }
        }

        private var _finished: Bool = false
        override var isFinished: Bool {
            get {
                return _finished
            }
            set {
                if _finished != newValue {
                    self.willChangeValue(for: \ConnectOperation.isFinished)
                    _finished = newValue
                    self.didChangeValue(for: \ConnectOperation.isFinished)
                }
            }
        }

        init(central: CBCentralManager, serviceUuid: CBUUID, _ completion: @escaping (Peripheral) -> Void) {
            super.init()

            self.central = central
            self.serviceUuid = serviceUuid
            self.completion = completion
        }

        override func start() {
            self.isExecuting = true

            self.central.delegate = self
            self.central.scanForPeripherals(withServices: [self.serviceUuid],
                                            options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }

        func centralManagerDidUpdateState(_ central: CBCentralManager) {}

        func centralManager(_ central: CBCentralManager,
                            didDiscover peripheral: CBPeripheral,
                            advertisementData: [String : Any],
                            rssi RSSI: NSNumber) {
            if (self.rssi.compare(RSSI) == .orderedAscending) {
                self.peripheral = peripheral
                self.rssi = RSSI
            }

            if (self.endDate <= Date() && self.peripheral != nil) {
                central.stopScan()

                self.central.connect(self.peripheral, options: nil)
            }
        }

        func centralManager(_ central: CBCentralManager, didConnect rawPeripheral: CBPeripheral) {
            self.central.delegate = Ble.instance

            let peripheral = Peripheral(rawPeripheral)
            self.completion(peripheral)

            self.isExecuting = false
            self.isFinished = true
        }
    }
}

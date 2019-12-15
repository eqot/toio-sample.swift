import Foundation

public class Motor {
    
/*
    static func move(peripheral: Peripheral, leftSpeed: Int, rightSpeed: Int, duration: Double) {
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
 */
}

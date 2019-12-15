import Foundation

class ToioId {
    public static let characteristicUuid = "10B20101-5B3B-4571-9508-CF3EFCD7BBAE"

    public static let positionId = UInt8(1)

    public static func convertPositionId(_ data: Data) -> (Int, Int, Int) {
        let x = Int(data[1]) + (Int(data[2]) << 8)
        let y = Int(data[3]) + (Int(data[4]) << 8)
        let direction = Int(data[5]) + (Int(data[6]) << 8)

        return (x, y, direction)
    }
}
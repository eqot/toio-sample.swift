import SwiftUI

struct CoreCubeRow: View {
    @ObservedObject var cube: CoreCube

    @State var isConnecting = false
    
    var body: some View {
        HStack {
            if isConnecting {
                Text("(\(self.cube.x), \(self.cube.y)), \(self.cube.direction)")
            } else {
                Text("(0, 0, 0)")
            }

            Toggle(isOn: $isConnecting) { Spacer() }
                .onTapGesture {
                    if !self.isConnecting {
                        self.cube.connect()
                    } else {
                        self.cube.disconnect()
                    }
            }
        }
    }
}

struct CoreCubeRow_Previews: PreviewProvider {
    static var previews: some View {
        CoreCubeRow(cube: CoreCube())
    }
}

import SwiftUI

public struct CoreCubeList: View {
    @ObservedObject var cubes: CoreCubeGroup

    public init(cubes: CoreCubeGroup) {
        self.cubes = cubes
    }
    
    public var body: some View {
        List {
            ZStack {
                HStack(alignment: .center) {
                    Text("Cubes")
                        .font(.headline)
                }

                HStack() {
                    Spacer()

                    Button(action: {
                        self.cubes.add()
                    }) {
                        Text("Add")
                            .foregroundColor(Color.blue)
                    }
                }
            }
            
            ForEach(self.cubes.cubes) { cube in
                CoreCubeRow(cube: cube)
            }
        }
    }
}

struct CoreCubeList_Previews: PreviewProvider {
    static var previews: some View {
        CoreCubeList(cubes: CoreCubeGroup())
    }
}

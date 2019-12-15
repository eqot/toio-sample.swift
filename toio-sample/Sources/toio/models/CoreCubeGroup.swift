import Foundation

public class CoreCubeGroup: ObservableObject {
    @Published var cubes = [CoreCube]()
    
    func add() {
        cubes.append(CoreCube())
    }
    
    func runAll(_ task: (CoreCube) -> Void) {
        for cube in cubes {
            task(cube)
        }
    }
}

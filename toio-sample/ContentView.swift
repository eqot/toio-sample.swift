import SwiftUI

struct ToioButton: View {
    private let label: String
    private let action: () -> Void

    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(self.label)
                .frame(width: 120.0, height: 60.0)
                .padding(.all)
                .foregroundColor(Color.white)
        }
        .background(Color(red: 0, green: 0.682352941, blue: 0.792156863))
        .border(Color(red: 0, green: 0.580392157, blue: 0.670588235), width: 1)
    }
}

struct ContentView: View {
    private let cubes = CoreCubeGroup()

    var body: some View {
        VStack {
            CoreCubeList(cubes: cubes)

            VStack {
                ToioButton("Forward") {
                    self.cubes.runAll { cube in
                        cube.move(leftSpeed: 30, rightSpeed: 30, duration: 0.5)
                    }
                }

                HStack {
                    ToioButton("Left") {
                        self.cubes.runAll { cube in
                            cube.move(leftSpeed: -30, rightSpeed: 30, duration: 0.5)
                        }
                    }

                    ToioButton("Right") {
                        self.cubes.runAll { cube in
                            cube.move(leftSpeed: 30, rightSpeed: -30, duration: 0.5)
                        }
                    }
                }
                .padding(.all)

                ToioButton("Backward") {
                    self.cubes.runAll { cube in
                        cube.move(leftSpeed: -30, rightSpeed: -30, duration: 0.5)
                    }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

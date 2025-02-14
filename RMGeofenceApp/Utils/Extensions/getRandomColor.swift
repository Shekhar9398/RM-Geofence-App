import UIKit

extension UIColor {
    static func getRandomColor() -> UIColor {
        let colors: [UIColor] = [
            .blue, .green, .purple, .orange, .cyan, .magenta, .yellow, .red
        ]
        return colors.randomElement() ?? .blue  // Default to blue if something goes wrong
    }
}

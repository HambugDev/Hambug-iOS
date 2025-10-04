//
//  main.swift
//  Common
//
//  Created by 강동영 on 10/1/25.
//


import Foundation

guard CommandLine.arguments.count == 3 else {
    print("Usage: DesignSystemGeneratorTool <assets-path> <output-path>")
    exit(1)
}

let assetsPath = CommandLine.arguments[1]
let outputPath = CommandLine.arguments[2]

print("Processing assets at: \(assetsPath)")
print("Output will be written to: \(outputPath)")

var generateCode = """
import Foundation
import SwiftUI

public extension Color {
"""

let fileManager = FileManager.default

func findColorsets(in directory: String, colorNames: inout [String]) {
    guard let enumerator = fileManager.enumerator(atPath: directory) else { return }
    
    while let file = enumerator.nextObject() as? String {
        if file.hasSuffix(".colorset") {
            let colorName = String(file.dropLast(9)) // ".colorset" 제거
            let cleanName = URL(fileURLWithPath: colorName).lastPathComponent
            colorNames.append(cleanName)
        }
    }
}

var colorNames: [String] = []
findColorsets(in: assetsPath, colorNames: &colorNames)

colorNames.sort()

for colorName in colorNames {
    generateCode += "\n    static let \(colorName) = Color(\"\(colorName)\", bundle: .module)"
}

generateCode += "\n}\n"

do {
    try generateCode.write(toFile: outputPath, atomically: true, encoding: .utf8)
    print("Successfully generated DesignSystem+Color.swift with \(colorNames.count) colors")
} catch {
    print("Error writing file: \(error)")
    exit(1)
}

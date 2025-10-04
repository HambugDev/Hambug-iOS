//
//  ColorGenerator.swift
//  Common
//
//  Created by 강동영 on 10/1/25.
//

import PackagePlugin
import Foundation

@main
struct ColorGenerator: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let assetsPath = context.package.directory.appending("Sources/DesignSystem/Color.xcassets")
        let outputPath = context.package.directory.appending("Sources/DesignSystem/DesignSystem+Color.swift")
        
        print("Generating colors from: \(assetsPath)")
        print("Output to: \(outputPath)")
        
        var generateCode = """
        import Foundation
        import SwiftUI

        public extension Color {
        """
        
        let fileManager = FileManager.default
        var colorNames: [String] = []
        
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
        
        findColorsets(in: assetsPath.string, colorNames: &colorNames)
        colorNames.sort()
        
        for colorName in colorNames {
            generateCode += "\n    static let \(colorName) = Color(\"\(colorName)\", bundle: .module)"
        }
        
        generateCode += "\n}\n"
        
        do {
            try generateCode.write(toFile: outputPath.string, atomically: true, encoding: .utf8)
            print("✅ Successfully generated DesignSystem+Color.swift with \(colorNames.count) colors")
        } catch {
            print("❌ Error writing file: \(error)")
            throw error
        }
    }
}

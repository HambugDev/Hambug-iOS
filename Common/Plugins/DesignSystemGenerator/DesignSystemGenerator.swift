//
//  DesignSystemGenerator.swift
//  Common
//
//  Created by 강동영 on 10/1/25.
//

import PackagePlugin
import Foundation

@main
struct DesignSystemGenerator: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let assetsPath = context.package.directory.appending("Sources/DesignSystem/Color.xcassets")
        let outputPath = context.package.directory.appending("Sources/DesignSystem/DesignSystem+Color.swift")
        
        print("Generating colors from: \(assetsPath)")
        print("Output to: \(outputPath)")
        
        let process = Process()
        let path = try context.tool(named: "DesignSystemGeneratorTool").path
        process.executableURL = URL(fileURLWithPath: path.string)
        process.arguments = [assetsPath.string, outputPath.string]
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus == 0 {
            print("✅ Successfully generated DesignSystem+Color.swift")
        } else {
            print("❌ Failed to generate colors")
        }
    }
}

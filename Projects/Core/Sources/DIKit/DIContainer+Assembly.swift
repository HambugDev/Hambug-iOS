//
//  DIContainer+Assembly.swift
//  Hambug
//
//  Created by 강동영 on 12/17/25.
//

// MARK: - Scope
public enum Scope {
  case singleton  // 한 번 생성, 캐싱
  case transient  // 매번 새로 생성
}

// MARK: - Assembly Pattern
public protocol Assembly {
  func assemble(container: GenericDIContainer)
}

// MARK: - Generic DIContainer Protocol
public protocol DIContainer {
  func resolve<T>(_ type: T.Type) -> T
}

// MARK: - Generic DIContainer Implementation
public class GenericDIContainer: DIContainer {
  private struct FactoryEntry {
    let scope: Scope
    let factory: Any
  }

  private var factories: [String: FactoryEntry] = [:]
  private var singletons: [String: Any] = [:]
  private weak var parent: GenericDIContainer?

  public init(parent: GenericDIContainer? = nil) {
    self.parent = parent
  }

  public func register<T>(
    _ type: T.Type,
    scope: Scope = .transient,
    _ factory: @escaping (GenericDIContainer) -> T
  ) {
    let key = String(describing: type)
    factories[key] = FactoryEntry(scope: scope, factory: factory)
  }

  public func resolve<T>(_ type: T.Type) -> T {
    let key = String(describing: type)

    // Check for singleton cache
    if let singleton = singletons[key] as? T {
      return singleton
    }

    // Try local factory
    if let entry = factories[key],
       let factory = entry.factory as? (GenericDIContainer) -> T {
      let instance = factory(self)

      // Cache if singleton
      if entry.scope == .singleton {
        singletons[key] = instance
      }

      return instance
    }

    // Fallback to parent if available
    if let parent = parent {
      return parent.resolve(type)
    }

    fatalError("❌ \(key) is not registered")
  }
}

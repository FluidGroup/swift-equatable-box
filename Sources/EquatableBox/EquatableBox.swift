
public struct EquatableBox<T>: Equatable {
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.compare(rhs)
  }
  
  public let value: T
  
  private let compare: (Self) -> Bool
  
  public init<each V: Equatable>(_ values: repeat each V) where T == (repeat each V) {
    self.value = (repeat each values)
    self.compare = { other in
      areEqual((repeat each values), (repeat each other.value))
    }
  }
  
  public init<each V: Equatable>(_ tuple: (repeat each V)) where T == (repeat each V) {
    self.value = tuple
    self.compare = { other in
      areEqual((repeat each tuple), (repeat each other.value))
    }
  }
  
}

private func areEqual<each Element: Equatable>(_ lhs: (repeat each Element), _ rhs: (repeat each Element)) -> Bool {
  
  for (left, right) in repeat (each lhs, each rhs) {
    guard left == right else { return false }
  }
  return true
  
}

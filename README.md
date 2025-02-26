# EquatableBox

A Swift package that provides a convenient way to make tuples equatable in Swift 6 using parameter packs.

## Overview

`EquatableBox` is a generic wrapper that allows you to compare tuples of any size, as long as all elements in the tuple conform to `Equatable`. This is particularly useful when you need to compare complex data structures or use tuples as keys in collections.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/FluidGroup/EquatableBox.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
import EquatableBox

// Create EquatableBox instances with tuples
let box1 = EquatableBox(1, "hello")
let box2 = EquatableBox(1, "hello")
let box3 = EquatableBox(2, "hello")

// Compare them
box1 == box2 // true
box1 != box3 // true
```

### With Multiple Elements

```swift
let complexBox1 = EquatableBox(1, "test", true, 3.14)
let complexBox2 = EquatableBox(1, "test", true, 3.14)
let complexBox3 = EquatableBox(1, "test", false, 3.14)

complexBox1 == complexBox2 // true
complexBox1 != complexBox3 // true
```

### With Custom Types

```swift
struct Person: Equatable {
    let name: String
    let age: Int
}

let person1 = Person(name: "Tanaka", age: 30)
let person2 = Person(name: "Tanaka", age: 30)
let person3 = Person(name: "Sato", age: 25)

let box1 = EquatableBox(person1, 42)
let box2 = EquatableBox(person2, 42)
let box3 = EquatableBox(person3, 42)

box1 == box2 // true
box1 != box3 // true
```

### With Optional Values

```swift
let box1 = EquatableBox(1, "hello", nil as Int?)
let box2 = EquatableBox(1, "hello", nil as Int?)
let box3 = EquatableBox(1, "hello", 42 as Int?)

box1 == box2 // true
box1 != box3 // true
```

### Practical Use Cases

#### Using in Arrays

```swift
let boxes = [
    EquatableBox(1, "one"),
    EquatableBox(2, "two"),
    EquatableBox(3, "three"),
    EquatableBox(1, "one") // Duplicate value
]

// Using with contains method
boxes.contains(EquatableBox(2, "two")) // true
boxes.contains(EquatableBox(4, "four")) // false

// Using with filter method
let filtered = boxes.filter { $0 == EquatableBox(1, "one") }
filtered.count // 2
```

#### As Composite Keys

```swift
struct CompositeKey {
    let userId: String
    let itemId: Int
    
    // Using EquatableBox to determine equality
    func isEqual(to other: CompositeKey) -> Bool {
        let box1 = EquatableBox(userId, itemId)
        let box2 = EquatableBox(other.userId, other.itemId)
        return box1 == box2
    }
}

let key1 = CompositeKey(userId: "user1", itemId: 100)
let key2 = CompositeKey(userId: "user1", itemId: 100)
key1.isEqual(to: key2) // true
```

#### In Complex Data Structures

```swift
struct DataPoint {
    let timestamp: TimeInterval
    let values: EquatableBox<(Int, String, Bool)>
    
    init(timestamp: TimeInterval, value1: Int, value2: String, value3: Bool) {
        self.timestamp = timestamp
        self.values = EquatableBox(value1, value2, value3)
    }
    
    func hasSameValues(as other: DataPoint) -> Bool {
        return values == other.values
    }
}

let point1 = DataPoint(timestamp: 1000, value1: 42, value2: "data", value3: true)
let point2 = DataPoint(timestamp: 2000, value1: 42, value2: "data", value3: true)
point1.hasSameValues(as: point2) // true
```

## Limitations

- `EquatableBox` does not conform to `Hashable`, so it cannot be used as a key in dictionaries or sets directly.
- This package requires Swift 6's parameter pack feature.

## License

This package is available under the Apache License, Version 2.0. See the LICENSE file for more info. 
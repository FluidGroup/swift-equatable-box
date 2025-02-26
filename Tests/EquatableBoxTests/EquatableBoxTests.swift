import Testing
import Foundation
@testable import EquatableBox

@Test func example() async throws {
    // Basic tuple test
    let box1 = EquatableBox(1, "hello")
    let box2 = EquatableBox(1, "hello")
    let box3 = EquatableBox(2, "hello")
    let box4 = EquatableBox(1, "world")
    
    #expect(box1 == box2)
    #expect(box1 != box3)
    #expect(box1 != box4)
    
    // Test with multiple elements in tuple
    let complexBox1 = EquatableBox(1, "test", true, 3.14)
    let complexBox2 = EquatableBox(1, "test", true, 3.14)
    let complexBox3 = EquatableBox(1, "test", false, 3.14)
    
    #expect(complexBox1 == complexBox2)
    #expect(complexBox1 != complexBox3)
}

@Test func testWithCustomTypes() async throws {
    struct Person: Equatable {
        let name: String
        let age: Int
    }
    
    let person1 = Person(name: "田中", age: 30)
    let person2 = Person(name: "田中", age: 30)
    let person3 = Person(name: "佐藤", age: 25)
    
    let box1 = EquatableBox(person1, 42)
    let box2 = EquatableBox(person2, 42)
    let box3 = EquatableBox(person3, 42)
    
    #expect(box1 == box2)
    #expect(box1 != box3)
}

@Test func testWithComplexCustomTypes() async throws {
    // Define complex custom types
    struct Address: Equatable {
        let street: String
        let city: String
        let zipCode: String
    }
    
    struct User: Equatable {
        let id: String
        let name: String
        let address: Address
    }
    
    let address1 = Address(street: "桜通り", city: "東京", zipCode: "100-0001")
    let address2 = Address(street: "桜通り", city: "東京", zipCode: "100-0001")
    let address3 = Address(street: "梅通り", city: "大阪", zipCode: "530-0001")
    
    let id1 = "user-123"
    let id2 = "user-456"
    
    let user1 = User(id: id1, name: "山田", address: address1)
    let user2 = User(id: id1, name: "山田", address: address2)
    let user3 = User(id: id2, name: "山田", address: address1)
    let user4 = User(id: id1, name: "山田", address: address3)
    
    // Same ID and same address (different instances but equivalent)
    let box1 = EquatableBox(user1, 100, "テスト")
    let box2 = EquatableBox(user2, 100, "テスト")
    
    // Different ID
    let box3 = EquatableBox(user3, 100, "テスト")
    
    // Different address
    let box4 = EquatableBox(user4, 100, "テスト")
    
    // Different number
    let box5 = EquatableBox(user1, 200, "テスト")
    
    // Different string
    let box6 = EquatableBox(user1, 100, "別のテスト")
    
    #expect(box1 == box2)
    #expect(box1 != box3)
    #expect(box1 != box4)
    #expect(box1 != box5)
    #expect(box1 != box6)
}

@Test func testWithOptionalValues() async throws {
    // Test with optional values
    let box1 = EquatableBox(1, "hello", nil as Int?)
    let box2 = EquatableBox(1, "hello", nil as Int?)
    let box3 = EquatableBox(1, "hello", 42 as Int?)
    
    #expect(box1 == box2)
    #expect(box1 != box3)
}

@Test func testPracticalUseCases() async throws {
    // Using in arrays
    let boxes = [
        EquatableBox(1, "one"),
        EquatableBox(2, "two"),
        EquatableBox(3, "three"),
        EquatableBox(1, "one") // Duplicate value
    ]
    
    // Using with contains method
    #expect(boxes.contains(EquatableBox(2, "two")))
    #expect(!boxes.contains(EquatableBox(4, "four")))
    
    // Using with filter method
    let filtered = boxes.filter { $0 == EquatableBox(1, "one") }
    #expect(filtered.count == 2)
    
    // Example of manually removing duplicates
    var uniqueBoxes: [EquatableBox<(Int, String)>] = []
    for box in boxes {
        if !uniqueBoxes.contains(box) {
            uniqueBoxes.append(box)
        }
    }
    #expect(uniqueBoxes.count == 3)
    
    // Using as dictionary keys (commented out because EquatableBox doesn't conform to Hashable)
    // let dict = [EquatableBox(1, "one"): "Value 1", EquatableBox(2, "two"): "Value 2"]
    
    // Real use case: Using as composite key
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
    let key3 = CompositeKey(userId: "user2", itemId: 100)
    
    #expect(key1.isEqual(to: key2))
    #expect(!key1.isEqual(to: key3))
    
    // Using in complex data structures
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
    
    let point1 = DataPoint(timestamp: 1000, value1: 42, value2: "データ", value3: true)
    let point2 = DataPoint(timestamp: 2000, value1: 42, value2: "データ", value3: true)
    let point3 = DataPoint(timestamp: 3000, value1: 42, value2: "別のデータ", value3: true)
    
    #expect(point1.hasSameValues(as: point2))
    #expect(!point1.hasSameValues(as: point3))
}

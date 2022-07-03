public class VerySimpleBloomFilter<T> {
    private var storage: [Bool]
    private var hashFunctions: [(T) -> Int]

    public init(size: Int = 1024, hashFunctions: [(T) -> Int]) {
        self.storage = [Bool](repeating: false, count: size)
        self.hashFunctions = hashFunctions
    }

    // Возвращает false, если значение точно не находится в фильтре Блума и
    // true, если значение может там находиться - т.е. может и находится, но это не точно ))
    public func query(_ value: T) -> Bool {
        let hashValues = computeHashes(value)
        let results = hashValues.map { hashValue in storage[hashValue] }
        let exists = results.reduce(true, { $0 && $1 })
        return exists
    }
    
    public func insert(_ element: T) {
        for hashValue in computeHashes(element) {
            storage[hashValue] = true
        }
    }

    public func insert(_ values: [T]) {
        for value in values {
            insert(value)
        }
    }
    
    public func isEmpty() -> Bool {
        storage.reduce(true) { prev, next in prev && !next }
    }

    private func computeHashes(_ value: T) -> [Int] {
        hashFunctions.map { hashFunc in abs(hashFunc(value) % storage.count) }
    }
}

extension VerySimpleBloomFilter: CustomStringConvertible {
    public var description: String {
        String(describing: storage)
    }
}

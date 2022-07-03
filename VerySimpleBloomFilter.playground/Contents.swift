// NOTE: определим пару хэш-функций, для передачи в фильтр

func djb2(x: String) -> Int {
    var hash = 5381
    for char in x {
        hash = ((hash << 5) &+ hash) &+ char.hashValue
    }
    return Int(hash)
}

func sdbm(x: String) -> Int {
  var hash = 0
  for char in x {
      hash = char.hashValue &+ (hash << 6) &+ (hash << 16) &- hash
  }
  return Int(hash)
}

// NOTE: Простой тест, показывающий распределение результатов хэш-функций на "битовое" хранилище при вставке значений
// и пример коллизии и ложно-положительного срабатывания

let bloomFilter = VerySimpleBloomFilter<String>(size: 17, hashFunctions: [djb2, sdbm])

print("Хранилище фильтра после инициализации:")
print(bloomFilter, "\n") // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

bloomFilter.insert("Hello world!")
print("Хранилище фильтра после добавления значения:")
print(bloomFilter, "\n") // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -> 1, 0, -> 1, 0, 0, 0, 0]

bloomFilter.query("Hello world!") // true
bloomFilter.query("Hello WORLD") // false

print("Хранилище фильтра после добавления другого значения:")
bloomFilter.insert("Bloom Filterz")
print(bloomFilter, "\n") // [0, -> 0, 0, 0, 0, 0, 0, 0, 0, 0, -> 1, 0, -> 1, 0, 0, 0, 0]

bloomFilter.query("Bloom Filterz") // true
bloomFilter.query("Hello WORLD") // теперь true

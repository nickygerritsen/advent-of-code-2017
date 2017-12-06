let input = "4 10 4 1 8 4 9 14 5 1 14 15 0 15 3 5"
var currentBanks = input.split(separator: " ").map({ Int(String($0))! })

struct Bank {
    let values: [Int]
    let firstSeen: Int
}

extension Bank: Equatable {
    public static func ==(lhs: Bank, rhs: Bank) -> Bool {
        return lhs.values == rhs.values
    }
}

extension Bank: Hashable {
    var hashValue: Int {
        return self.values.reduce(5381) {
            ($0 << 5) &+ $0 &+ $1
        }
    }
}

var banks = Set<Bank>()

banks.insert(Bank(values: currentBanks, firstSeen: 0))
var idx = 1

while true {
    // Calculate the next bank values
    let max = currentBanks.max()!
    let maxIndex = currentBanks.index(of: max)!
    currentBanks[maxIndex] = 0
    var toAdd = max
    var curIndex = (maxIndex + 1) % currentBanks.count
    while toAdd > 0 {
        currentBanks[curIndex] += 1
        toAdd -= 1
        curIndex = (curIndex + 1) % currentBanks.count
    }
    
    let newBank = Bank(values: currentBanks, firstSeen: idx)
    if banks.contains(newBank) {
        let oldBank = banks[banks.index(of: newBank)!]
        print(banks.count, idx - oldBank.firstSeen)
        break
    }
    banks.insert(newBank)
    idx += 1
}

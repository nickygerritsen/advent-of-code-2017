import Foundation

// Part 1
let input = "14,58,0,116,179,16,1,104,2,254,167,86,255,55,122,244"
let circleLength = 256
let lengths = input.split(separator: ",").map { Int(String($0))! }
var skipSize = 0
var currentPosition = 0

var list = Array(0..<circleLength)

func knotHashStep(lengths: [Int], list: inout [Int], skipSize: inout Int, currentPosition: inout Int) {
    for length in lengths {
        let toReverse: [Int]
        if currentPosition + length < list.count {
            toReverse = Array(list[currentPosition..<currentPosition+length])
        } else {
            toReverse = Array(list[currentPosition..<list.count]) + Array(list[0..<length - list.count + currentPosition])
        }
        let reversed = ArraySlice(toReverse.reversed())
        if currentPosition + length < list.count {
            list[currentPosition..<currentPosition+length] = reversed
        } else {
            list[currentPosition..<list.count] = reversed[0..<list.count - currentPosition]
            list[0..<length - list.count + currentPosition] = reversed[list.count - currentPosition..<reversed.count]
        }
        
        currentPosition = (currentPosition + length + skipSize) % list.count
        skipSize += 1
    }
}

knotHashStep(lengths: lengths, list: &list, skipSize: &skipSize, currentPosition: &currentPosition)

print(list[0] * list[1])

// Part 2
extension String {
    var asciiArray: [Int] {
        return unicodeScalars.filter{$0.isASCII}.map{Int($0.value)}
    }
}
extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

func knotHash(input: String) -> String {
    let lengths = input.asciiArray + [17, 31, 73, 47, 23]
    var skipSize = 0
    var currentPosition = 0
    var list = Array(0..<256)
    for _ in 1...64 {
        knotHashStep(lengths: lengths, list: &list, skipSize: &skipSize, currentPosition: &currentPosition)
    }
    
    let chunks = list.chunks(16)
    let xored = chunks.map({ (chunk: [Int]) -> Int in
        return chunk.reduce(0, { $0 ^ $1 })
    })
    let hex = xored.map { String(format: "%02X", $0) }.joined().lowercased()
    return hex
}

print(knotHash(input: input))

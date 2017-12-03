let input = """
104    240    147    246    123    175    372    71    116    230    260    118    202    270    277    292
740    755    135    205    429    822    844    90    828    115    440    805    526    91    519    373
1630    991    1471    1294    52    1566    50    1508    1367    1489    55    547    342    512    323    51
1356    178    1705    119    1609    1409    245    292    1434    694    405    1692    247    193    1482    1407
2235    3321    3647    212    1402    3711    3641    1287    2725    692    1235    3100    123    144    104    101
1306    1224    1238    186    751    734    1204    1275    366    149    1114    166    1118    239    153    943
132    1547    1564    512    2643    2376    2324    2159    1658    107    1604    145    2407    131    2073    1878
1845    91    1662    108    92    1706    1815    1797    1728    1150    1576    83    97    547    1267    261
78    558    419    435    565    107    638    173    93    580    338    52    633    256    377    73
1143    3516    4205    3523    148    401    3996    3588    300    1117    2915    1649    135    134    182    267
156    2760    1816    2442    2985    990    2598    1273    167    821    138    141    2761    2399    1330    1276
3746    3979    2989    161    4554    156    3359    173    3319    192    3707    264    762    2672    4423    2924
3098    4309    4971    5439    131    171    5544    595    154    571    4399    4294    160    6201    4329    5244
728    249    1728    305    2407    239    691    2241    2545    1543    55    2303    1020    753    193    1638
260    352    190    877    118    77    1065    1105    1085    1032    71    87    851    56    1161    667
1763    464    182    1932    1209    640    545    931    1979    197    1774    174    2074    1800    939    161
"""

let lines = input.split(separator: "\n")

// Part 1
var sum = 0
for line in lines {
    var minNum = Int.max
    var maxNum = 0
    let numbers = line.split(separator: " ")
    for numberChar in numbers {
        let number = Int(String(numberChar))!
        minNum = min(minNum, number)
        maxNum = max(maxNum, number)
    }
    sum += (maxNum - minNum)
}
print(sum)

// Part 2
sum = 0
for line in lines {
    let numbers = line.split(separator: " ").map({ Int(String($0))! } ).sorted(by: { $0 >= $1 })
    for i in numbers.indices {
        for j in (i+1)..<numbers.indices.endIndex {
            let n1 = numbers[i]
            let n2 = numbers[j]
            if n1 % n2 == 0 {
                sum += n1 / n2
            }
        }
    }
}
print(sum)

// Or functional
print(
    input
        .split(separator: "\n")
        .map( { $0.split(separator: " ")} )
        .map( { $0.map( { Int(String($0))! } ) } )
        .map( { (elems: [Int]) -> (Int, Int) in
            return elems.reduce((Int.max, 0), { (min($0.0, $1), max($0.1, $1)) })
        } )
        .reduce(0, { (cur: Int, next: (Int, Int)) -> Int in
            return cur + (next.1 - next.0)
        })
)

print(
    input
        .split(separator: "\n")
        .map( { $0.split(separator: " ")} )
        .map( { $0.map( { Int(String($0))! } ) } )
        .map( { $0.sorted(by: { (n1: Int, n2: Int) -> Bool in n1 >= n2 }) } )
        .map( { (elems: [Int]) -> [(Int, Int?)] in
            // Not really too functional but I don't know a better way...
            var result = [(Int, Int?)]()
            for idx in elems.indices {
                var divisbleBy: Int?
                let toCheck = elems.dropFirst(idx + 1)
                let divisors = toCheck.filter( { elems[idx] % $0 == 0 } )
                if divisors.count == 1 {
                    divisbleBy = divisors[0]
                }
                
                result.append((elems[idx], divisbleBy))
            }
            
            return result
        })
        .map({ (elems: [(Int, Int?)]) -> (Int, Int) in
            let filtered = elems.filter( { $0.1 != nil })[0]
            return (filtered.0, filtered.1!)
        })
        .reduce(0, { (cur: Int, next: (Int, Int)) -> Int in
            return cur + (next.0 / next.1)
        })
)

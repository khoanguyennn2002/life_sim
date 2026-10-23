import 'dart:math';

import '../models/character.dart';
import '../models/family.dart';

/// Kết quả tổng hợp của một lần khởi tạo cuộc đời.
class GeneratedLife {
  final int seed;
  final Character character;
  final Family family;

  const GeneratedLife({
    required this.seed,
    required this.character,
    required this.family,
  });

  /// Chuỗi để kiểm tra dữ liệu ẩn qua console. KHÔNG dùng trong UI.
  String toDebugString() {
    return '=== GeneratedLife (seed: $seed) ===\n'
        '$character\n'
        '$family';
  }
}

class CharacterGenerator {
  CharacterGenerator._();

  // Trọng số xuất hiện (tổng = 100), đúng thứ tự FamilyType.values:
  // stable, wealthy, lowIncome, conflicted, singleParent
  static const List<int> _typeWeights = [
    35, // stable
    7, // wealthy
    28, // lowIncome
    12, // conflicted
    18, // singleParent
  ];

  // Khoảng [min, max] cho 5 chỉ số gia đình, theo thứ tự:
  // careQuality, familyBond, familyStress, educationSupport, financialSupport
  // Các khoảng cố tình chồng lấn nhau để loại gia đình không quyết định tất cả.
  static const Map<FamilyType, List<List<int>>> _statRanges = {
    FamilyType.stable: [
      [60, 90],
      [60, 90],
      [10, 45],
      [45, 85],
      [45, 80],
    ],
    FamilyType.wealthy: [
      [45, 95],
      [40, 90],
      [15, 65],
      [65, 98],
      [75, 98],
    ],
    FamilyType.lowIncome: [
      [40, 90],
      [40, 95],
      [25, 80],
      [20, 75],
      [5, 40],
    ],
    FamilyType.conflicted: [
      [25, 80],
      [10, 50],
      [55, 95],
      [25, 75],
      [20, 80],
    ],
    FamilyType.singleParent: [
      [40, 90],
      [40, 95],
      [25, 75],
      [25, 80],
      [15, 70],
    ],
  };
  // Kinh tế (triệu đồng): [thu nhập min, thu nhập max/năm,
  //                        tài sản min, tài sản max, % khả năng có nợ]
  static const Map<FamilyType, List<int>> _economyRanges = {
    FamilyType.stable: [120, 360, 100, 1200, 30],
    FamilyType.wealthy: [500, 2000, 2000, 20000, 25],
    FamilyType.lowIncome: [36, 144, 0, 200, 45],
    FamilyType.conflicted: [60, 500, 20, 1200, 40],
    FamilyType.singleParent: [48, 300, 10, 700, 40],
  };

  /// Tạo một cuộc đời mới. Cùng (seed, name, birthYear) => cùng kết quả.
  static GeneratedLife generate({
    required int seed,
    required String name,
    required int birthYear,
  }) {
    final rng = Random(seed);

    // ---------- 1. Chọn loại gia đình theo trọng số ----------
    const types = FamilyType.values;
    final roll = rng.nextInt(100);
    var familyType = types.last;
    var acc = 0;
    for (var i = 0; i < types.length; i++) {
      acc += _typeWeights[i];
      if (roll < acc) {
        familyType = types[i];
        break;
      }
    }

    // ---------- 2. Chỉ số hoàn cảnh gia đình ----------
    // stats[0]=care, [1]=bond, [2]=stress, [3]=educationSupport, [4]=financialSupport
    final ranges = _statRanges[familyType]!;
    final stats = <int>[];
    for (var i = 0; i < ranges.length; i++) {
      var v = ranges[i][0] + rng.nextInt(ranges[i][1] - ranges[i][0] + 1);
      // 20% cơ hội "biến cố": lệch thêm -15..+15 so với khoảng của loại gia đình
      if (rng.nextInt(100) < 20) {
        v += rng.nextInt(31) - 15;
      }
      stats.add(v.clamp(0, 100).toInt());
    }

    // ---------- 3. Kinh tế gia đình ----------
    final eco = _economyRanges[familyType]!;
    final income = eco[0] + rng.nextInt(eco[1] - eco[0] + 1);
    final wealth = eco[2] + rng.nextInt(eco[3] - eco[2] + 1);

    // Chi phí = 55%–110% thu nhập (căng thẳng cao thì +5%), tối thiểu 24 triệu/năm
    var ratio = 55 + rng.nextInt(56);
    if (stats[2] > 70) {
      ratio += 5;
    }
    var expenses = income * ratio ~/ 100;
    if (expenses < 24) {
      expenses = 24;
    }

    // Nợ: có thể bằng 0; nếu có thì tối đa 1.5 lần thu nhập năm.
    // Chi nhiều hơn thu (ratio > 100) thì dễ có nợ hơn.
    var debtChance = eco[4];
    if (ratio > 100) {
      debtChance += 20;
    }
    var debt = 0;
    if (rng.nextInt(100) < debtChance) {
      debt = rng.nextInt(income * 3 ~/ 2 + 1);
    }

    // Hỗ trợ tài chính phản ánh thực tế kinh tế (nhưng vẫn do ngẫu nhiên là chính)
    var financialSupport = stats[4];
    if (debt > income) {
      financialSupport -= 10;
    }
    if (wealth > income * 10) {
      financialSupport += 5;
    }

    final family = Family(
      familyType: familyType,
      careQuality: stats[0],
      familyBond: stats[1],
      familyStress: stats[2],
      educationSupport: stats[3],
      financialSupport: financialSupport,
      familyWealth: wealth,
      familyIncome: income,
      familyExpenses: expenses,
      familyDebt: debt,
    );

    // ---------- 4. Tiềm năng ẩn (trung bình 2 lần tung => tập trung quanh 50) ----------
    final intelligencePotential = (rng.nextInt(101) + rng.nextInt(101)) ~/ 2;
    final physicalPotential = (rng.nextInt(101) + rng.nextInt(101)) ~/ 2;
    final socialPotential = (rng.nextInt(101) + rng.nextInt(101)) ~/ 2;
    final practicalPotential = (rng.nextInt(101) + rng.nextInt(101)) ~/ 2;

    // ---------- 5. Thuộc tính chính lúc mới sinh ----------
    // Chăm sóc/tiềm năng chỉ tác động nhẹ; giá trị thật sẽ lớn lên theo thời gian.
    final health =
        55 +
        rng.nextInt(31) +
        (family.careQuality - 50) ~/ 5 +
        (physicalPotential - 50) ~/ 10;
    final happiness =
        50 + rng.nextInt(26) + (family.familyBond - family.familyStress) ~/ 5;
    final intelligence = 15 + rng.nextInt(21) + intelligencePotential ~/ 10;
    final ability = 10 + rng.nextInt(21) + practicalPotential ~/ 10;

    final character = Character(
      id: 'life_$seed',
      name: name,
      birthYear: birthYear,
      age: 0,
      health: health,
      happiness: happiness,
      intelligence: intelligence,
      ability: ability,
      intelligencePotential: intelligencePotential,
      physicalPotential: physicalPotential,
      socialPotential: socialPotential,
      practicalPotential: practicalPotential,
    );

    return GeneratedLife(seed: seed, character: character, family: family);
  }
}

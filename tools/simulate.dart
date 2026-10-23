// Chạy: dart run tool/simulate.dart
// Sinh N nhân vật rồi thống kê tỉ lệ loại gia đình và kinh tế trung bình.
import '../lib/generators/character_generator.dart';
import '../lib/models/family.dart';

void main() {
  const n = 1000;

  final count = <FamilyType, int>{};
  final sumIncome = <FamilyType, int>{};
  final sumExpenses = <FamilyType, int>{};
  final sumWealth = <FamilyType, int>{};
  final sumDebt = <FamilyType, int>{};
  final hasDebt = <FamilyType, int>{};
  final overspend = <FamilyType, int>{};
  final debtOverIncome = <FamilyType, int>{};

  for (final t in FamilyType.values) {
    count[t] = 0;
    sumIncome[t] = 0;
    sumExpenses[t] = 0;
    sumWealth[t] = 0;
    sumDebt[t] = 0;
    hasDebt[t] = 0;
    overspend[t] = 0;
    debtOverIncome[t] = 0;
  }

  for (var seed = 1; seed <= n; seed++) {
    final f = CharacterGenerator.generate(
      seed: seed,
      name: 'Test',
      birthYear: 2026,
    ).family;
    final t = f.familyType;
    count[t] = count[t]! + 1;
    sumIncome[t] = sumIncome[t]! + f.familyIncome;
    sumExpenses[t] = sumExpenses[t]! + f.familyExpenses;
    sumWealth[t] = sumWealth[t]! + f.familyWealth;
    sumDebt[t] = sumDebt[t]! + f.familyDebt;
    if (f.familyDebt > 0) hasDebt[t] = hasDebt[t]! + 1;
    if (f.familyExpenses > f.familyIncome) overspend[t] = overspend[t]! + 1;
    if (f.familyDebt > f.familyIncome) {
      debtOverIncome[t] = debtOverIncome[t]! + 1;
    }
  }

  print('N = $n (đơn vị: triệu đồng)');
  for (final t in FamilyType.values) {
    final c = count[t]!;
    if (c == 0) continue;
    print('${t.code.padRight(14)} '
        '${(c * 100 / n).toStringAsFixed(1).padLeft(5)}%  '
        'thu nhập TB ${(sumIncome[t]! / c).round()}  '
        'chi phí TB ${(sumExpenses[t]! / c).round()}  '
        'tài sản TB ${(sumWealth[t]! / c).round()}  '
        'nợ TB ${(sumDebt[t]! / c).round()}  '
        'có nợ ${(hasDebt[t]! * 100 / c).round()}%  '
        'chi>thu ${(overspend[t]! * 100 / c).round()}%  '
        'nợ>thu nhập ${(debtOverIncome[t]! * 100 / c).round()}%');
  }
}
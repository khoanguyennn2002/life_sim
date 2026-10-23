/// Loại gia đình. `code` là tên dạng snake_case để lưu/đọc dữ liệu sau này.
enum FamilyType {
  stable('stable', 'Gia đình ổn định'),
  wealthy('wealthy', 'Gia đình khá giả'),
  lowIncome('low_income', 'Gia đình có thu nhập thấp'),
  conflicted('conflicted', 'Gia đình thường xuyên bất hòa'),
  singleParent('single_parent', 'Gia đình có một phụ huynh');

  const FamilyType(this.code, this.label);

  final String code;
  final String label;
}

/// Một class duy nhất cho cả hoàn cảnh gia đình và kinh tế gia đình.
/// TOÀN BỘ dữ liệu này là dữ liệu ẩn, không hiển thị ở màn hình khởi tạo.
class Family {
  // --- Hoàn cảnh gia đình ---
  final FamilyType familyType;
  final int careQuality; // 0–100
  final int familyBond; // 0–100
  final int familyStress; // 0–100
  final int educationSupport; // 0–100
  final int financialSupport; // 0–100

  // --- Kinh tế gia đình (đơn vị: triệu đồng) ---
  final int familyWealth; // tổng tài sản
  final int familyIncome; // thu nhập mỗi năm
  final int familyExpenses; // chi phí mỗi năm
  final int familyDebt; // tổng nợ

  Family({
    required this.familyType,
    required int careQuality,
    required int familyBond,
    required int familyStress,
    required int educationSupport,
    required int financialSupport,
    required int familyWealth,
    required int familyIncome,
    required int familyExpenses,
    required int familyDebt,
  })  : careQuality = careQuality.clamp(0, 100).toInt(),
        familyBond = familyBond.clamp(0, 100).toInt(),
        familyStress = familyStress.clamp(0, 100).toInt(),
        educationSupport = educationSupport.clamp(0, 100).toInt(),
        financialSupport = financialSupport.clamp(0, 100).toInt(),
        familyWealth = familyWealth < 0 ? 0 : familyWealth,
        familyIncome = familyIncome < 0 ? 0 : familyIncome,
        familyExpenses = familyExpenses < 0 ? 0 : familyExpenses,
        familyDebt = familyDebt < 0 ? 0 : familyDebt;

  @override
  String toString() {
    return 'Family(type: ${familyType.code}, careQuality: $careQuality, '
        'familyBond: $familyBond, familyStress: $familyStress, '
        'educationSupport: $educationSupport, '
        'financialSupport: $financialSupport, '
        'wealth: $familyWealth, income: $familyIncome, '
        'expenses: $familyExpenses, debt: $familyDebt)';
  }
}
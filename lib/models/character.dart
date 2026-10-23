/// Nhân vật: thông tin cơ bản + 4 thuộc tính chính + 4 tiềm năng ẩn.
/// Bất biến (immutable): mọi trường đều `final`. Mọi giá trị 0–100 được
/// tự động giới hạn (clamp) ngay trong constructor.
class Character {
  // --- Thông tin cơ bản (được phép hiển thị) ---
  final String id;
  final String name;
  final int birthYear;
  final int age;

  // --- 4 thuộc tính chính 0–100 (được phép hiển thị) ---
  final int health;
  final int happiness;
  final int intelligence;
  final int ability;

  // --- 4 tiềm năng 0–100 (DỮ LIỆU ẨN, không hiển thị trên UI) ---
  final int intelligencePotential;
  final int physicalPotential;
  final int socialPotential;
  final int practicalPotential;

  Character({
    required this.id,
    required this.name,
    required this.birthYear,
    required int age,
    required int health,
    required int happiness,
    required int intelligence,
    required int ability,
    required int intelligencePotential,
    required int physicalPotential,
    required int socialPotential,
    required int practicalPotential,
  })  : age = age < 0 ? 0 : age,
        health = health.clamp(0, 100).toInt(),
        happiness = happiness.clamp(0, 100).toInt(),
        intelligence = intelligence.clamp(0, 100).toInt(),
        ability = ability.clamp(0, 100).toInt(),
        intelligencePotential = intelligencePotential.clamp(0, 100).toInt(),
        physicalPotential = physicalPotential.clamp(0, 100).toInt(),
        socialPotential = socialPotential.clamp(0, 100).toInt(),
        practicalPotential = practicalPotential.clamp(0, 100).toInt();

  /// Dùng để in ra console khi kiểm thử (KHÔNG dùng trong UI).
  @override
  String toString() {
    return 'Character(id: $id, name: $name, birthYear: $birthYear, age: $age, '
        'health: $health, happiness: $happiness, '
        'intelligence: $intelligence, ability: $ability, '
        'intelligencePotential: $intelligencePotential, '
        'physicalPotential: $physicalPotential, '
        'socialPotential: $socialPotential, '
        'practicalPotential: $practicalPotential)';
  }
}
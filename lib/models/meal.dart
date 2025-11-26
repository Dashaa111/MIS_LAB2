class Meal {
  final String id;
  final String name;
  final String thumbnail;

  Meal({required this.id, required this.name, required this.thumbnail});

  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    id: j['idMeal'] as String,
    name: j['strMeal'] as String,
    thumbnail: j['strMealThumb'] as String,
  );
}

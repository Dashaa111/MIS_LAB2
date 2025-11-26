import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_base/categories.php');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed categories');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['categories'] as List<dynamic>)
        .map((e) => Category.fromJson(e))
        .toList();
    return list;
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$_base/filter.php?c=$category');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed meals');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List<dynamic>)
        .map((e) => Meal.fromJson(e))
        .toList();
    return list;
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final url = Uri.parse('$_base/lookup.php?i=$id');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed detail');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final first = (data['meals'] as List<dynamic>).first;
    return MealDetail.fromJson(first);
  }

  Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$_base/random.php');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed random');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final first = (data['meals'] as List<dynamic>).first;
    return MealDetail.fromJson(first);
  }
}

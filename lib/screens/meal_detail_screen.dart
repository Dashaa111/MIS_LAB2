import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? preloaded;
  const MealDetailScreen({super.key, required this.mealId, this.preloaded});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _api = ApiService();
  MealDetail? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloaded != null) {
      _detail = widget.preloaded;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await _api.fetchMealDetail(widget.mealId);
      setState(() {
        _detail = d;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _detail;

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        188,
        210,
        192,
      ), // Светло сина позадина
      appBar: AppBar(
        title: Text(d?.name ?? 'Рецепт'),
        backgroundColor: const Color.fromARGB(255, 118, 151, 126),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null)
          ? Center(child: Text('Грешка: $_error'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: d!.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    d.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${d.category} • ${d.area}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Состојки',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...d.ingredients.entries.map(
                    (e) => Text('• ${e.key} — ${e.value}'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Инструкции',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(d.instructions),
                  if (d.youtube != null && d.youtube!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'YouTube: ${d.youtube!}',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

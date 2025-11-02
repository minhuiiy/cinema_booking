import 'package:flutter/foundation.dart';

String trGenres(String name) {
  // Simple mapping for common genres shown on Home
  const map = {
    'Anime': 'Anime',
    'Action': 'Hành động',
    'Dramatic': 'Kịch tính',
    'Survival': 'Sinh tồn',
    'Explore': 'Khám phá',
    'Science': 'Khoa học',
  };

  // Try exact match first
  if (map.containsKey(name)) return map[name]!;

  // Fallback: capitalize or return original
  try {
    return name;
  } catch (_) {
    return name;
  }
}
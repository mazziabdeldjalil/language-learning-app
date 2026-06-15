import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../data/learn_content.dart';

class LibraryService {
  static SupabaseClient get _client => SupabaseConfig.client;

  // ── FETCH ALL BY CATEGORY ─────────────────────────────────────────────────

  static Future<List<PassageItem>> fetchPassages() async {
    try {
      final response = await _client
          .from('library_content')
          .select()
          .eq('category', 'reading_passage')
          .eq('is_active', true)
          .order('sort_order');
      return response.map<PassageItem>((row) {
        final c = row['content'] as Map<String, dynamic>;
        return PassageItem(
          id: row['id'],
          title: row['title'] ?? '',
          topic: c['topic'] ?? '',
          difficulty: _parseDifficulty(row['difficulty']),
          body: c['body'] ?? '',
        );
      }).toList();
    } catch (e) {
      debugPrint('fetchPassages error: $e');
      return [];
    }
  }

  static Future<List<StoryItem>> fetchStories() async {
    try {
      final response = await _client
          .from('library_content')
          .select()
          .eq('category', 'short_story')
          .eq('is_active', true)
          .order('sort_order');
      return response.map<StoryItem>((row) {
        final c = row['content'] as Map<String, dynamic>;
        return StoryItem(
          id: row['id'],
          title: row['title'] ?? '',
          origin: c['origin'] ?? '',
          difficulty: _parseDifficulty(row['difficulty']),
          body: c['body'] ?? '',
          questions: _parseQuestions(c['questions']),
        );
      }).toList();
    } catch (e) {
      debugPrint('fetchStories error: $e');
      return [];
    }
  }

  static Future<List<ChildrenStory>> fetchChildrenStories() async {
    try {
      final response = await _client
          .from('library_content')
          .select()
          .eq('category', 'children_story')
          .eq('is_active', true)
          .order('sort_order');
      return response.map<ChildrenStory>((row) {
        final c = row['content'] as Map<String, dynamic>;
        return ChildrenStory(
          id: row['id'],
          title: row['title'] ?? '',
          origin: c['origin'] ?? '',
          body: c['body'] ?? '',
          moral: c['moral'] ?? '',
          difficulty: _parseDifficulty(row['difficulty']),
          questions: _parseQuestions(c['questions']),
        );
      }).toList();
    } catch (e) {
      debugPrint('fetchChildrenStories error: $e');
      return [];
    }
  }

  static Future<List<IdiomItem>> fetchIdioms() async {
    try {
      final response = await _client
          .from('library_content')
          .select()
          .eq('category', 'idiom')
          .eq('is_active', true)
          .order('sort_order');
      return response.map<IdiomItem>((row) {
        final c = row['content'] as Map<String, dynamic>;
        return IdiomItem(
          id: row['id'],
          idiom: row['title'] ?? '',
          meaning: c['meaning'] ?? '',
          example: c['example'] ?? '',
          origin: c['origin'],
          category: c['category'] ?? 'General',
        );
      }).toList();
    } catch (e) {
      debugPrint('fetchIdioms error: $e');
      return [];
    }
  }

  static Future<List<GrammarGuide>> fetchGrammarGuides() async {
    try {
      final response = await _client
          .from('library_content')
          .select()
          .eq('category', 'grammar_guide')
          .eq('is_active', true)
          .order('sort_order');
      return response.map<GrammarGuide>((row) {
        final c = row['content'] as Map<String, dynamic>;
        return GrammarGuide(
          id: row['id'],
          title: row['title'] ?? '',
          explanation: c['explanation'] ?? '',
          examples: List<String>.from(c['examples'] ?? []),
          commonMistake: c['commonMistake'] ?? '',
        );
      }).toList();
    } catch (e) {
      debugPrint('fetchGrammarGuides error: $e');
      return [];
    }
  }

  // ── ADMIN CRUD ─────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchAllContent(
      String category) async {
    try {
      final response = await _client
          .from('library_content')
          .select()
          .eq('category', category)
          .order('sort_order');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('fetchAllContent error: $e');
      return [];
    }
  }

  static Future<bool> createContent({
    required String id,
    required String category,
    required String title,
    required String difficulty,
    required int sortOrder,
    required Map<String, dynamic> content,
  }) async {
    try {
      await _client.from('library_content').insert({
        'id': id,
        'category': category,
        'title': title,
        'difficulty': difficulty,
        'sort_order': sortOrder,
        'is_active': true,
        'content': content,
      });
      return true;
    } catch (e) {
      debugPrint('createContent error: $e');
      return false;
    }
  }

  static Future<bool> updateContent({
    required String id,
    required String title,
    required String difficulty,
    required Map<String, dynamic> content,
  }) async {
    try {
      await _client.from('library_content').update({
        'title': title,
        'difficulty': difficulty,
        'content': content,
      }).eq('id', id);
      return true;
    } catch (e) {
      debugPrint('updateContent error: $e');
      return false;
    }
  }

  static Future<bool> toggleActive(String id, bool isActive) async {
    try {
      await _client
          .from('library_content')
          .update({'is_active': isActive}).eq('id', id);
      return true;
    } catch (e) {
      debugPrint('toggleActive error: $e');
      return false;
    }
  }

  static Future<bool> deleteContent(String id) async {
    try {
      await _client.from('library_content').delete().eq('id', id);
      return true;
    } catch (e) {
      debugPrint('deleteContent error: $e');
      return false;
    }
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  static Difficulty _parseDifficulty(String? value) {
    switch (value) {
      case 'intermediate': return Difficulty.intermediate;
      case 'advanced': return Difficulty.advanced;
      default: return Difficulty.beginner;
    }
  }

  static List<QuizQuestion> _parseQuestions(dynamic raw) {
    if (raw == null) return [];
    try {
      return (raw as List).map((q) => QuizQuestion(
        question: q['question'] ?? '',
        options: List<String>.from(q['options'] ?? []),
        correctIndex: q['correctIndex'] ?? 0,
        explanation: q['explanation'] ?? '',
      )).toList();
    } catch (e) {
      return [];
    }
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';
import 'supabase_config.dart';
import 'package:language_learning_app/services/gcp_tts_service.dart';

// -------------------- Models --------------------

class Message {
  final String role;
  final String content;
  final String? speechEmotion;
  final String? speechPace;

  Message({
    required this.role,
    required this.content,
    this.speechEmotion,
    this.speechPace,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      if (speechEmotion != null) 'speech_emotion': speechEmotion,
      if (speechPace != null) 'speech_pace': speechPace,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      speechEmotion: json['speech_emotion'],
      speechPace: json['speech_pace'],
    );
  }
}

// Tracks a specific word the user consistently gets wrong
class WordMistake {
  final String wrong;
  final String correct;
  final String context;
  final int count; // how many times this has appeared

  WordMistake({
    required this.wrong,
    required this.correct,
    required this.context,
    this.count = 1,
  });

  factory WordMistake.fromJson(Map<String, dynamic> json) {
    return WordMistake(
      wrong: json['wrong'] ?? '',
      correct: json['correct'] ?? '',
      context: json['context'] ?? '',
      count: json['count'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wrong': wrong,
      'correct': correct,
      'context': context,
      'count': count,
    };
  }

  WordMistake copyWithCount(int newCount) {
    return WordMistake(
      wrong: wrong,
      correct: correct,
      context: context,
      count: newCount,
    );
  }
}

class UserProfile {
  final String userId;
  final int? grammarScore;
  final int? vocabularyScore;
  final int? pronunciationScore;
  final List<String> mistakes;
  final List<String> focusAreas;
  final int sessionsCompleted;
  final String? lastUpdated;
  final List<WordMistake> frequentWordMistakes; // top word-level mistakes

  UserProfile({
    required this.userId,
    this.grammarScore,
    this.vocabularyScore,
    this.pronunciationScore,
    this.mistakes = const [],
    this.focusAreas = const [],
    this.sessionsCompleted = 0,
    this.lastUpdated,
    this.frequentWordMistakes = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? '',
      grammarScore: json['grammar_score'],
      vocabularyScore: json['vocabulary_score'],
      pronunciationScore: json['pronunciation_score'],
      mistakes: List<String>.from(json['mistakes'] ?? []),
      focusAreas: List<String>.from(json['focus_areas'] ?? []),
      sessionsCompleted: json['sessions_completed'] ?? 0,
      lastUpdated: json['last_updated'],
      frequentWordMistakes: ((json['frequent_word_mistakes'] as List<dynamic>?) ?? [])
          .map((e) => WordMistake.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'grammar_score': grammarScore,
      'vocabulary_score': vocabularyScore,
      'pronunciation_score': pronunciationScore,
      'mistakes': mistakes,
      'focus_areas': focusAreas,
      'sessions_completed': sessionsCompleted,
      'last_updated': lastUpdated,
      'frequent_word_mistakes': frequentWordMistakes.map((w) => w.toJson()).toList(),
    };
  }
}

class ScenarioModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String characterPrompt;
  final bool isActive;
  final DateTime createdAt;

  ScenarioModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.characterPrompt,
    required this.isActive,
    required this.createdAt,
  });

  factory ScenarioModel.fromJson(Map<String, dynamic> json) {
    return ScenarioModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['icon_name'] as String? ?? 'chat_bubble',
      characterPrompt: json['character_prompt'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'icon_name': iconName,
    'character_prompt': characterPrompt,
    'is_active': isActive,
  };
}

class ClassModel {
  final String id;
  final String name;
  final String? description;
  final String teacherId;
  final String inviteCode;
  final DateTime createdAt;
  final int? studentCount;

  ClassModel({
    required this.id,
    required this.name,
    this.description,
    required this.teacherId,
    required this.inviteCode,
    required this.createdAt,
    this.studentCount,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      teacherId: json['teacher_id'] as String,
      inviteCode: json['invite_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      studentCount: json['student_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'invite_code': inviteCode,
  };
}

class StudentSummary {
  final String id;
  final String username;
  final String? email;
  final double? avgGrammar;
  final double? avgVocabulary;
  final double? avgPronunciation;
  final int sessionCount;
  final DateTime? lastSeen;

  StudentSummary({
    required this.id,
    required this.username,
    this.email,
    this.avgGrammar,
    this.avgVocabulary,
    this.avgPronunciation,
    required this.sessionCount,
    this.lastSeen,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) {
    return StudentSummary(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avgGrammar: (json['avg_grammar'] as num?)?.toDouble(),
      avgVocabulary: (json['avg_vocabulary'] as num?)?.toDouble(),
      avgPronunciation: (json['avg_pronunciation'] as num?)?.toDouble(),
      sessionCount: json['session_count'] as int? ?? 0,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
    );
  }
}

class SessionSummary {
  final int grammarScore;
  final int vocabularyScore;
  final int pronunciationScore;
  final List<String> mistakes;
  final List<WordMistake> wordMistakes;
  final List<String> focusAreas;
  final String sessionSummary;
  final String improvement;
  final String? scenario;
  final String? difficulty;
  final int messagesSent;
  final double? overallScore;

  SessionSummary({
    required this.grammarScore,
    required this.vocabularyScore,
    required this.pronunciationScore,
    required this.mistakes,
    required this.wordMistakes,
    required this.focusAreas,
    required this.sessionSummary,
    required this.improvement,
    this.scenario,
    this.difficulty,
    this.messagesSent = 0,
    this.overallScore,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      grammarScore: (json['grammar_score'] ?? 0).toInt(),
      vocabularyScore: (json['vocabulary_score'] ?? 0).toInt(),
      pronunciationScore: (json['pronunciation_score'] ?? 0).toInt(),
      mistakes: List<String>.from(json['mistakes'] ?? []),
      wordMistakes: ((json['word_mistakes'] as List<dynamic>?) ?? [])
          .map((e) => WordMistake.fromJson(e as Map<String, dynamic>))
          .toList(),
      focusAreas: List<String>.from(json['focus_areas'] ?? []),
      sessionSummary: json['session_summary'] ?? '',
      improvement: json['improvement'] ?? '',
      scenario: json['scenario'] as String?,
      difficulty: json['difficulty'] as String?,
      messagesSent: (json['messages_sent'] ?? 0).toInt(),
      overallScore: (json['overall_score'] as num?)?.toDouble(),
    );
  }
}

class SessionRecord {
  final String date;
  final int grammarScore;
  final int vocabularyScore;
  final int pronunciationScore;
  final List<String> mistakes;
  final List<String> focusAreas;
  final String sessionSummary;
  final String improvement;

  SessionRecord({
    required this.date,
    required this.grammarScore,
    required this.vocabularyScore,
    required this.pronunciationScore,
    required this.mistakes,
    required this.focusAreas,
    required this.sessionSummary,
    required this.improvement,
  });

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      date: json['date'] ?? '',
      grammarScore: json['grammar_score'] ?? 0,
      vocabularyScore: json['vocabulary_score'] ?? 0,
      pronunciationScore: json['pronunciation_score'] ?? 0,
      mistakes: List<String>.from(json['mistakes'] ?? []),
      focusAreas: List<String>.from(json['focus_areas'] ?? []),
      sessionSummary: json['session_summary'] ?? '',
      improvement: json['improvement'] ?? '',
    );
  }

  String get formattedDate {
    try {
      final dt = DateTime.parse(date);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      return date.length > 10 ? date.substring(0, 10) : date;
    }
  }

  double get averageScore =>
      (grammarScore + vocabularyScore + pronunciationScore) / 3.0;
}

class Exercise {
  final String type; // "grammar", "vocabulary", "fill_blank", "word_order"
  final String question;
  final String? sentence;        // for grammar, vocabulary, fill_blank
  final List<String>? options;   // for grammar, vocabulary, fill_blank
  final int? correct;            // index of correct option (0-based)
  final List<String>? words;     // for word_order only
  final String? correctSentence; // for word_order only
  final String explanation;

  Exercise({
    required this.type,
    required this.question,
    this.sentence,
    this.options,
    this.correct,
    this.words,
    this.correctSentence,
    required this.explanation,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    // Backend may send either 'correct' or 'correct_index'
    final correctRaw = json['correct'] ?? json['correct_index'];
    int? correctIndex;
    if (correctRaw != null) {
      correctIndex = correctRaw is int
          ? correctRaw
          : int.tryParse(correctRaw.toString());
    }

    return Exercise(
      type: json['type'] ?? 'grammar',
      question: json['question'] ?? '',
      sentence: json['sentence'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      correct: correctIndex,
      words: json['words'] != null
          ? List<String>.from(json['words'])
          : null,
      correctSentence: json['correct_sentence'],
      explanation: json['explanation'] ?? '',
    );
  }
}

class ExerciseResult {
  final String date;
  final int total;
  final int correct;
  final double scorePercent;
  final List<String> typesSelected;
  final Map<String, double> categoryScores;

  ExerciseResult({
    required this.date,
    required this.total,
    required this.correct,
    required this.scorePercent,
    required this.typesSelected,
    required this.categoryScores,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      date: json['date'] ?? '',
      total: json['total'] ?? 0,
      correct: json['correct'] ?? 0,
      scorePercent: (json['score_percent'] ?? 0).toDouble(),
      typesSelected: List<String>.from(json['types_selected'] ?? []),
      // Always cast to double — backend may return int (e.g. 100) or double
      categoryScores: ((json['category_scores'] as Map<String, dynamic>?) ?? {})
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }

  String get formattedDate {
    try {
      final dt = DateTime.parse(date);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) {
      return date.length > 10 ? date.substring(0, 10) : date;
    }
  }
}

class ChatResponse {
  final bool success;
  final String response;
  final String? corrections;
  final String? error;
  final String? speechEmotion;
  final String? speechPace;

  ChatResponse({
    required this.success,
    required this.response,
    this.corrections,
    this.error,
    this.speechEmotion,
    this.speechPace,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] ?? false,
      response: json['response'] ?? '',
      corrections: json['corrections'],
      error: json['error'],
      speechEmotion: json['speech_emotion'],
      speechPace: json['speech_pace'],
    );
  }
}

enum ScenarioType { casual, jobInterview, travel }

class Scenario {
  final ScenarioType type;
  final String name;
  final String description;
  final IconData icon;

  Scenario({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
  });

  String get apiValue {
    switch (type) {
      case ScenarioType.casual:
        return 'casual';
      case ScenarioType.jobInterview:
        return 'job_interview';
      case ScenarioType.travel:
        return 'travel';
    }
  }

  static final List<Scenario> allScenarios = [
    Scenario(
      type: ScenarioType.casual,
      name: 'Casual Conversation',
      description: 'Chat about everyday topics at a coffee shop',
      icon: Icons.local_cafe,
    ),
    Scenario(
      type: ScenarioType.jobInterview,
      name: 'Job Interview',
      description: 'Practice professional conversations for job interviews',
      icon: Icons.business_center,
    ),
    Scenario(
      type: ScenarioType.travel,
      name: 'Travel Assistant',
      description: 'Learn travel-related phrases and conversations',
      icon: Icons.flight,
    ),
  ];
}

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyExtension on Difficulty {
  String get name {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }

  String get description {
    switch (this) {
      case Difficulty.beginner:
        return 'Detailed corrections, slow pace';
      case Difficulty.intermediate:
        return 'Balanced learning';
      case Difficulty.advanced:
        return 'Natural conversation, minimal correction';
    }
  }

  String get apiValue {
    switch (this) {
      case Difficulty.beginner:
        return 'beginner';
      case Difficulty.intermediate:
        return 'intermediate';
      case Difficulty.advanced:
        return 'advanced';
    }
  }

  int get colorValue {
    switch (this) {
      case Difficulty.beginner:
        return 0xFF4CAF50;
      case Difficulty.intermediate:
        return 0xFFFFC107;
      case Difficulty.advanced:
        return 0xFFF44336;
    }
  }
}

// -------------------- API Service --------------------

class ApiService {
  static const String baseUrl =
      'https://combinatorial-nonepisodic-verena.ngrok-free.dev';

  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<ChatResponse> sendMessage({
    required String userId,
    required String message,
    required List<Message> history,
    required String scenario,
    required String difficulty,
    String? customPrompt,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/chat'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'user_id': userId,
              'message': message,
              'history': history.map((m) => m.toJson()).toList(),
              'scenario': scenario,
              'difficulty': difficulty,
              if (customPrompt != null) 'custom_prompt': customPrompt,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return ChatResponse.fromJson(jsonDecode(response.body));
      }
      return ChatResponse(
          success: false, response: '', error: 'Error: ${response.statusCode}');
    } catch (e) {
      return ChatResponse(
          success: false, response: '', error: 'Connection error: $e');
    }
  }

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/profile/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return UserProfile.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('[ApiService] getProfile error: $e');
    }
    return null;
  }

  Future<bool> saveProfile(UserProfile profile) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/profile/${profile.userId}'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode(profile.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('[ApiService] saveProfile error: $e');
      return false;
    }
  }

  Future<SessionSummary?> summarizeSession({
    required String userId,
    required List<Map<String, String>> conversation,
    required UserProfile currentProfile,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/summarize'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'user_id': userId,
              'conversation': conversation,
              'current_profile': currentProfile.toJson(),
            }),
          )
          .timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return SessionSummary.fromJson(data['summary']);
        }
      }
    } catch (e) {
      print('[ApiService] summarizeSession error: $e');
    }
    return null;
  }

  Future<List<SessionRecord>> getHistory(String userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/history/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final list = data['history'] as List<dynamic>;
          return list.map((e) => SessionRecord.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('[ApiService] getHistory error: $e');
    }
    return [];
  }

  Future<List<Exercise>> getExercises({
    required String userId,
    required String difficulty,
    List<String> types = const ['grammar', 'vocabulary', 'fill_blank', 'word_order'],
    int count = 5,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/exercises'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'user_id': userId,
              'difficulty': difficulty,
              'types': types,
              'count': count,
            }),
          )
          .timeout(const Duration(seconds: 150));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final list = data['exercises'] as List<dynamic>;
          return list.map((e) => Exercise.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('[ApiService] getExercises error: $e');
    }
    return [];
  }

  /// Start a streaming exercise session — returns session_id immediately
  Future<Map<String, dynamic>?> startExerciseSession({
    required String userId,
    required String difficulty,
    required List<String> types,
    required int count,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/exercises/start'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'user_id': userId,
              'difficulty': difficulty,
              'types': types,
              'count': count,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) return data;
      }
    } catch (e) {
      print('[ApiService] startExerciseSession error: $e');
    }
    return null;
  }

  /// Poll for the next ready exercise by index
  Future<Map<String, dynamic>?> pollNextExercise(String sessionId, int index) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/exercises/next/$sessionId?index=$index'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('[ApiService] pollNextExercise error: $e');
    }
    return null;
  }

  /// Clean up session after done
  Future<void> cleanupSession(String sessionId) async {
    try {
      await http
          .delete(
            Uri.parse('$baseUrl/api/exercises/session/$sessionId'),
            headers: {'ngrok-skip-browser-warning': 'true'},
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('[ApiService] cleanupSession error: $e');
    }
  }

  Future<bool> saveExerciseResult({
    required String userId,
    required int total,
    required int correct,
    required List<String> typesSelected,
    required Map<String, double> categoryScores,
  }) async {
    try {
      final scorePercent =
          total > 0 ? (correct / total * 100).roundToDouble() : 0.0;
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/exercise-results/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode({
              'total': total,
              'correct': correct,
              'score_percent': scorePercent,
              'types_selected': typesSelected,
              'category_scores': categoryScores,
            }),
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('[ApiService] saveExerciseResult error: $e');
      return false;
    }
  }

  Future<List<ExerciseResult>> getExerciseHistory(String userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/exercise-history/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final list = data['history'] as List<dynamic>;
          return list.map((e) => ExerciseResult.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('[ApiService] getExerciseHistory error: $e');
    }
    return [];
  }
}

class PronunciationHelper {
  static const Map<String, Map<String, String>> pronunciationDictionary = {
    'knight': {'phonetic': '/naɪt/', 'tip': 'The K is silent. Sounds like "night"'},
    'knife': {'phonetic': '/naɪf/', 'tip': 'The K is silent. Sounds like "nife"'},
    'know': {'phonetic': '/noʊ/', 'tip': 'The K is silent. Sounds like "no"'},
    'kneel': {'phonetic': '/niːl/', 'tip': 'The K is silent. Sounds like "neel"'},
    'knock': {'phonetic': '/nɒk/', 'tip': 'The K is silent. Sounds like "nock"'},
    'island': {'phonetic': '/ˈaɪlənd/', 'tip': 'The S is silent. Sounds like "iland"'},
    'debt': {'phonetic': '/dɛt/', 'tip': 'The B is silent. Sounds like "det"'},
    'doubt': {'phonetic': '/daʊt/', 'tip': 'The B is silent. Sounds like "dowt"'},
    'lamb': {'phonetic': '/læm/', 'tip': 'The B is silent. Sounds like "lam"'},
    'bomb': {'phonetic': '/bɒm/', 'tip': 'The B is silent. Sounds like "bom"'},
    'thumb': {'phonetic': '/θʌm/', 'tip': 'The B is silent. Sounds like "thum"'},
    'wrap': {'phonetic': '/ræp/', 'tip': 'The W is silent. Sounds like "rap"'},
    'write': {'phonetic': '/raɪt/', 'tip': 'The W is silent. Sounds like "rite"'},
    'wrong': {'phonetic': '/rɒŋ/', 'tip': 'The W is silent. Sounds like "rong"'},
    'hour': {'phonetic': '/aʊər/', 'tip': 'The H is silent. Sounds like "our"'},
    'honest': {'phonetic': '/ˈɒnɪst/', 'tip': 'The H is silent. Sounds like "onest"'},
    'psychology': {'phonetic': '/saɪˈkɒlədʒi/', 'tip': 'The P is silent. Starts with "sy"'},
    'receipt': {'phonetic': '/rɪˈsiːt/', 'tip': 'The P is silent. Sounds like "reseet"'},
    'colonel': {'phonetic': '/ˈkɜːnəl/', 'tip': 'Sounds like "kernel", not "col-o-nel"'},
    'salmon': {'phonetic': '/ˈsæmən/', 'tip': 'The L is silent. Sounds like "samen"'},
    'pronunciation': {'phonetic': '/prəˌnʌnsiˈeɪʃən/', 'tip': 'Not "pro-noun-ciation" — no "noun" in it'},
    'february': {'phonetic': '/ˈfebrueri/', 'tip': 'The first R is often skipped: "Feb-roo-ary"'},
    'wednesday': {'phonetic': '/ˈwɛnzdeɪ/', 'tip': 'The D is silent. "Wenz-day"'},
    'comfortable': {'phonetic': '/ˈkʌmftəbl/', 'tip': 'Often said as "comf-ter-ble", 3 syllables'},
    'vegetable': {'phonetic': '/ˈvɛdʒtəbl/', 'tip': 'Often said as "vej-ta-ble", 3 syllables'},
    'temperature': {'phonetic': '/ˈtɛmprətʃər/', 'tip': 'Often said as "temp-ra-ture", 3 syllables'},
    'library': {'phonetic': '/ˈlaɪbrəri/', 'tip': 'Both R sounds matter: "lie-brer-ee"'},
    'particularly': {'phonetic': '/pəˈtɪkjʊləli/', 'tip': 'All 5 syllables: "par-tic-u-lar-ly"'},
    'literally': {'phonetic': '/ˈlɪtərəli/', 'tip': 'All 4 syllables: "lit-er-al-ly"'},
    'especially': {'phonetic': '/ɪˈspɛʃəli/', 'tip': 'Starts with "es", not "ex"'},
    'espresso': {'phonetic': '/ɛˈsprɛsoʊ/', 'tip': 'No X — not "expresso"'},
    'etc': {'phonetic': '/ɛt ˈsɛtərə/', 'tip': '"Et cetera" — not "ex cetera"'},
    'nuclear': {'phonetic': '/ˈnjuːkliər/', 'tip': '"Noo-klee-er" not "noo-cyu-lar"'},
    'athlete': {'phonetic': '/ˈæθliːt/', 'tip': '2 syllables: "ath-leet", not "ath-a-leet"'},
    'mischievous': {'phonetic': '/ˈmɪstʃɪvəs/', 'tip': '3 syllables: "mis-chuh-vus", not "mis-cheev-ee-us"'},
  };

  static List<Map<String, String>> checkMessage(String message) {
    final words = message
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map((word) => word.replaceAll(RegExp(r'[^a-z0-9]'), ''))
        .where((word) => word.isNotEmpty);

    final matches = <Map<String, String>>[];

    for (final word in words) {
      final entry = pronunciationDictionary[word];
      if (entry != null) {
        matches.add({
          'word': word,
          'phonetic': entry['phonetic'] ?? '',
          'tip': entry['tip'] ?? '',
        });
      }
    }

    return matches;
  }
}

// -------------------- Provider / State --------------------

class ChatProvider extends ChangeNotifier {
  String _userId = '';
  Scenario? selectedScenario;
  Difficulty? selectedDifficulty;
  List<Message> messageHistory = [];
  bool isLoading = false;
  String? errorMessage;
  String? currentCorrections;

  ScenarioModel? selectedScenarioModel; // the full Supabase scenario object
  List<ScenarioModel> availableScenarios = []; // loaded from Supabase

  UserProfile? _userProfile;
  bool _isEndingSession = false;

  List<SessionRecord> _sessionHistory = [];
  bool _isLoadingHistory = false;

  List<Exercise> _exercises = [];
  bool _isLoadingExercises = false;

  List<ExerciseResult> _exerciseHistory = [];
  bool _isLoadingExerciseHistory = false;

  String get userId => _userId;
  UserProfile? get userProfile => _userProfile;
  bool get isEndingSession => _isEndingSession;

  List<SessionRecord> get sessionHistory => _sessionHistory;
  bool get isLoadingHistory => _isLoadingHistory;

  List<Exercise> get exercises => _exercises;
  bool get isLoadingExercises => _isLoadingExercises;

  List<ExerciseResult> get exerciseHistory => _exerciseHistory;
  bool get isLoadingExerciseHistory => _isLoadingExerciseHistory;

  bool get hasUsername => _userId.isNotEmpty;

  final ApiService _apiService = ApiService();
  final GcpTtsService _ttsService = GcpTtsService();
  bool ttsEnabled = true;

  ChatProvider();

  Future<void> loadScenarios() async {
    try {
      availableScenarios = await SupabaseService.getScenarios();
      notifyListeners();
    } catch (e) {
      print('Error loading scenarios: $e');
    }
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('username');

    // If no username saved locally, try to auto-generate from Supabase email
    if (savedName == null || savedName.isEmpty) {
      final email = SupabaseConfig.client.auth.currentUser?.email;
      if (email != null && email.isNotEmpty) {
        // Extract username from email: zeromazzi@gmail.com → zeromazzi
        final autoName = email
            .split('@')
            .first
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9_]'), '_');
        if (autoName.isNotEmpty) {
          savedName = autoName;
          await prefs.setString('username', autoName);
          // Save to Supabase profiles too
          await SupabaseService.saveUsername(autoName);
          print('[ChatProvider] Auto-generated username: $autoName');
        }
      }
    }

    if (savedName != null && savedName.isNotEmpty) {
      _userId = savedName;
      _userProfile = await _apiService.getProfile(_userId);
      print('[ChatProvider] User ready: $_userId');
    } else {
      print('[ChatProvider] No username found');
    }

    final supaId = SupabaseService.currentUserId;
    if (supaId != null) {
      SupabaseService.logActivity(userId: supaId);
    }
    await loadScenarios();
    notifyListeners();
  }

  Future<void> setUsername(String name) async {
    final cleaned = name.trim().toLowerCase().replaceAll(' ', '_');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', cleaned);
    _userId = cleaned;

    // Save to Supabase profiles table
    await SupabaseService.saveUsername(cleaned);

    _userProfile = await _apiService.getProfile(_userId);
    print('[ChatProvider] Username set: $_userId');
    notifyListeners();
  }

  Future<void> loadHistory() async {
    if (_userId.isEmpty) return;
    _isLoadingHistory = true;
    notifyListeners();
    try {
      _sessionHistory = await _apiService.getHistory(_userId);
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  // Separate difficulty for exercises (independent of conversation difficulty)
  String _exerciseDifficulty = 'beginner';
  String get exerciseDifficulty => _exerciseDifficulty;

  void setExerciseDifficulty(String difficulty) {
    _exerciseDifficulty = difficulty;
    // no notifyListeners needed — called right before loadExercises
  }

  String _sessionId = '';
  int _exercisesTotal = 0;
  final List<String> _exerciseTopics = [];
  List<String> get exerciseTopics => _exerciseTopics;

  Future<void> loadExercises({
    List<String> types = const ['grammar', 'vocabulary', 'fill_blank', 'word_order'],
    int count = 5,
  }) async {
    if (_userId.isEmpty) return;

    _isLoadingExercises = true;
    _exercises = [];
    _sessionId = '';
    _exercisesTotal = 0;
    notifyListeners();

    final difficulty = _exerciseDifficulty.isNotEmpty
        ? _exerciseDifficulty
        : (selectedDifficulty?.apiValue ?? 'beginner');

    try {
      // Switched to batch mode for better UX — streaming caused timing issues
      await _loadExercisesBatch(types: types, count: count, difficulty: difficulty);
      return;

    } catch (e) {
      print('[ChatProvider] loadExercises error: \$e');
      _isLoadingExercises = false;
      notifyListeners();
    }
  }

  Future<void> _pollExercises() async {
    int nextIndex = 0;
    int failCount = 0;
    const maxFails = 10;
    final deadline = DateTime.now().add(const Duration(seconds: 180));

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(seconds: 2));
      try {
        final data = await _apiService.pollNextExercise(_sessionId, nextIndex);
        if (data == null) { failCount++; continue; }

        if (data['ready'] == true && data['exercise'] != null) {
          _exercises.add(Exercise.fromJson(data['exercise'] as Map<String, dynamic>));
          nextIndex++;
          failCount = 0;
          notifyListeners();
          print('[ChatProvider] Exercise \$nextIndex ready');
        } else {
          failCount++;
        }

        final isDone = data['done'] == true;
        final total  = (data['total'] as int?) ?? _exercisesTotal;
        if (isDone && nextIndex >= total) {
          print('[ChatProvider] All \$total exercises received');
          await _apiService.cleanupSession(_sessionId);
          _sessionId = '';
          notifyListeners();
          break;
        }

        if (failCount >= maxFails) {
          print('[ChatProvider] Too many poll failures — stopping');
          break;
        }
      } catch (e) {
        print('[ChatProvider] Poll error: \$e');
        failCount++;
      }
    }
  }

  Future<void> _loadExercisesBatch({
    required List<String> types,
    required int count,
    required String difficulty,
  }) async {
    _isLoadingExercises = true;
    notifyListeners();
    try {
      _exercises = await _apiService.getExercises(
        userId: _userId,
        difficulty: difficulty,
        types: types,
        count: count,
      );
      print('[ChatProvider] Batch loaded \${_exercises.length} exercises');
    } finally {
      _isLoadingExercises = false;
      notifyListeners();
    }
  }

  Future<void> loadExerciseHistory() async {
    if (_userId.isEmpty) return;
    _isLoadingExerciseHistory = true;
    notifyListeners();
    try {
      _exerciseHistory = await _apiService.getExerciseHistory(_userId);
    } finally {
      _isLoadingExerciseHistory = false;
      notifyListeners();
    }
  }

  String get _ttsScenario {
    if (selectedScenario == null) return 'casual';
    switch (selectedScenario!.type) {
      case ScenarioType.casual:
        return 'casual';
      case ScenarioType.jobInterview:
        return 'interview';
      case ScenarioType.travel:
        return 'travel';
    }
  }

  Future<void> stopTts() async => await _ttsService.stop();

  void setScenario(Scenario scenario) {
    selectedScenario = scenario;
    messageHistory = [];
    currentCorrections = null;
    _ttsService.stop();
    notifyListeners();
  }

  void setScenarioModel(ScenarioModel? model) {
    selectedScenarioModel = model;
    if (model != null) {
      // Keep the existing selectedScenario; the custom prompt will be used in API call
    }
    notifyListeners();
  }

  static String buildCustomScenarioPrompt(String description, String goal) {
    return '''You are a helpful conversation partner helping an English learner practice.

SCENARIO CONTEXT:

$description

THE LEARNER'S GOAL:

$goal

CRITICAL RULES:
- You are a REAL PERSON in this scenario, NOT an AI/bot/assistant
- NEVER say "as an AI" or mention being artificial
- Stay in the context of the scenario described above
- Be encouraging and supportive of the learner
- Keep responses natural and conversational (2-3 sentences max)
- Help the learner achieve their stated goal naturally through conversation

Now begin the conversation based on the scenario:''';
  }

  void setCustomScenario(String description, String goal) {
    selectedScenarioModel = ScenarioModel(
      id: 'custom',
      title: 'My Scenario',
      description: description,
      iconName: 'edit',
      characterPrompt: buildCustomScenarioPrompt(description, goal),
      isActive: true,
      createdAt: DateTime.now(),
    );
    selectedScenario = null;
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    selectedDifficulty = difficulty;
    messageHistory = [];
    currentCorrections = null;
    _ttsService.stop();
    notifyListeners();
  }

  void resetConversation() {
    messageHistory = [];
    currentCorrections = null;
    errorMessage = null;
    _ttsService.stop();
    notifyListeners();
  }

  Future<void> sendMessage(String userMessage) async {
    final bool hasScenario = selectedScenarioModel != null || selectedScenario != null;
    if (!hasScenario || selectedDifficulty == null) {
      errorMessage = 'Please select scenario and difficulty first';
      notifyListeners();
      return;
    }

    await _ttsService.stop();
    messageHistory.add(Message(role: 'user', content: userMessage));
    isLoading = true;
    errorMessage = null;
    currentCorrections = null;
    notifyListeners();

    try {
      final customPrompt = selectedScenarioModel?.characterPrompt;
      final response = await _apiService.sendMessage(
        userId: userId,
        message: userMessage,
        history: messageHistory,
        scenario: selectedScenario?.apiValue ?? 'casual',
        difficulty: selectedDifficulty!.apiValue,
        customPrompt: customPrompt,
      );

      if (response.success) {
        messageHistory.add(Message(
          role: 'assistant',
          content: response.response,
          speechEmotion: response.speechEmotion,
          speechPace: response.speechPace,
        ));
        currentCorrections = response.corrections;
        errorMessage = null;

        if (response.response.isNotEmpty && ttsEnabled) {
          await _ttsService.speak(
            response.response,
            emotion: response.speechEmotion ?? 'neutral',
            scenario: _ttsScenario,
          );
        }

        final supaId = SupabaseService.currentUserId;
        if (supaId != null) {
          SupabaseService.logActivity(
            userId: supaId,
            messagesDelta: 1,
          );
        }
      } else {
        errorMessage = response.error ?? 'Failed to get response';
        messageHistory.removeLast();
      }
    } catch (e) {
      errorMessage = 'Connection error: $e';
      messageHistory.removeLast();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearAll() {
    selectedScenario = null;
    selectedDifficulty = null;
    messageHistory = [];
    currentCorrections = null;
    errorMessage = null;
    _ttsService.stop();
    notifyListeners();
  }

  void setTTSEnabled(bool enabled) {
    ttsEnabled = enabled;
    if (!enabled) _ttsService.stop();
    notifyListeners();
  }

  Future<void> replayText(String text, {String? emotion, String? pace}) async {
    if (text.isEmpty || !ttsEnabled) return;
    await _ttsService.stop();
    await _ttsService.speak(
      text,
      emotion: emotion ?? 'neutral',
      scenario: _ttsScenario,
    );
  }

  Future<bool> saveExerciseResult({
    required int total,
    required int correct,
    required List<String> typesSelected,
    required Map<String, double> categoryScores,
  }) async {
    return await _apiService.saveExerciseResult(
      userId: _userId,
      total: total,
      correct: correct,
      typesSelected: typesSelected,
      categoryScores: categoryScores,
    );
  }

  Future<SessionSummary?> endSession() async {
    if (messageHistory.isEmpty) return null;
    _isEndingSession = true;
    notifyListeners();

    try {
      final conversation = messageHistory
          .map((msg) => {'role': msg.role, 'content': msg.content})
          .toList();

      final summary = await _apiService.summarizeSession(
        userId: _userId,
        conversation: conversation,
        currentProfile: _userProfile ?? UserProfile(userId: _userId),
      );

      if (summary != null) {
        // Merge mistake type strings
        final existingMistakes = _userProfile?.mistakes ?? [];
        final allMistakes = {...existingMistakes, ...summary.mistakes}.toList();
        if (allMistakes.length > 10) {
          allMistakes.removeRange(0, allMistakes.length - 10);
        }

        // Merge word mistakes with frequency counting
        final existingWordMap = <String, WordMistake>{};
        for (final w in _userProfile?.frequentWordMistakes ?? []) {
          existingWordMap[w.wrong.toLowerCase()] = w;
        }
        for (final newW in summary.wordMistakes) {
          final key = newW.wrong.toLowerCase();
          if (existingWordMap.containsKey(key)) {
            existingWordMap[key] = existingWordMap[key]!.copyWithCount(
              existingWordMap[key]!.count + 1,
            );
          } else {
            existingWordMap[key] = newW;
          }
        }
        final sortedWords = existingWordMap.values.toList()
          ..sort((a, b) => b.count.compareTo(a.count));
        final topWords = sortedWords.take(10).toList();

        final updatedProfile = UserProfile(
          userId: _userId,
          grammarScore: summary.grammarScore,
          vocabularyScore: summary.vocabularyScore,
          pronunciationScore: summary.pronunciationScore,
          mistakes: allMistakes,
          focusAreas: summary.focusAreas,
          sessionsCompleted: (_userProfile?.sessionsCompleted ?? 0) + 1,
          lastUpdated: DateTime.now().toIso8601String(),
          frequentWordMistakes: topWords,
        );

        await _apiService.saveProfile(updatedProfile);

        // Also save session scores to Supabase for leaderboard/community
        await SupabaseService.saveSession(
          grammarScore: summary.grammarScore,
          vocabularyScore: summary.vocabularyScore,
          pronunciationScore: summary.pronunciationScore,
          scenario: selectedScenarioModel?.title ?? selectedScenario?.apiValue,
          difficulty: selectedDifficulty?.apiValue,
          messagesSent: messageHistory.where((m) => m.role == 'user').length,
          overallScore: (summary.grammarScore + summary.vocabularyScore + summary.pronunciationScore) / 3,
          aiFeedback: summary.sessionSummary,
        );

        final supaId = SupabaseService.currentUserId;
        if (supaId != null) {
          SupabaseService.logActivity(
            userId: supaId,
            scenariosDelta: 1,
          );

          final avgScore = ((summary.grammarScore) +
              (summary.vocabularyScore) +
              (summary.pronunciationScore)) / 3.0;

          SupabaseService.updateSessionDetails(
            userId: supaId,
            overallScore: avgScore,
            aiFeedback: summary.sessionSummary,
            scenario: selectedScenario?.name ?? '',
            difficulty: selectedDifficulty?.name ?? '',
            messagesSent: messageHistory.where((m) => m.role == 'user').length,
          );
        }

        _userProfile = updatedProfile;
      }

      return summary;
    } finally {
      _isEndingSession = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}







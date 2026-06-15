import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'supabase_config.dart';
import 'backend.dart';

class SupabaseService {
  static final _client = SupabaseConfig.client;
  static SupabaseClient get client => SupabaseConfig.client;

  // ── Auth helpers ──────────────────────────────────────────
  static String? get currentUserId => _client.auth.currentUser?.id;
  static String? get currentUserEmail => _client.auth.currentUser?.email;

  // ── Profile ───────────────────────────────────────────────

  /// Save or update username in Supabase profiles table
  static Future<void> saveUsername(String username) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _client.from('profiles').upsert({
      'id': uid,
      'username': username,
      'email': currentUserEmail,
      'last_seen': DateTime.now().toIso8601String(),
    });
  }

  /// Get profile by Supabase user id
  static Future<Map<String, dynamic>?> getProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();
    return response;
  }

  /// Update last seen timestamp
  static Future<void> updateLastSeen() async {
    final uid = currentUserId;
    if (uid == null) return;
    await _client.from('profiles').update({
      'last_seen': DateTime.now().toIso8601String(),
    }).eq('id', uid);
  }

  static Future<bool> updateUsername(String newUsername) async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;
      await client
          .from('profiles')
          .update({'username': newUsername})
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error updating username: $e');
      return false;
    }
  }

  static Future<bool> updatePassword(String newPassword) async {
    try {
      await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return true;
    } catch (e) {
      print('Error updating password: $e');
      return false;
    }
  }

  /// Save FCM token to profiles table
  static Future<void> saveFcmToken(String token) async {
    try {
      final userId = currentUserId;
      if (userId == null) return;
      await client
          .from('profiles')
          .update({'fcm_token': token})
          .eq('id', userId);
    } catch (e) {
      debugPrint('saveFcmToken error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];
      final response = await client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(30);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('getNotifications error: $e');
      return [];
    }
  }

  static Future<int> getUnreadNotificationCount() async {
    try {
      final userId = currentUserId;
      if (userId == null) return 0;
      final response = await client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> markAllNotificationsRead() async {
    try {
      final userId = currentUserId;
      if (userId == null) return;
      await client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId);
    } catch (e) {
      debugPrint('markAllNotificationsRead error: $e');
    }
  }

  static Future<void> insertNotification({
    required String targetUserId,
    required String type,
    required String message,
    String? postId,
    String? fromUsername,
  }) async {
    try {
      await client.from('notifications').insert({
        'user_id': targetUserId,
        'type': type,
        'message': message,
        'post_id': postId,
        'from_username': fromUsername,
        'is_read': false,
      });
    } catch (e) {
      debugPrint('insertNotification error: $e');
    }
  }

  static Future<void> sendPushNotification({
    required String targetUserId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await client.functions.invoke(
        'send-push-notification',
        body: {
          'target_user_id': targetUserId,
          'title': title,
          'body': body,
        },
      );
      debugPrint('sendPushNotification response: ${response.data}');
    } catch (e) {
      debugPrint('sendPushNotification error: $e');
    }
  }

  // ── Sessions ──────────────────────────────────────────────

  /// Save a completed session score to Supabase
  static Future<void> saveSession({
    required int grammarScore,
    required int vocabularyScore,
    required int pronunciationScore,
    String? scenario,
    String? difficulty,
    int messagesSent = 0,
    double? overallScore,
    String? aiFeedback,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _client.from('sessions').insert({
      'user_id': uid,
      'grammar_score': grammarScore,
      'vocabulary_score': vocabularyScore,
      'pronunciation_score': pronunciationScore,
      'overall_score': overallScore ??
          ((grammarScore + vocabularyScore + pronunciationScore) / 3),
      'ai_feedback': aiFeedback,
      'scenario': scenario,
      'difficulty': difficulty,
      'messages_sent': messagesSent,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get leaderboard (top 20 users by session count)
  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final response = await _client
        .from('leaderboard')
        .select()
        .limit(20);
    return List<Map<String, dynamic>>.from(response);
  }

  // ── Community Posts ───────────────────────────────────────

  /// Fetch all posts ordered by newest first
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Create a new post
  static Future<void> createPost(String content, String username) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _client.from('posts').insert({
      'user_id': uid,
      'username': username,
      'content': content,
      'likes': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Delete a post (only own posts)
  static Future<void> deletePost(String postId) async {
    await _client.from('posts').delete().eq('id', postId);
  }

  /// Like a post
  static Future<void> likePost(String postId) async {
    final uid = currentUserId;
    if (uid == null) return;
    // Add to likes junction table
    await _client.from('post_likes').insert({
      'user_id': uid,
      'post_id': postId,
    });
    // Increment likes counter
    await _client.rpc('increment_likes', params: {'post_id': postId});
    // Notify post owner
    try {
      final postData = await client
          .from('posts')
          .select('user_id, content')
          .eq('id', postId)
          .single();
      final ownerId = postData['user_id'] as String;
      final currentId = currentUserId;
      if (ownerId != currentId) {
        final profile = await client
            .from('profiles')
            .select('username')
            .eq('id', currentId!)
            .single();
        final liker = profile['username'] ?? 'Someone';
        await insertNotification(
          targetUserId: ownerId,
          type: 'like',
          message: '$liker liked your post',
          postId: postId,
          fromUsername: liker,
        );
        await sendPushNotification(
          targetUserId: ownerId,
          title: 'New Like ❤️',
          body: '$liker liked your post',
        );
      }
    } catch (e) {
      debugPrint('like notification error: $e');
    }
  }

  /// Unlike a post
  static Future<void> unlikePost(String postId) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _client.from('post_likes').delete()
        .eq('user_id', uid)
        .eq('post_id', postId);
    await _client.rpc('decrement_likes', params: {'post_id': postId});
  }

  /// Get list of post IDs that current user has liked
  static Future<List<String>> getLikedPostIds() async {
    final uid = currentUserId;
    if (uid == null) return [];
    final response = await _client
        .from('post_likes')
        .select('post_id')
        .eq('user_id', uid);
    return List<Map<String, dynamic>>.from(response)
        .map((e) => e['post_id'] as String)
        .toList();
  }

  // ── Admin ─────────────────────────────────────────────────

  /// Get all users (admin only)
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Check if current user is admin
  static Future<bool> isAdmin() async {
    final profile = await getProfile();
    return profile?['role'] == 'admin';
  }

  // ── Comments ──────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getComments(String postId) async {
    final response = await _client
        .from('comments')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addComment({
    required String postId,
    required String content,
    required String username,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;
    await _client.from('comments').insert({
      'post_id': postId,
      'user_id': uid,
      'username': username,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });
    // Notify post owner
    try {
      final postData = await client
          .from('posts')
          .select('user_id')
          .eq('id', postId)
          .single();
      final ownerId = postData['user_id'] as String;
      final currentId = currentUserId;
      if (ownerId != currentId) {
        await insertNotification(
          targetUserId: ownerId,
          type: 'comment',
          message: '$username commented on your post',
          postId: postId,
          fromUsername: username,
        );
        await sendPushNotification(
          targetUserId: ownerId,
          title: 'New Comment 💬',
          body: '$username commented on your post',
        );
      }
    } catch (e) {
      debugPrint('comment notification error: $e');
    }
  }

  static Future<void> deleteComment(String commentId) async {
    await _client.from('comments').delete().eq('id', commentId);
  }

  static Future<int> getCommentCount(String postId) async {
    final response = await _client
        .from('comments')
        .select()
        .eq('post_id', postId);
    return List.from(response).length;
  }

  static Future<Map<String, dynamic>> getAppStats() async {
    final users = await _client.from('profiles').select();
    final totalUsers = List.from(users).length;

    final sessions = await _client.from('sessions').select();
    final sessionsList = List<Map<String, dynamic>>.from(sessions);
    final totalSessions = sessionsList.length;

    double avgGrammar = 0;
    double avgVocab = 0;
    double avgPronunciation = 0;
    if (sessionsList.isNotEmpty) {
      avgGrammar = sessionsList
          .map((s) => (s['grammar_score'] as num?)?.toDouble() ?? 0)
          .reduce((a, b) => a + b) / sessionsList.length;
      avgVocab = sessionsList
          .map((s) => (s['vocabulary_score'] as num?)?.toDouble() ?? 0)
          .reduce((a, b) => a + b) / sessionsList.length;
      avgPronunciation = sessionsList
          .map((s) => (s['pronunciation_score'] as num?)?.toDouble() ?? 0)
          .reduce((a, b) => a + b) / sessionsList.length;
    }

    final posts = await _client.from('posts').select();
    final totalPosts = List.from(posts).length;

    final comments = await _client.from('comments').select();
    final totalComments = List.from(comments).length;

    return {
      'total_users': totalUsers,
      'total_sessions': totalSessions,
      'avg_grammar': avgGrammar,
      'avg_vocab': avgVocab,
      'avg_pronunciation': avgPronunciation,
      'total_posts': totalPosts,
      'total_comments': totalComments,
    };
  }

  static Future<List<Map<String, dynamic>>> getAllPosts() async {
    final response = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> adminDeletePost(String postId) async {
    await _client.from('posts').delete().eq('id', postId);
  }

  static Future<void> adminDeleteComment(String commentId) async {
    await _client.from('comments').delete().eq('id', commentId);
  }

  static Future<void> updateSessionDetails({
    required String userId,
    required double overallScore,
    required String aiFeedback,
    required String scenario,
    required String difficulty,
    required int messagesSent,
  }) async {
    try {
      final row = await client
          .from('sessions')
          .select('id')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .single();
      final sessionId = row['id'];
      await client.from('sessions').update({
        'overall_score': overallScore,
        'ai_feedback': aiFeedback,
        'scenario': scenario,
        'difficulty': difficulty,
        'messages_sent': messagesSent,
      }).eq('id', sessionId);
    } catch (e) {
      // fail silently — not critical
    }
  }

  static Future<void> logActivity({
    required String userId,
    int scenariosDelta = 0,
    int exercisesDelta = 0,
    int messagesDelta = 0,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);

      List existing = await client
          .from('activity_log')
          .select()
          .eq('user_id', userId)
          .eq('date', today)
          .limit(1);

      if (existing.isEmpty) {
        await client.from('activity_log').insert({
          'user_id': userId,
          'date': today,
          'scenarios_done': scenariosDelta,
          'exercises_done': exercisesDelta,
          'messages_sent': messagesDelta,
        });
      } else {
        final row = existing[0];
        await client.from('activity_log').update({
          'scenarios_done': (row['scenarios_done'] ?? 0) + scenariosDelta,
          'exercises_done': (row['exercises_done'] ?? 0) + exercisesDelta,
          'messages_sent': (row['messages_sent'] ?? 0) + messagesDelta,
        }).eq('id', row['id']);
      }
    } catch (e) {
      // fail silently
    }
  }

  static Future<List<Map<String, dynamic>>> getActivityLog(String userId) async {
    try {
      final rows = await client
          .from('activity_log')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false)
          .limit(30);
      return List<Map<String, dynamic>>.from(rows);
    } catch (e) {
      return [];
    }
  }

  static Future<int> getLoginStreak(String userId) async {
    try {
      final rows = await client
          .from('activity_log')
          .select('date')
          .eq('user_id', userId)
          .order('date', ascending: false)
          .limit(60);

      if (rows.isEmpty) return 0;

      final dates = (rows as List)
          .map((r) => DateTime.parse(r['date']))
          .toList();

      int streak = 0;
      DateTime check = DateTime.now();
      check = DateTime(check.year, check.month, check.day);

      for (final d in dates) {
        final day = DateTime(d.year, d.month, d.day);
        if (day == check || day == check.subtract(const Duration(days: 1)) && streak == 0) {
          streak++;
          check = day.subtract(const Duration(days: 1));
        } else if (day == check) {
          streak++;
          check = check.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
      return streak;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> getEnrichedSessions(String userId) async {
    try {
      final rows = await client
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(20);
      return List<Map<String, dynamic>>.from(rows);
    } catch (e) {
      return [];
    }
  }

  // ── Scenarios ─────────────────────────────────────────

  static Future<List<ScenarioModel>> getScenarios() async {
    try {
      final response = await client
          .from('scenarios')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: true);
      return (response as List)
          .map((e) => ScenarioModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching scenarios: $e');
      return [];
    }
  }

  static Future<List<ScenarioModel>> getAllScenarios() async {
    try {
      final response = await client
          .from('scenarios')
          .select()
          .order('created_at', ascending: true);
      return (response as List)
          .map((e) => ScenarioModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching all scenarios: $e');
      return [];
    }
  }

  static Future<bool> createScenario(ScenarioModel scenario) async {
    try {
      final userId = currentUserId;
      await client.from('scenarios').insert({
        ...scenario.toJson(),
        'created_by': userId,
        'is_active': false,
      });
      return true;
    } catch (e) {
      print('Error creating scenario: $e');
      return false;
    }
  }

  static Future<bool> updateScenarioStatus(String scenarioId, bool isActive) async {
    try {
      await client
          .from('scenarios')
          .update({'is_active': isActive})
          .eq('id', scenarioId);
      return true;
    } catch (e) {
      print('Error updating scenario: $e');
      return false;
    }
  }

  static Future<bool> deleteScenario(String scenarioId) async {
    try {
      await client
          .from('scenarios')
          .delete()
          .eq('id', scenarioId);
      return true;
    } catch (e) {
      print('Error deleting scenario: $e');
      return false;
    }
  }

  static Future<bool> updateScenario(String scenarioId, {
    String? title,
    String? description,
    String? iconName,
    String? characterPrompt,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (iconName != null) updates['icon_name'] = iconName;
      if (characterPrompt != null) updates['character_prompt'] = characterPrompt;
      if (updates.isEmpty) return true;
      await client
          .from('scenarios')
          .update(updates)
          .eq('id', scenarioId);
      return true;
    } catch (e) {
      print('Error updating scenario: $e');
      return false;
    }
  }

  // ── App Settings ──────────────────────────────────────

  static Future<String?> getAppSetting(String key) async {
    try {
      final response = await client
          .from('app_settings')
          .select('value')
          .eq('key', key)
          .single();
      return response['value'] as String?;
    } catch (e) {
      print('Error getting app setting $key: $e');
      return null;
    }
  }

  static Future<bool> updateAppSetting(String key, String value) async {
    try {
      await client
          .from('app_settings')
          .update({'value': value, 'updated_at': DateTime.now().toIso8601String()})
          .eq('key', key);
      return true;
    } catch (e) {
      print('Error updating app setting $key: $e');
      return false;
    }
  }

  // ── Custom Scenario Quota ─────────────────────────────

  static Future<Map<String, dynamic>> getCustomScenarioQuota() async {
    try {
      final userId = currentUserId;
      if (userId == null) return {'used': 0, 'limit': 2, 'allowed': false};

      // Get global limit
      final limitStr = await getAppSetting('custom_scenario_weekly_limit');
      final limit = int.tryParse(limitStr ?? '2') ?? 2;

      // Get user's usage
      final profile = await client
          .from('profiles')
          .select('custom_scenarios_used, custom_scenarios_reset_date')
          .eq('id', userId)
          .single();

      final used = profile['custom_scenarios_used'] as int? ?? 0;
      final resetDateStr = profile['custom_scenarios_reset_date'] as String?;
      final resetDate = resetDateStr != null ? DateTime.parse(resetDateStr) : DateTime.now();
      final now = DateTime.now();

      // Check if we need to reset (7 days passed)
      final daysSinceReset = now.difference(resetDate).inDays;
      if (daysSinceReset >= 7) {
        // Reset the counter
        await client.from('profiles').update({
          'custom_scenarios_used': 0,
          'custom_scenarios_reset_date': now.toIso8601String().split('T')[0],
        }).eq('id', userId);
        return {'used': 0, 'limit': limit, 'allowed': limit > 0};
      }

      return {
        'used': used,
        'limit': limit,
        'allowed': used < limit,
      };
    } catch (e) {
      print('Error getting quota: $e');
      return {'used': 0, 'limit': 2, 'allowed': true};
    }
  }

  static Future<bool> incrementCustomScenarioUsed() async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;

      final profile = await client
          .from('profiles')
          .select('custom_scenarios_used')
          .eq('id', userId)
          .single();

      final used = profile['custom_scenarios_used'] as int? ?? 0;

      await client.from('profiles').update({
        'custom_scenarios_used': used + 1,
      }).eq('id', userId);

      return true;
    } catch (e) {
      print('Error incrementing quota: $e');
      return false;
    }
  }

  // ── Teacher / Classes ─────────────────────────────────

  static String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var code = '';
    var seed = random;
    for (int i = 0; i < 6; i++) {
      code += chars[seed % chars.length];
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    }
    return code;
  }

  static Future<List<ClassModel>> getTeacherClasses() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];
      final response = await client
          .from('classes')
          .select()
          .eq('teacher_id', userId)
          .order('created_at', ascending: true);
      return (response as List)
          .map((e) => ClassModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching teacher classes: $e');
      return [];
    }
  }

  static Future<ClassModel?> createClass(String name, String? description) async {
    try {
      final userId = currentUserId;
      if (userId == null) return null;
      final inviteCode = _generateInviteCode();
      final response = await client.from('classes').insert({
        'name': name,
        'description': description,
        'teacher_id': userId,
        'invite_code': inviteCode,
      }).select().single();
      return ClassModel.fromJson(response);
    } catch (e) {
      print('Error creating class: $e');
      return null;
    }
  }

  static Future<bool> deleteClass(String classId) async {
    try {
      await client.from('classes').delete().eq('id', classId);
      return true;
    } catch (e) {
      print('Error deleting class: $e');
      return false;
    }
  }

  static Future<List<StudentSummary>> getClassStudents(String classId) async {
    try {
      final profilesResponse = await client
          .from('profiles')
          .select('id, username, email, last_seen')
          .eq('class_id', classId);

      final profiles = profilesResponse as List;
      if (profiles.isEmpty) return [];

      final List<StudentSummary> students = [];

      for (final profile in profiles) {
        final userId = profile['id'] as String;

        final sessionsResponse = await client
            .from('sessions')
            .select('grammar_score, vocabulary_score, pronunciation_score')
            .eq('user_id', userId);

        final sessions = sessionsResponse as List;
        final sessionCount = sessions.length;

        double? avgGrammar, avgVocabulary, avgPronunciation;
        if (sessions.isNotEmpty) {
          avgGrammar = sessions
              .map((s) => (s['grammar_score'] as num?)?.toDouble() ?? 0)
              .reduce((a, b) => a + b) / sessionCount;
          avgVocabulary = sessions
              .map((s) => (s['vocabulary_score'] as num?)?.toDouble() ?? 0)
              .reduce((a, b) => a + b) / sessionCount;
          avgPronunciation = sessions
              .map((s) => (s['pronunciation_score'] as num?)?.toDouble() ?? 0)
              .reduce((a, b) => a + b) / sessionCount;
        }

        students.add(StudentSummary(
          id: userId,
          username: profile['username'] as String,
          email: profile['email'] as String?,
          avgGrammar: avgGrammar,
          avgVocabulary: avgVocabulary,
          avgPronunciation: avgPronunciation,
          sessionCount: sessionCount,
          lastSeen: profile['last_seen'] != null
              ? DateTime.parse(profile['last_seen'] as String)
              : null,
        ));
      }

      return students;
    } catch (e) {
      print('Error fetching class students: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getStudentSessions(String userId) async {
    try {
      final response = await client
          .from('sessions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching student sessions: $e');
      return [];
    }
  }

  static Future<bool> joinClassByCode(String inviteCode) async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;

      final classResponse = await client
          .from('classes')
          .select('id')
          .eq('invite_code', inviteCode.toUpperCase().trim())
          .single();

      final classId = classResponse['id'] as String;

      await client
          .from('profiles')
          .update({'class_id': classId})
          .eq('id', userId);

      return true;
    } catch (e) {
      print('Error joining class: $e');
      return false;
    }
  }

  static Future<bool> leaveClass() async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;
      await client
          .from('profiles')
          .update({'class_id': null})
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error leaving class: $e');
      return false;
    }
  }

  static Future<ClassModel?> getStudentClass() async {
    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final profile = await client
          .from('profiles')
          .select('class_id')
          .eq('id', userId)
          .single();

      final classId = profile['class_id'] as String?;
      if (classId == null) return null;

      final classResponse = await client
          .from('classes')
          .select()
          .eq('id', classId)
          .single();

      return ClassModel.fromJson(classResponse);
    } catch (e) {
      print('Error fetching student class: $e');
      return null;
    }
  }

  // ── Class Scenarios ───────────────────────────────────

  static Future<bool> assignScenarioToClass(String classId, String scenarioId) async {
    try {
      await client.from('class_scenarios').insert({
        'class_id': classId,
        'scenario_id': scenarioId,
      });
      return true;
    } catch (e) {
      print('Error assigning scenario to class: $e');
      return false;
    }
  }

  static Future<bool> removeScenarioFromClass(String classId, String scenarioId) async {
    try {
      await client
          .from('class_scenarios')
          .delete()
          .eq('class_id', classId)
          .eq('scenario_id', scenarioId);
      return true;
    } catch (e) {
      print('Error removing scenario from class: $e');
      return false;
    }
  }

  static Future<List<ScenarioModel>> getClassScenarios(String classId) async {
    try {
      final response = await client
          .from('class_scenarios')
          .select('scenario_id, scenarios(*)')
          .eq('class_id', classId);

      return (response as List)
          .map((e) => ScenarioModel.fromJson(e['scenarios'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching class scenarios: $e');
      return [];
    }
  }

  static Future<List<ScenarioModel>> getStudentClassScenarios() async {
    try {
      final studentClass = await getStudentClass();
      if (studentClass == null) return [];
      return await getClassScenarios(studentClass.id);
    } catch (e) {
      print('Error fetching student class scenarios: $e');
      return [];
    }
  }

  // ── Role checks ───────────────────────────────────────

  static Future<bool> isTeacher() async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;
      final response = await client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
      return response['role'] == 'teacher';
    } catch (e) {
      return false;
    }
  }

  static Future<bool> promoteToTeacher(String userId) async {
    try {
      await client
          .from('profiles')
          .update({'role': 'teacher'})
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error promoting to teacher: $e');
      return false;
    }
  }

  static Future<bool> demoteFromTeacher(String userId) async {
    try {
      await client
          .from('profiles')
          .update({'role': 'student'})
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error demoting from teacher: $e');
      return false;
    }
  }
}







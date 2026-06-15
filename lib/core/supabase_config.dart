import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://eposlzvatnjbrpercphq.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwb3NsenZhdG5qYnJwZXJjcGhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYxNzgzOTEsImV4cCI6MjA5MTc1NDM5MX0.fPZQQdiiVFh6IoUAACLhybmYfgvO8r07xjTgHAYiZg0';

  static SupabaseClient get client => Supabase.instance.client;
}







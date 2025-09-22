import 'package:azeducation/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ubpiwzohjbeyagmnkvfx.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVicGl3em9oamJleWFnbW5rdmZ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg1MTYzNDUsImV4cCI6MjA3NDA5MjM0NX0.MlFyqtkNuZd5W_GdhXCvuakLMAXRytpRLcLH-qt4F9E",
  );

  runApp(const ProviderScope(child: MyApp()));
}

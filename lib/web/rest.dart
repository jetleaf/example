import 'dart:async';
import 'package:jetleaf/jetleaf.dart';
import 'package:jetleaf_scheduling/jetleaf_scheduling.dart';
import 'package:jetleaf_web/jetleaf_web.dart';

/// {@template rest_test_service}
/// A service demonstrating scheduled REST calls using JetLeaf’s
/// scheduling and REST subsystems.
///
/// This class is managed by the JetLeaf container, and its scheduled
/// methods will automatically execute according to the specified intervals.
/// {@endtemplate}
@Service()
@RequiredAll()
class RestTestService {
  final RestClient rest;

  const RestTestService(this.rest);

  // ─────────────────────────────────────────────────────────────
  // Test scheduled REST call every 10 seconds
  // ─────────────────────────────────────────────────────────────
  @Scheduled(fixedRate: Duration(seconds: 10))
  Future<void> pingServer() async {
    print('⏰ [RestTestService] Running scheduled pingServer()');
    try {
      final response = await rest
          .get()
          .uri("https://httpbin.org/get", query: {"check": "ping"})
          .execute((resp) async => resp.getBody().readAsString());

      print('✅ [pingServer] Received response: $response');
    } catch (e, st) {
      print('❌ [pingServer] Error: $e');
      print(st);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Test POST request every 30 seconds
  // ─────────────────────────────────────────────────────────────
  @Scheduled(fixedRate: Duration(seconds: 30))
  Future<void> sendHeartbeat() async {
    print('⏰ [RestTestService] Running sendHeartbeat()');
    try {
      final body = {
        "service": "RestTestService",
        "timestamp": DateTime.now().toIso8601String(),
        "status": "alive"
      };

      final response = await rest
          .post()
          .uri("https://httpbin.org/post")
          .body(body)
          .execute((resp) async => resp.getBody().readAsString());

      print('✅ [sendHeartbeat] Response: $response');
    } catch (e, st) {
      print('❌ [sendHeartbeat] Error: $e');
      print(st);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Clear dummy cache every minute
  // ─────────────────────────────────────────────────────────────
  @Scheduled(type: CronType.EVERY_MINUTE)
  Future<void> clearCache() async {
    print('🧹 [RestTestService] Clearing in-memory cache...');
    try {
      // Simulate cache clearing
      await Future.delayed(Duration(milliseconds: 200));
      print('✅ [clearCache] Cache cleared successfully');
    } catch (e, st) {
      print('❌ [clearCache] Error: $e');
      print(st);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Fixed delay: runs 15s after previous run finishes
  // ─────────────────────────────────────────────────────────────
  @Scheduled(fixedDelay: Duration(seconds: 15))
  Future<void> syncStatus() async {
    print('🔁 [RestTestService] Starting syncStatus()');
    try {
      final response = await rest
          .get()
          .uri("https://httpbin.org/uuid")
          .execute((resp) async => resp.getBody().readAsString());

      print('✅ [syncStatus] Synced status: $response');
    } catch (e, st) {
      print('❌ [syncStatus] Error: $e');
      print(st);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Simulate random background work every 45 seconds
  // ─────────────────────────────────────────────────────────────
  @Scheduled(fixedRate: Duration(seconds: 45))
  Future<void> randomTask() async {
    print('🎲 [RestTestService] Performing random background work...');
    try {
      await Future.delayed(Duration(milliseconds: 500));
      print('✅ [randomTask] Work done at ${DateTime.now()}');
    } catch (e, st) {
      print('❌ [randomTask] Error: $e');
      print(st);
    }
  }
}
import 'dart:async';
import 'package:calm_notes_app/features/notes/data/datasources/local_notes_datasource.dart';
import 'package:calm_notes_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  final LocalNotesDataSource localNotesDataSource;
  final NotesRepository repo;
  StreamSubscription<ConnectivityResult>? _sub;
  bool _isOnline = false;

  SyncService({required this.localNotesDataSource})
      : repo = NotesRepository();

  Future<void> init() async {
    final result = await Connectivity().checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    _sub = Connectivity().onConnectivityChanged.listen((event) async {
      final nowOnline = event != ConnectivityResult.none;
      if (!_isOnline && nowOnline) {
        await syncPending();
      }
      _isOnline = nowOnline;
    });

    if (_isOnline) await syncPending();
  }

  bool get isOnline => _isOnline;

  Future<void> syncPending() async {
    final pendings = await localNotesDataSource.getPendingNotes();
    for (final p in pendings) {
      try {
        final action = p['pending_action'] as String?;
        if (action == 'upsert') {
          final serverMap = await repo.syncUpsertFromSync(p);
          await localNotesDataSource.markSynced(p['id'].toString(), serverMap);
        } else if (action == 'delete') {
          await repo.syncDeleteFromSync(p['id'].toString(), p);
          await localNotesDataSource.removeLocal(p['id'].toString());
        }
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }

  Future<void> syncNow() async {
    if (!isOnline) return;
    await syncPending();
  }
}

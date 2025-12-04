import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class LocalNotesDataSource {
  final String boxName;
  Box? _box;
  final _uuid = const Uuid();

  LocalNotesDataSource({this.boxName = 'notes_box'});

  Future<void> init() async {
    _box = Hive.box(boxName);
  }

  String _ensureId(Map<String, dynamic> map) {
    final id = map['id']?.toString();
    if (id == null || id.isEmpty) {
      final newId = _uuid.v4();
      map['id'] = newId;
      return newId;
    }
    return id;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final box = _box!;
    final List<Map<String, dynamic>> out = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map) out.add(Map<String, dynamic>.from(v));
    }
    // ordenar por updated_at desc
    out.sort((a, b) => (b['updated_at'] as int).compareTo(a['updated_at'] as int));
    return out;
  }

  Future<void> saveNote(Map<String, dynamic> note, {String pendingAction = 'upsert'}) async {
    final box = _box!;
    final id = _ensureId(note);
    note['pending_action'] = pendingAction;
    await box.put(id, note);
  }

  Future<void> deleteNote(String id) async {
    final box = _box!;
    final entry = box.get(id);
    if (entry is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(entry);
      map['deleted_at'] = DateTime.now().millisecondsSinceEpoch;
      map['pending_action'] = 'delete';
      await box.put(id, map);
    } else {
      // se não existia local, criar um registro 'deleted' para sincronizar
      final map = {
        'id': id,
        'user_id': '',
        'title': '',
        'content': '',
        'tags': <String>[],
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'deleted_at': DateTime.now().millisecondsSinceEpoch,
        'pending_action': 'delete',
      };
      await box.put(id, map);
    }
  }

  Future<List<Map<String, dynamic>>> getPendingNotes() async {
    final box = _box!;
    final List<Map<String, dynamic>> out = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map) {
        final map = Map<String, dynamic>.from(v);
        if (map['pending_action'] != null) out.add(map);
      }
    }
    // ordenar por updated_at
    out.sort((a, b) => (b['updated_at'] as int).compareTo(a['updated_at'] as int));
    return out;
  }

  Future<void> markSynced(String id, Map<String, dynamic> serverMap) async {
    final box = _box!;
    final local = box.get(id);
    if (local is Map) {
      final merged = Map<String, dynamic>.from(local);
      // substitui/atualiza campos com o servidor (inclusive id real)
      merged.addAll(serverMap);
      merged['pending_action'] = null;
      await box.put(merged['id'].toString(), merged);
      // se id mudou (local temp id !== server id) e eram diferentes, remover o antigo
      if (merged['id'].toString() != id) {
        await box.delete(id);
      }
    } else {
      // simplesmente salvar servidor
      final m = Map<String, dynamic>.from(serverMap);
      m['pending_action'] = null;
      await box.put(m['id'].toString(), m);
    }
  }

  Future<void> removeLocal(String id) async {
    final box = _box!;
    await box.delete(id);
  }
}

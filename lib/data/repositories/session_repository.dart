import '../../core/models/session.dart';

abstract interface class SessionRepository {
  Future<List<Session>> getAll();
  Future<Session?> getById(String id);
  Future<Session> save(Session session);
  Future<void> delete(String id);
}

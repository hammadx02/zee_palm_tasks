import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zee_palm_tasks/errors/failures.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(Failure('Unexpected error occurred'));
    }
  }

  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(Failure('Unexpected error occurred'));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

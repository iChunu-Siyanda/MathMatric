// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:math_matric/features/auth/bloc/auth_event.dart';
// import 'package:math_matric/features/auth/bloc/auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final FirebaseAuth _auth;
//   late final StreamSubscription<User?> _sub;

//   AuthBloc(this._auth) : super(AuthInitial()) {
//     on<AuthStarted>(_onStarted);
//     on<AuthLoggedIn>((e, emit) => emit(AuthAuthenticated(e.user)));
//     on<AuthLoggedOut>((e, emit) => emit(AuthUnauthenticated()));
//   }

//   void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
//     emit(AuthLoading());

//     _sub = _auth.authStateChanges().listen((user) {
//       if (user != null) {
//         add(AuthLoggedIn(user));
//       } else {
//         add(AuthLoggedOut());
//       }
//     });
//   }

//   @override
//   Future<void> close() {
//     _sub.cancel();
//     return super.close();
//   }
// }

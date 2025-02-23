/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-17 21:44:04
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

///
/// A custom BlocObserver to monitor and log Bloc events, errors, and transitions.
///
class SimpleBlocObserver extends BlocObserver {
  /// Called whenever an event is added to any Bloc.
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    log(
      '\n'
      '--------------------------------\n'
      '📌 Bloc  : ${bloc.runtimeType} \n'
      '⚡ Event : ${event.toString()} \n'
      '--------------------------------\n',
    );
  }

  /// Called whenever an error occurs in any Bloc.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    log(
      '🚨🚨🚨\n'
      '════════════════════════════════════════\n'
      '               BLOC ERROR               \n'
      '════════════════════════════════════════\n'
      '📌 Bloc   : ${bloc.runtimeType}         \n'
      '❌ Error  : $error                      \n'
      '🔍 StackTrace:\n$stackTrace             \n'
      '════════════════════════════════════════\n',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Called whenever a state transition occurs in any Bloc.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    log(
      '\n'
      '════════════════════════════════════════\n'
      '         BLOC STATE TRANSITION          \n'
      '════════════════════════════════════════\n'
      'Bloc: ${bloc.runtimeType}               \n'
      '----------------------------------------\n'
      '▶ FROM: ${transition.currentState}      \n'
      '▶ TO:   ${transition.nextState}         \n'
      '════════════════════════════════════════\n',
    );
  }
}

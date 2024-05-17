import 'package:equatable/equatable.dart';
import '../../../constants/app_status.dart';

class AuthState extends Equatable {
  final AppStatus appStatus;

  const AuthState({
    this.appStatus = AppStatus.init,
  });

  AuthState copyWith({
    AppStatus? appStatus,
  }) {
    return AuthState(
      appStatus: appStatus?? this.appStatus
    );
  }

  @override
  List<Object?> get props => [appStatus];
}

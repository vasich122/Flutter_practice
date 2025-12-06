import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/user_model.dart';
import '../../../domain/usecases/get_user_usecase.dart';
import '../../../domain/usecases/update_user_status_usecase.dart';
import '../../../shared/service_locator.dart';

class ProfileState extends Equatable {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  String get fullName => user?.fullName ?? '';
  String get group => user?.group ?? '';
  int get course => user?.course ?? 0;
  String get status => user?.status ?? '';

  @override
  List<Object?> get props => [user, isLoading, error];
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserStatusUseCase _updateUserStatusUseCase;

  ProfileCubit({
    GetUserUseCase? getUserUseCase,
    UpdateUserStatusUseCase? updateUserStatusUseCase,
  })  : _getUserUseCase = getUserUseCase ?? locator<GetUserUseCase>(),
        _updateUserStatusUseCase =
            updateUserStatusUseCase ?? locator<UpdateUserStatusUseCase>(),
        super(const ProfileState(isLoading: true)) {
    loadUser();
  }

  Future<void> loadUser() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _getUserUseCase();
      emit(state.copyWith(user: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> updateStatus(String status) async {
    try {
      await _updateUserStatusUseCase(status);
      await loadUser(); // Перезагружаем данные
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}

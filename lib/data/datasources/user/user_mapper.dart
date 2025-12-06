import '../../../core/models/user_model.dart';
import 'user_dto.dart';

/// Mapper для преобразования DTO в бизнес-модель
/// Инкапсулирован внутри DataSource
extension UserMapper on UserDto {
  UserModel toModel() {
    return UserModel(
      id: id,
      login: login,
      fullName: fullName,
      group: group,
      course: course,
      status: status,
    );
  }
}


import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';
import 'package:hready/features/auth/domain/entities/user_entity.dart';

class GetEmployeeProfileUseCase {
  final IEmployeeRepository repository;
  GetEmployeeProfileUseCase(this.repository);

  Future<UserEntity?> call() async {
    final result = await repository.getEmployee();
    final employee = result.fold((failure) => null, (e) => e);
    if (employee == null) return null;
    return UserEntity(
      userId: employee.employeeId,
      name: employee.name,
      email: employee.email,
      role: employee.role,
      profilePicture: employee.profilePicture,
      contactNo: employee.contactNo,
      department: employee.department,
      position: employee.position,
      dateOfJoining: null,
      status: employee.status,
      token: '', // token not available here
    );
  }
} 
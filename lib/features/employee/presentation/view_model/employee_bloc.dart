import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hready/features/employee/domain/use_cases/get_all_employees_use_case.dart';
import 'package:hready/features/employee/domain/use_cases/add_employee_use_case.dart';
import 'package:hready/features/employee/domain/use_cases/update_employee_use_case.dart';
import 'package:hready/features/employee/domain/use_cases/delete_employee_use_case.dart';
import 'package:hready/features/employee/domain/entities/employee_entity.dart';

abstract class EmployeeEvent {}
class LoadEmployees extends EmployeeEvent {}
class AddEmployee extends EmployeeEvent {
  final EmployeeEntity employee;
  AddEmployee(this.employee);
}
class UpdateEmployee extends EmployeeEvent {
  final String id;
  final EmployeeEntity employee;
  UpdateEmployee(this.id, this.employee);
}
class DeleteEmployee extends EmployeeEvent {
  final String id;
  DeleteEmployee(this.id);
}
class EditEmployee extends EmployeeEvent {
  final EmployeeEntity employee;
  EditEmployee(this.employee);
}

abstract class EmployeeState {}
class EmployeeLoading extends EmployeeState {}
class EmployeeLoaded extends EmployeeState {
  final List<EmployeeEntity> employees;
  EmployeeLoaded(this.employees);
}
class EmployeeError extends EmployeeState {
  final String error;
  EmployeeError(this.error);
}
class EmployeeEditing extends EmployeeState {
  final EmployeeEntity employee;
  EmployeeEditing(this.employee);
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetAllEmployeesUseCase getAllEmployeesUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;

  EmployeeBloc({
    required this.getAllEmployeesUseCase,
    required this.addEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.deleteEmployeeUseCase,
  }) : super(EmployeeLoading()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<EditEmployee>(_onEditEmployee);
  }

  Future<void> _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final employees = await getAllEmployeesUseCase();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onAddEmployee(AddEmployee event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      await addEmployeeUseCase(event.employee);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      await updateEmployeeUseCase(event.id, event.employee);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onDeleteEmployee(DeleteEmployee event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      await deleteEmployeeUseCase(event.id);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  void _onEditEmployee(EditEmployee event, Emitter<EmployeeState> emit) {
    emit(EmployeeEditing(event.employee));
  }
} 
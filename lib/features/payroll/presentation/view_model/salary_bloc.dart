import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hready/features/payroll/domain/entities/salary.dart';
import 'package:hready/features/payroll/domain/use_cases/get_all_salaries.dart';
import 'package:hready/features/payroll/domain/use_cases/get_salary_by_employee.dart';
import 'package:hready/features/payroll/domain/use_cases/create_salary.dart';

// Events
abstract class SalaryEvent extends Equatable {
  const SalaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalaries extends SalaryEvent {
  const LoadSalaries();
}

class LoadSalaryByEmployee extends SalaryEvent {
  final String employeeId;

  const LoadSalaryByEmployee(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class CreateSalaryEvent extends SalaryEvent {
  final Map<String, dynamic> salaryData;

  const CreateSalaryEvent(this.salaryData);

  @override
  List<Object?> get props => [salaryData];
}

// States
abstract class SalaryState extends Equatable {
  const SalaryState();

  @override
  List<Object?> get props => [];
}

class SalaryInitial extends SalaryState {}

class SalaryLoading extends SalaryState {}

class SalariesLoaded extends SalaryState {
  final List<Salary> salaries;

  const SalariesLoaded(this.salaries);

  @override
  List<Object?> get props => [salaries];
}

class SalaryLoaded extends SalaryState {
  final Salary salary;

  const SalaryLoaded(this.salary);

  @override
  List<Object?> get props => [salary];
}

class SalaryCreated extends SalaryState {
  final Salary salary;

  const SalaryCreated(this.salary);

  @override
  List<Object?> get props => [salary];
}

class SalaryError extends SalaryState {
  final String message;

  const SalaryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final GetAllSalaries getAllSalaries;
  final GetSalaryByEmployee getSalaryByEmployee;
  final CreateSalary createSalaryUseCase;

  SalaryBloc({
    required this.getAllSalaries,
    required this.getSalaryByEmployee,
    required this.createSalaryUseCase,
  }) : super(SalaryInitial()) {
    on<LoadSalaries>(_onLoadSalaries);
    on<LoadSalaryByEmployee>(_onLoadSalaryByEmployee);
    on<CreateSalaryEvent>(_onCreateSalary);
  }

  Future<void> _onLoadSalaries(LoadSalaries event, Emitter<SalaryState> emit) async {
    emit(SalaryLoading());
    try {
      final salaries = await getAllSalaries.call();
      emit(SalariesLoaded(salaries));
    } catch (e) {
      emit(SalaryError(e.toString()));
    }
  }

  Future<void> _onLoadSalaryByEmployee(LoadSalaryByEmployee event, Emitter<SalaryState> emit) async {
    emit(SalaryLoading());
    try {
      final salary = await getSalaryByEmployee.call(event.employeeId);
      emit(SalaryLoaded(salary));
    } catch (e) {
      emit(SalaryError(e.toString()));
    }
  }

  Future<void> _onCreateSalary(CreateSalaryEvent event, Emitter<SalaryState> emit) async {
    emit(SalaryLoading());
    try {
      final salary = await createSalaryUseCase.call(event.salaryData);
      emit(SalaryCreated(salary));
    } catch (e) {
      emit(SalaryError(e.toString()));
    }
  }
} 
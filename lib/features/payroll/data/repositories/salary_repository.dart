import '../models/salary_model.dart';
import '../datasources/remote_datasource/salary_remote_data_source.dart';

class SalaryRepository {
  final SalaryRemoteDataSource remoteDataSource;
  SalaryRepository(this.remoteDataSource);

  Future<List<SalaryModel>> getAllSalaries() => remoteDataSource.getAllSalaries();
  Future<SalaryModel> getSalaryByEmployee(String employeeId) => remoteDataSource.getSalaryByEmployee(employeeId);
  Future<SalaryModel> createSalary(SalaryModel salary) => remoteDataSource.createSalary(salary);
  Future<SalaryModel> updateSalary(String id, Map<String, dynamic> updateData) => remoteDataSource.updateSalary(id, updateData);
  Future<void> deleteSalary(String id) => remoteDataSource.deleteSalary(id);
} 
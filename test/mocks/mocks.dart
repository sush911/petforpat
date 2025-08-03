import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';

// Auth
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';

// Pet
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

// Mockito package
import 'package:mockito/mockito.dart';

// Manually mock Box<PetModel> because @GenerateMocks doesn't support generics well
class MockBox extends Mock implements Box<PetModel> {}

@GenerateMocks([
  Dio,
  AuthRemoteDataSource,
  PetRemoteDataSource,
  PetLocalDatasource,
])
void main() {}

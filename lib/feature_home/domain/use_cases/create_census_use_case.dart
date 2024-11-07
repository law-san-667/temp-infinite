import 'package:infiniteagent/config/services/services.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';

import '../repositories/census_repository.dart';

class CreateCensusUseCase {
  final CensusRepository _censusRepository;

  CreateCensusUseCase(this._censusRepository);

  Future call(CensusEntity census) async {
    try {
      return _censusRepository.create(census);
    } catch (error) {
      Services.debugLog("Error in create census use case: $error");
      rethrow;
    }
  }
}

import '../../../config/services/services.dart';
import '../entities/census_entity.dart';
import '../repositories/census_repository.dart';

class UpdateCensusUseCase {
  final CensusRepository _censusRepository;

  UpdateCensusUseCase(this._censusRepository);

  Future call(CensusEntity census) async {
    return _censusRepository.update(census).catchError((error) {
      Services.debugLog("Error in update census use case: $error");
      throw error;
    });
  }
}

import 'package:infiniteagent/config/services/services.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';

import '../repositories/census_repository.dart';

class GetCensusListUseCase {
  final CensusRepository _censusRepository;

  GetCensusListUseCase(this._censusRepository);

  Future<List<CensusEntity>> call() async {
    try{
    return await _censusRepository.getCensusList();
    } catch (error) {
      Services.debugLog("Error in get census list use case: $error");
      return [];
    }
  }
}

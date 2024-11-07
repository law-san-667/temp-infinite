import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';

abstract class CensusRepository {
  Future<void> create(CensusEntity census);
  Future<List<CensusEntity>> getCensusList();
  Future<void> update(CensusEntity census);
}

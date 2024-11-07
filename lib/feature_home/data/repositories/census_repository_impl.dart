import 'package:infiniteagent/feature_home/data/data_sources/remote/census_remote_data_source.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';
import 'package:infiniteagent/feature_home/domain/repositories/census_repository.dart';

class CensusRepositoryImpl extends CensusRepository{
  final CensusRemoteDataSource _remoteDataSource;

  CensusRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> create(CensusEntity census) async{
    try {
      await _remoteDataSource.create(census);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<CensusEntity>> getCensusList() async{
    try {
      return await _remoteDataSource.getCensusList();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> update(CensusEntity census) async{
    try {
      await _remoteDataSource.update(census);
    } catch (error) {
      rethrow;
    }
  }

}
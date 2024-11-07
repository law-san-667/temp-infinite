import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:infiniteagent/config/constants.dart';
import 'package:infiniteagent/config/services/services.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';

class CensusRemoteDataSource {
  // POST /user-data-forms/agent create CensusEntity
  Future<void> create(CensusEntity census) async {
    try {
      final response = await http
          .post(
        Uri.parse('$api/user-data-forms/agent'),
        headers: Services.header,
        body: jsonEncode(census.toJson()),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw "Connexion au serveur impossible";
        },
      );
      // final decodedBody = jsonDecode(response.body);
      if (response.statusCode == 201) {
        Services.debugLog("Census created successfully");
      } else {
        Services.debugLog(
            "Error in create census request body => ${response.body}");
        Services.debugLog("Payload was: ${jsonEncode(census.toJson())}");
        throw "Erreur lors du recensement";
      }
    } catch (error) {
      Services.debugLog("Error in create census request : $error");
      if (error is http.ClientException) {
        throw "Veuillez vérifier votre connexion internet";
      }
      rethrow;
    }
  }

  //Get censuslist GET /user-data-forms
  Future<List<CensusEntity>> getCensusList() async {
    try {
      final response = await http.get(
        Uri.parse('$api/user-data-forms'),
        headers: Services.header,
      );
      final decodedBody = jsonDecode(response.body) ?? {};
      // Services.debugLog("Response : $decodedBody");
      if (response.statusCode == 200) {
        final List<CensusEntity> censusList = [];
        if (decodedBody != null) {
          for (var item in decodedBody) {
            if (item != null) censusList.add(CensusEntity.fromJson(item));
          }
        }
        return censusList;
      } else {
        Services.debugLog(
            "Error in get census list request body => $decodedBody");
        throw "Erreur lors de la récupération de la liste des recensements";
      }
    } catch (error) {
      Services.debugLog("Error in get census list request : $error");
      if (error is http.ClientException) {
        throw "Veuillez vérifier votre connexion internet";
      }
      rethrow;
    }
  }

  Future<void> update(CensusEntity census) async {
    try {
      final response = await http.put(
        Uri.parse('$api/user-data-forms/agent/${census.id}'),
        headers: Services.header,
        body: jsonEncode(census.toJson()),
      );
      // final decodedBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Services.debugLog("Census updated successfully");
      } else {
        Services.debugLog(
            "Error in update census request body => ${response.body}");
        throw "Erreur lors de la mise à jour du recensement";
      }
    } catch (error) {
      Services.debugLog("Error in update census request : $error");
      if (error is http.ClientException) {
        throw "Veuillez vérifier votre connexion internet";
      }
      rethrow;
    }
  }
}

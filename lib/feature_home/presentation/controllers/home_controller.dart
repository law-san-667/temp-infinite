import 'package:flutter/material.dart';
import 'package:infiniteagent/feature_home/domain/use_cases/get_census_list_use_case.dart';
import 'package:infiniteagent/injection_container.dart';

import '../../../config/services/services.dart';
import '../../domain/entities/census_entity.dart';

class HomeController extends ChangeNotifier {
  List<CensusEntity> list = [];
  bool isLoading = true;
  late Function viewState;

  Map<String, List<CensusEntity>> get getGroupedList {
    list.sort((a, b) => a.fullName.compareTo(b.fullName));
    Map<String, List<CensusEntity>> groupedMap = {};

    for (var entity in list) {
      String firstLetter = entity.fullName[0].toUpperCase();
      if (groupedMap[firstLetter] == null) {
        groupedMap[firstLetter] = [];
      }
      groupedMap[firstLetter]!.add(entity);
    }

    return groupedMap;
  }

  void init(BuildContext context, Function setState) {
    viewState = setState;

    sl<GetCensusListUseCase>().call().then((value) {
      list = value;
      isLoading = false;
      refreshView();
    }).catchError((error) {
      Services.debugLog("Error in get census list use case: $error");
      isLoading = false;
      refreshView();
    });

    //MOCK
    // Future.delayed(Duration(seconds: 2), () {
    //   list = CensusEntity.getMockedList();
    //   isLoading = false;
    //   refreshView();
    // });
  }

  void refreshPostList(BuildContext context) {
    sl<GetCensusListUseCase>().call().then((value) {
      list = value;
      isLoading = false;
      refreshView();
    }).catchError((error) {
      Services.debugLog("Error in get census list use case: $error");
      isLoading = false;
      refreshView();
    });

    //MOCK
    // isLoading = true;
    // refreshView();
    // Future.delayed((Duration(seconds: 2)), () {
    //   list = CensusEntity.getMockedList();
    //   list.sort((a, b) => a.fullName.compareTo(b.fullName));
    //   isLoading = false;
    //   refreshView();
    // });
  }

  void refreshView() {
    notifyListeners();

    viewState(() {});
  }
}

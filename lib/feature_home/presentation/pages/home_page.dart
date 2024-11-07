import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infiniteagent/feature_home/domain/entities/census_entity.dart';
import 'package:infiniteagent/feature_home/presentation/pages/census_details_page.dart';
import 'package:infiniteagent/feature_home/presentation/widgets/skeleton_widget.dart';
import 'package:infiniteagent/feature_home/presentation/widgets/title_section_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/services/services.dart';
import '../../../core/build_context_extension.dart';
import '../../../core/widgets/custom_refresh_header.dart';
import '../controllers/home_controller.dart';

class CensusDetailValueWidget extends StatelessWidget {
  final String value;
  final IconData? icon;
  const CensusDetailValueWidget({
    super.key,
    this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.height * 0.01,
        horizontal: context.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: icon != null,
            child: Icon(
              icon,
              color: context.primaryColor,
              size: context.height * 0.015,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: context.primaryColor,
              fontSize: context.height * 0.01,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late HomeController controller;
  @override
  Widget build(BuildContext context) {
    controller.viewState = setState;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: context.height * 0.08,
        backgroundColor: context.primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            height: context.height * 0.08,
            width: context.width,
            decoration: BoxDecoration(
              color: context.primaryColor,
            ),
            child: SizedBox(
              height: context.height * 0.08,
              width: context.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: context.width * 0.05),
                    child: Text(
                      "Pulsar-Infinite",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.height * 0.022,
                        color: context.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/sort.svg',
                      // color: context.white,
                      colorFilter: ColorFilter.mode(
                        context.white,
                        BlendMode.srcIn,
                      ),
                      height: context.height * 0.03,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.ellipsis_vertical,
                      color: context.white,
                      size: context.height * 0.035,
                    ),
                    onPressed: () {
                      //dropdown menu with update, delete
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          context.width * 0.8,
                          context.height * 0.1,
                          context.width * 0.1,
                          context.height * 0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        // shadowColor: Colors.black,
                        elevation: 1,
                        // surfaceTintColor: Colors.black,
                        items: [
                          PopupMenuItem(
                            onTap: () => Services.logout(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.width * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: context.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: context.height * 0.02,
                                  ),
                                  SizedBox(
                                    width: context.width * 0.02,
                                  ),
                                  Text(
                                    "Déconnexion",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: context.height * 0.016,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // PopupMenuItem(
                          //   onTap: () {},
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(
                          //       horizontal: context.width * 0.015,
                          //       vertical: context.height * 0.00,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: context.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Icon(
                          //           CupertinoIcons.delete,
                          //           color: Colors.red,
                          //           size: context.height * 0.02,
                          //         ),
                          //         SizedBox(
                          //           width: context.width * 0.02,
                          //         ),
                          //         Text(
                          //           "Supprimer",
                          //           style: TextStyle(
                          //             color: Colors.red,
                          //             fontSize: context.height * 0.016,
                          //             //roboto condensed
                          //             fontWeight: FontWeight.w700,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/census_form');
        },
        shape: //circle
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        backgroundColor: context.primaryColor,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onPanDown: (_) {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search bar
            _buildSearchBar(context),
            CustomListTileWidget(
              title: "Recensement",
              titleSize: context.height * 0.018,
              subtitle: "139 personnes",
              subtitleSize: context.height * 0.014,
              trailing: Container(),
            ),
            Expanded(
              child: SmartRefresher(
                onRefresh: () async {
                  controller.refreshPostList(context);
                  _refreshController.refreshCompleted();
                },
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: false,
                header: const CustomRefreshHeader(),
                child: controller.isLoading
                    ? const SkeletonWidget(
                        skeletonItem: BasicSkeletonItemWidget(),
                      )
                    : controller.list.isNotEmpty
                        ? Builder(builder: (context) {
                            return AzListView(
                              data: controller.list,
                              itemCount: controller.list.length,
                              itemBuilder: (context, index) {
                                CensusEntity item = controller.list[index];
                                return _buildCensusWidget(context, item, index);
                              },
                            );
                          })
                        : _buildNoResultWidget(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Code that depends on inherited widgets like MediaQuery, Theme, etc.
    // This will be called after initState and also when dependencies change.
  }

  @override
  void initState() {
    // Any non-inherited widget related initializations
    controller = context.read<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.init(context, setState);
    });
    super.initState();
  }

  Padding _buildCensusWidget(
      BuildContext context, CensusEntity item, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.02,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CensusDetailsPage(census: item),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: item.isBottomOfList(controller.getGroupedList)
                    ? context.height * 0.04
                    : 0,
                left: context.width * 0.01,
                // right: context.width * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                vertical: context.height * 0.01,
              ),
              child: Stack(
                children: [
                  Visibility(
                    visible: item.isTopOfList(controller.getGroupedList),
                    child: Positioned(
                      top: context.height * 0.03,
                      left: context.width * 0.01,
                      child: Text(
                        item.fullName.substring(0, 1),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: context.height * 0.018,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.02,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: Container(
                            height: context.height * 0.044,
                            width: context.height * 0.044,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: NetworkImage(
                                  item.userInitials,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            item.fullName,
                            style: TextStyle(
                              color: context.black,
                              fontSize: context.height * 0.018,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          subtitle: Text(
                            item.phone,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: context.height * 0.014,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          trailing: InkWell(
                            onTap: () {},
                            child: Icon(
                              CupertinoIcons.ellipsis_vertical,
                              color: context.black,
                              size: context.height * 0.03,
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     CensusDetailValueWidget(
                        //       icon: Icons.location_on_outlined,
                        //       value: item.address,
                        //     ),
                        //     CensusDetailValueWidget(
                        //       value: "${item.profit} FCFA",
                        //     ),
                        //     CensusDetailValueWidget(
                        //       value: "${item.production} Kg",
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: context.height * 0.01,
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 0.5,
                          indent: context.width * 0.05,
                          endIndent: context.width * 0.05,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultWidget(BuildContext context) {
    return SizedBox(
      height: context.height * 0.4,
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Aucun recensement pour le moment',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: context.height * 0.02,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              controller.refreshPostList(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: SizedBox(
              width: context.width * 0.25,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rafraîchir",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.height * 0.013,
        horizontal: context.width * 0.04,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  // controller.searchChannel(value);
                  // setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Recherchez parmi les recensés",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: context.height * 0.015,
                  ),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: context.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // controller.clearSearch();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: context.height * 0.02,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

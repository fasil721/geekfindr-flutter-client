import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/controller/profile_controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/views/screens/users_profile_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({
    Key? key,
    required this.userList,
  }) : super(key: key);
  final List<UserDetials> userList;

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  final searchController = TextEditingController();

  List<UserDetials> searchUser() {
    if (searchController.text.isEmpty) {
      return widget.userList.toList();
    }
    final results = widget.userList.where(
      (element) {
        final userNameMatch = element.username!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );
        if (!userNameMatch) {
          final userRoleMatch = element.role!.toLowerCase().contains(
                searchController.text.toLowerCase(),
              );
          return userRoleMatch;
        }
        return userNameMatch;
      },
    ).toList();
    return results;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return Container(
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: height * 0.01),
            _buildSearchInput(textFactor, height),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: GetBuilder<ProfileController>(
                  id: "searching",
                  builder: (controller) {
                    final results = searchUser();
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(
                              () =>
                                  OtherUserProfile(userId: results[index].id!),
                            );
                            searchController.clear();
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: results[index].avatar!,
                                  fit: BoxFit.fitWidth,
                                  width: width * 0.09,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.withOpacity(0.3),
                                    highlightColor: white,
                                    period: const Duration(
                                      milliseconds: 1000,
                                    ),
                                    child: Container(
                                      height: width * 0.09,
                                      width: width * 0.09,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: width * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    results[index].username!,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: textFactor * 17,
                                    ),
                                  ),
                                  Visibility(
                                    visible: results[index].role!.isNotEmpty,
                                    child: Text(
                                      results[index].role!,
                                      style: GoogleFonts.roboto(
                                        color: grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: textFactor * 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: height * 0.02),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput(double textFactor, double height) => Container(
        height: height * 0.055,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              color: Colors.grey.withOpacity(.1),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => profileController.update(["searching"]),
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: primaryColor,
            ),
            hintText: "Search",
            hintStyle: GoogleFonts.roboto(
              color: grey,
              fontWeight: FontWeight.w500,
              fontSize: textFactor * 15,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: InputBorder.none,
          ),
        ),
      );
}

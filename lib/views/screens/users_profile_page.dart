import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/post_controller.dart';
import 'package:geek_findr/controller/profile_controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/participant_model.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:geek_findr/models/post_models.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/views/components/user_about_view.dart';
import 'package:geek_findr/views/components/user_posts_view.dart';
import 'package:geek_findr/views/components/users_list_bottomsheet.dart';
import 'package:geek_findr/views/screens/chat_view.dart';
import 'package:geek_findr/views/screens/profile_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile>
    with TickerProviderStateMixin {
  int followersCount = 0;
  bool isLoading = false;
  List<MyChatList> my1to1List = [];
  @override
  void initState() {
    profileController.tabController2 = TabController(
      initialIndex: profileController.currentIndextab2,
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  Future<bool> checkUserExistInMyChat(String userId) async {
    final datas = await chatServices.getMyChats();
    final currentUser = Boxes.getCurrentUser();
    final List<Participant> chatUsers = [];
    my1to1List = datas!.where((element) => element.isRoom == false).toList();

    for (final e in my1to1List) {
      final user = e.participants!
          .where((element) => element.id != currentUser.id)
          .first;
      chatUsers.add(user);
    }
    final isNotExit =
        chatUsers.where((element) => element.id == userId).isEmpty;
    return isNotExit;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    final currentUser = Boxes.getCurrentUser();
    return FutureBuilder<UserProfileModel?>(
      future: profileServices.getUserProfilebyId(id: widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            final user = snapshot.data!;
            followersCount = user.followersCount!;
            return Scaffold(
              backgroundColor: white,
              body: SafeArea(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      elevation: 5,
                      automaticallyImplyLeading: false,
                      flexibleSpace: AppBar(
                        leadingWidth: 70,
                        elevation: 0,
                        backgroundColor: white,
                        leading: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: const Color(0xffE7EAF0),
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: "${user.avatar!}&s=${height * 0.15}",
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.3),
                                highlightColor: white,
                                period: const Duration(milliseconds: 1000),
                                child: Container(
                                  height: height * 0.15,
                                  width: height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              Text(
                                user.username!,
                                style: GoogleFonts.poppins(
                                  fontSize: textFactor * 25,
                                  color: Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                user.role == null ? "" : user.role!,
                                style: GoogleFonts.roboto(
                                  fontSize: textFactor * 15,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    profileController.updateTab2Index(1);
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        FutureBuilder<List<ImageModel?>>(
                                          future: postServices
                                              .getMyImages(user.id!),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              final postCount =
                                                  (snapshot.data)!.length;
                                              return Text(
                                                postCount.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: textFactor * 17,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              );
                                            }
                                            return Text(
                                              "",
                                              style: GoogleFonts.poppins(
                                                fontSize: textFactor * 17,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          "Posts",
                                          style: GoogleFonts.roboto(
                                            fontSize: textFactor * 13,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                height: 20,
                                width: 1.5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if (0 < followersCount) {
                                      Get.dialog(loadingIndicator());
                                      final data = await profileServices
                                          .getUserfollowersAndFollowings(
                                        id: user.id!,
                                        type: "followers",
                                      );
                                      Get.back();
                                      Get.bottomSheet(
                                        UsersListView(
                                          userList: data,
                                        ),
                                      );
                                    }
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        GetBuilder<ProfileController>(
                                          id: "followers",
                                          builder: (_) {
                                            return Text(
                                              followersCount.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: textFactor * 17,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          },
                                        ),
                                        Text(
                                          " Followers",
                                          style: GoogleFonts.roboto(
                                            fontSize: textFactor * 13,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                height: 20,
                                width: 1.5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if (0 < user.followingCount!) {
                                      Get.dialog(loadingIndicator());
                                      final data = await profileServices
                                          .getUserfollowersAndFollowings(
                                        id: user.id!,
                                        type: "following",
                                      );
                                      Get.back();
                                      Get.bottomSheet(
                                        UsersListView(
                                          userList: data,
                                        ),
                                      );
                                    }
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(
                                          user.followingCount.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: textFactor * 17,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Followings",
                                          style: GoogleFonts.roboto(
                                            fontSize: textFactor * 12,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(5),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  secondaryColor,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final isNotExist =
                                    await checkUserExistInMyChat(user.id!);
                                if (isNotExist) {
                                  final data =
                                      await chatServices.create1to1Conversation(
                                    userId: user.id!,
                                  );
                                  Get.to(() => ChatDetailPage(item: data!));
                                } else {
                                  for (final i in my1to1List) {
                                    for (final j in i.participants!) {
                                      if (j.id != currentUser.id) {
                                        final s = j.id! == user.id;
                                        if (s) {
                                          Get.to(() => ChatDetailPage(item: i));
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              child: SizedBox(
                                height: height * 0.06,
                                width: width * 0.22,
                                child: Center(
                                  child: Text(
                                    "Message",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: textFactor * 15,
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GetBuilder<ProfileController>(
                              id: "followers",
                              builder: (_) {
                                return FutureBuilder<List<UserDetials>>(
                                  future: profileServices
                                      .getUserfollowersAndFollowings(
                                    id: user.id!,
                                    type: "followers",
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      final followersList = snapshot.data!;
                                      final isFollowing = followersList
                                          .where(
                                            (element) =>
                                                element.id == currentUser.id,
                                          )
                                          .isNotEmpty;
                                      return ElevatedButton(
                                        style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                            5,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            primaryColor,
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (!isFollowing) {
                                            followersCount = followersCount + 1;
                                            final body = {"id": user.id};
                                            profileServices.followUsers(
                                              body: body.cast(),
                                            );
                                          }
                                        },
                                        child: SizedBox(
                                          height: height * 0.06,
                                          width: width * 0.22,
                                          child: Center(
                                            child: Text(
                                              !isFollowing
                                                  ? "Follow"
                                                  : "Following",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: textFactor * 15,
                                                color: white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return ElevatedButton(
                                      style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                          5,
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          primaryColor,
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: SizedBox(
                                        height: height * 0.06,
                                        width: width * 0.22,
                                        child: Center(
                                          child: Text(
                                            "Follow",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: textFactor * 15,
                                              color: white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              labelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              unselectedLabelColor: Colors.grey,
                              controller: profileController.tabController2,
                              labelStyle: GoogleFonts.roboto(
                                fontSize: textFactor * 14,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                              indicator: const CircleTabIndicator(
                                color: primaryColor,
                                radius: 4,
                              ),
                              isScrollable: true,
                              onTap: (index) {
                                profileController.updateTab2Index(index);
                              },
                              tabs: const [
                                Tab(
                                  text: "About",
                                ),
                                Tab(
                                  text: "All Posts",
                                ),
                                Tab(
                                  text: "Posts",
                                ),
                                Tab(
                                  text: "Projects",
                                )
                              ],
                            ),
                          ),
                        ),
                        GetBuilder<ProfileController>(
                          id: "tabs2",
                          builder: (controller) {
                            return IndexedStack(
                              index: profileController.currentIndextab2,
                              children: <Widget>[
                                Visibility(
                                  visible:
                                      profileController.currentIndextab2 == 0,
                                  child: ProfileAboutView(userData: user),
                                ),
                                Visibility(
                                  visible:
                                      profileController.currentIndextab2 == 1,
                                  child: UserPosts(
                                    userId: user.id!,
                                    type: PostType.allPosts,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      profileController.currentIndextab2 == 2,
                                  child: UserPosts(
                                    type: PostType.posts,
                                    userId: user.id!,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      profileController.currentIndextab2 == 3,
                                  child: UserPosts(
                                    type: PostType.projects,
                                    userId: user.id!,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget _buildLoadingScreen() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leadingWidth: 70,
        elevation: 0,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: width, height: height * .03),
                Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.2),
                  highlightColor: white,
                  period: const Duration(milliseconds: 1000),
                  child: Container(
                    height: height * 0.15,
                    width: height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: white,
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: white,
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          height: height * 0.075,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: white,
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          height: height * 0.075,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: white,
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          height: height * 0.5,
                          width: width * 0.98,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConvexClipPath extends CustomClipper<Path> {
  double factor = 25;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - size.height * (factor / 100));
    path.quadraticBezierTo(
      size.width / 2,
      size.height - size.height * ((factor + 40) / 100),
      size.width,
      size.height - size.height * (factor / 100),
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/controller/post_controller.dart';
import 'package:geek_findr/controller/profile_controller.dart';
import 'package:geek_findr/models/post_models.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/resources/colors.dart';
import 'package:geek_findr/resources/constants.dart';
import 'package:geek_findr/resources/functions.dart';
import 'package:geek_findr/views/components/user_about_view.dart';
import 'package:geek_findr/views/components/user_posts_view.dart';
import 'package:geek_findr/views/components/users_list_bottomsheet.dart';
import 'package:geek_findr/views/screens/profile_edit_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  double textFactor = 0;

  @override
  void initState() {
    profileController.tabController1 = TabController(
      initialIndex: profileController.currentIndextab1,
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return GetBuilder<ProfileController>(
      id: "profileView",
      builder: (controller) {
        return FutureBuilder<UserProfileModel?>(
          future: profileServices.getUserProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final userData = snapshot.data;
              if (userData != null) {
                return Scaffold(
                  backgroundColor: white,
                  appBar: AppBar(
                    leadingWidth: 70,
                    elevation: 0,
                    backgroundColor: primaryColor,
                    actions: [
                      IconButton(
                        onPressed: () => Get.to(
                          () => ProfileUpatePage(userData: userData),
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 12)
                    ],
                    leading: PopupMenuButton(
                      itemBuilder: (BuildContext bc) => [
                        PopupMenuItem(
                          value: "2",
                          child: Text(
                            "Logout",
                            style: GoogleFonts.rubik(
                              fontSize: textFactor * 14,
                              color: Colors.black.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                      onSelected: (value) async {
                        if (value == "2") {
                          logoutUser();
                        }
                      },
                      icon: const Icon(Icons.more_vert, color: white),
                    ),
                  ),
                  body: SafeArea(
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            ClipShadowPath(
                              shadow: BoxShadow(
                                color: Colors.grey.withOpacity(.7),
                                blurRadius: 3,
                                spreadRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                              clipper: ConvexClipPath(),
                              child: Container(
                                height: height * 0.19,
                                width: width,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.7),
                                      blurRadius: 115,
                                      spreadRadius: 105,
                                      offset: const Offset(-300, -300),
                                    ),
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.7),
                                      blurRadius: 105,
                                      spreadRadius: 105,
                                      offset: const Offset(400, 500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: height * .03,
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
                                      imageUrl:
                                          "${userData.avatar!}&s=${height * 0.15}",
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey.withOpacity(0.3),
                                        highlightColor: white,
                                        period:
                                            const Duration(milliseconds: 1000),
                                        child: Container(
                                          height: height * 0.15,
                                          width: height * 0.15,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        userData.username!,
                                        style: GoogleFonts.poppins(
                                          fontSize: textFactor * 25,
                                          color: Colors.black.withOpacity(0.9),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        userData.role == null
                                            ? ""
                                            : userData.role!,
                                        style: GoogleFonts.roboto(
                                          fontSize: textFactor * 15,
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                buildUserCountItems(userData),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TabBar(
                                      labelColor: Colors.black,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      unselectedLabelColor: Colors.grey,
                                      controller:
                                          profileController.tabController1,
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
                                        profileController.updateTabIndex(index);
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
                                  id: "tabs",
                                  builder: (controller) {
                                    return IndexedStack(
                                      index: profileController.currentIndextab1,
                                      children: <Widget>[
                                        Visibility(
                                          visible: profileController
                                                  .currentIndextab1 ==
                                              0,
                                          child: ProfileAboutView(
                                            userData: userData,
                                          ),
                                        ),
                                        Visibility(
                                          visible: profileController
                                                  .currentIndextab1 ==
                                              1,
                                          child: UserPosts(
                                            type: PostType.allPosts,
                                            userId: userData.id!,
                                          ),
                                        ),
                                        Visibility(
                                          visible: profileController
                                                  .currentIndextab1 ==
                                              2,
                                          child: UserPosts(
                                            type: PostType.posts,
                                            userId: userData.id!,
                                          ),
                                        ),
                                        Visibility(
                                          visible: profileController
                                                  .currentIndextab1 ==
                                              3,
                                          child: UserPosts(
                                            type: PostType.projects,
                                            userId: userData.id!,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
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
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit,
            ),
          ),
          const SizedBox(width: 12)
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ClipShadowPath(
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(.7),
                blurRadius: 3,
                spreadRadius: 3,
                offset: const Offset(0, 3),
              ),
              clipper: ConvexClipPath(),
              child: Container(
                height: height * 0.19,
                width: width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.7),
                      blurRadius: 115,
                      spreadRadius: 105,
                      offset: const Offset(-300, -300),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(.7),
                      blurRadius: 105,
                      spreadRadius: 105,
                      offset: const Offset(400, 500),
                    ),
                  ],
                ),
              ),
            ),
            ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      height: height * .03,
                    ),
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
                    SizedBox(
                      height: height * 0.02,
                    ),
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
                          SizedBox(
                            height: height * 0.02,
                          ),
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
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: white,
                            period: const Duration(milliseconds: 1000),
                            child: Container(
                              height: height * 04,
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
          ],
        ),
      ),
    );
  }

  Widget buildUserCountItems(UserProfileModel userData) => Container(
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
                onTap: () => profileController.updateTabIndex(1),
                child: Ink(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      GetBuilder<PostsController>(
                        id: "postCount",
                        builder: (controller) =>
                            FutureBuilder<List<ImageModel?>>(
                          future: postServices.getMyImages(
                            userData.id!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              final postCount = (snapshot.data)!.length;
                              return Text(
                                postCount.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: textFactor * 17,
                                  color: Colors.black.withOpacity(
                                    0.8,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return Text(
                              "",
                              style: GoogleFonts.poppins(
                                fontSize: textFactor * 17,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Posts",
                        style: GoogleFonts.roboto(
                          fontSize: textFactor * 13,
                          color: Colors.black.withOpacity(0.8),
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
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              height: 20,
              width: 1.5,
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (0 < userData.followersCount!) {
                    Get.dialog(loadingIndicator());
                    final data =
                        await profileServices.getUserfollowersAndFollowings(
                      id: userData.id!,
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
                      Text(
                        userData.followersCount.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: textFactor * 17,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Followers",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.roboto(
                          fontSize: textFactor * 13,
                          color: Colors.black.withOpacity(0.8),
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
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              height: 20,
              width: 1.5,
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (0 < userData.followingCount!) {
                    Get.dialog(loadingIndicator());
                    final data =
                        await profileServices.getUserfollowersAndFollowings(
                      id: userData.id!,
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
                        userData.followingCount.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: textFactor * 17,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Followings",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.roboto(
                          fontSize: textFactor * 12,
                          color: Colors.black.withOpacity(0.8),
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
      );
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;
  const CircleTabIndicator({required this.color, required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return CirclePainter(color: color, radius: radius);
  }
}

class CirclePainter extends BoxPainter {
  final Color color;
  final double radius;
  const CirclePainter({required this.color, required this.radius});
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint();
    paint.isAntiAlias = true;
    paint.color = color;
    final circleOffset = Offset(
      configuration.size!.width / 2,
      configuration.size!.height - 2 * radius,
    );
    canvas.drawCircle(offset + circleOffset, radius, paint);
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

class ClipShadowPath extends StatelessWidget {
  final BoxShadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final BoxShadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = shadow.toPaint()
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        shadow.spreadRadius,
      );
    final clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

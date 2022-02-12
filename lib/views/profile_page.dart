import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:geek_findr/services/posts.dart';
import 'package:geek_findr/services/profile.dart';
import 'package:geek_findr/views/profile_update_page.dart';
import 'package:geek_findr/views/widgets/profile_about_view.dart';
import 'package:geek_findr/views/widgets/profile_loading_screen.dart';
import 'package:geek_findr/views/widgets/user_posts.dart';
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
  TabController? tabController;
  int currentIndex = 0;
  final controller = Get.find<AppController>();
  // int? postCount;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: currentIndex,
      length: 2,
      vsync: this,
    );
    // getPostCount();
  }

  // Future getPostCount() async {
  //   final images = await getMyImages();
  //   postCount = images.length;
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    return GetBuilder<AppController>(
      id: "prof",
      builder: (controller) {
        return FutureBuilder<UserProfileModel?>(
          future: getUserProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingProfilePage();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final userData = snapshot.data;
              if (userData != null) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leadingWidth: 70,
                    elevation: 0,
                    backgroundColor: primaryColor,
                    actions: [
                      IconButton(
                        onPressed: () => Get.to(
                          () => ProfileUpatePage(userData: userData),
                        ),
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
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          CustomPaint(
                            child: ClipPath(
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
                                      highlightColor: Colors.white,
                                      period: const Duration(milliseconds: 1000),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
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
                                      child: Column(
                                        children: [
                                          GetBuilder<AppController>(
                                            id: "postCount",
                                            builder: (context) {
                                              return FutureBuilder<
                                                  List<ImageModel?>>(
                                                future:
                                                    getMyImages(userData.id!),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    final postCount =
                                                        (snapshot.data)!.length;
                                                    return Text(
                                                      postCount.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            textFactor * 17,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    );
                                                  }
                                                  return Text(
                                                    "",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: textFactor * 17,
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  );
                                                },
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
                                    Container(
                                      color: Colors.grey,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      ),
                                      height: 20,
                                      width: 1.5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            userData.followersCount.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: textFactor * 17,
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontWeight: FontWeight.w600,
                                            ),
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
                                    Container(
                                      color: Colors.grey,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      ),
                                      height: 20,
                                      width: 1.5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            userData.followingCount.toString(),
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TabBar(
                                    labelColor: Colors.black,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    unselectedLabelColor: Colors.grey,
                                    controller: tabController,
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
                                      currentIndex = index;
                                      tabController!.animateTo(index);
                                      controller.update(["tabs"]);
                                    },
                                    tabs: const [
                                      Tab(
                                        text: "About",
                                      ),
                                      Tab(
                                        text: "Posts",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GetBuilder<AppController>(
                                id: "tabs",
                                builder: (controller) {
                                  return IndexedStack(
                                    index: currentIndex,
                                    children: <Widget>[
                                      Visibility(
                                        maintainState: true,
                                        visible: currentIndex == 0,
                                        child: ProfileAboutView(
                                          userData: userData,
                                        ),
                                      ),
                                      Visibility(
                                        maintainState: true,
                                        visible: currentIndex == 1,
                                        child: currentIndex == 1
                                            ? UserPosts(
                                                userId: userData.id!,
                                              )
                                            : const SizedBox(),
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
                );
              }
            }
            return Container();
          },
        );
      },
    );
  }
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

// class BoxShadowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final path = Path();
//     // here are my custom shapes
//     path.moveTo(size.width, size.height * 0.14);
//     path.lineTo(size.width, size.height * 1.0);
//     path.lineTo(size.width - (size.width * 0.99), size.height);
//     path.close();

//     canvas.drawShadow(path, Colors.black45, 3.0, false);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

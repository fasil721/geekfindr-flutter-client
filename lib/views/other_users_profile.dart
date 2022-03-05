import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/components/user_about_view.dart';
import 'package:geek_findr/components/user_posts_view.dart';
import 'package:geek_findr/components/users_list.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:geek_findr/services/postServices/posts.dart';
import 'package:geek_findr/services/profileServices/profile.dart';
import 'package:geek_findr/services/profileServices/user_profile_model.dart';
import 'package:geek_findr/views/profile_page.dart';
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
  TabController? tabController;
  int currentIndex = 0;
  final _controller = Get.find<AppController>();
  int followersCount = 0;
  final _box = Boxes.getInstance();
  final postServices = PostServices();
  final profileServices = ProfileServices();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: currentIndex,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor = textfactorfind(MediaQuery.textScaleFactorOf(context));
    final currentUser = _box.get("user");

    return FutureBuilder<UserProfileModel?>(
      future: profileServices.getUserProfilebyId(id: widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const LoadingProfilePage();
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
                                  onTap: () {},
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
                                  onTap: () {
                                    Get.bottomSheet(
                                      UsersListView(
                                        userId: user.id!,
                                        type: "followers",
                                      ),
                                    );
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        GetBuilder<AppController>(
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                height: 20,
                                width: 1.5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      UsersListView(
                                        userId: user.id!,
                                        type: "following",
                                      ),
                                    );
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
                              onPressed: () {},
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
                            GetBuilder<AppController>(
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
                                                element.id == currentUser!.id,
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
                                                body: body.cast());
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
                                _controller.update(["tabs2"]);
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
                          id: "tabs2",
                          builder: (controller) {
                            return IndexedStack(
                              index: currentIndex,
                              children: <Widget>[
                                Visibility(
                                  maintainState: true,
                                  visible: currentIndex == 0,
                                  child: ProfileAboutView(
                                    userData: user,
                                  ),
                                ),
                                Visibility(
                                  maintainState: true,
                                  visible: currentIndex == 1,
                                  child: UserPosts(userId: user.id!),
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

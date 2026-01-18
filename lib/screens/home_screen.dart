import 'package:campy/shared/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/profileicon.png"),
                      radius: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Let’s start Learning"),
                          //TODO: Replace with user name comming from the backend
                          Text("Hi, Gaafar!"),
                          //TODO: Replace with kudos comming from the backend
                          Text("430 Kudos"),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined),
                    ),
                  ],
                ),
              ),
              //TODO: Extract to be a widget called streak to make the code more readible and shorter
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current Streak"),
                            Text("12 days"),
                            Text("You're on fire! Keep it up."),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.fire_extinguisher_rounded),
                      ],
                    ),
                  ),
                ),
              ),
              //TODO: Extract like the above
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 94,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Kudos"),
                        Text("430"),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: 0.2,
                          minHeight: 12,
                          color: Colors.black,
                          valueColor: null,
                          backgroundColor: Colors.grey[350],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        Row(
                          children: [
                            Text("Level 5"),
                            Spacer(),
                            Text("150 Kudos to Level 6"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Continue Learning"),
              ),
              //TODO: Should be a list view with all the courses to continue learning also fix the image to look like your ui
              //Continue learning section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/continuelearningpic.png"),
                        Text("Introduction to Flutter"),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("4h 30m"),
                            const SizedBox(width: 8),
                            Text("16/24 lessons"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [Text("Progress"), Spacer(), Text("65%")],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: 0.2,
                          minHeight: 10,
                          color: Colors.black,
                          valueColor: null,
                          backgroundColor: Colors.grey[350],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    16,
                                  ),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),

                              fixedSize: WidgetStatePropertyAll(Size(105, 25)),
                            ),
                            onPressed: () {},
                            child: Text("Continue"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              //Recent Acheivment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Recent Achievement"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Icon(Icons.star_border_outlined),
                                Text("5 days streak"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Badges and Certificates
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Badges & Certificates"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(style: BorderStyle.solid),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Image.asset("assets/badges.png")],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          currentIndex: 0,
          onTap: (value) {},
        ),
      ),
    );
  }
}

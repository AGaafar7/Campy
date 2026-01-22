import 'package:campy/shared/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  // Track which index is expanded
  int? _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header Section
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 0,
                  bottom: 110, // Adjust this based on your navbar height + gap
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Vertical List of Lessons
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return _buildExpandableLesson(index);
                      },
                    ),
                    const SizedBox(height: 30),
                    // Certificate Progress Card
                    _buildCertificateCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Intro to mobile design",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.notifications_none_outlined),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableLesson(int index) {
    bool isExpanded = _expandedIndex == index;
    bool isLast = index == 9;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Stepper Line
          Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Collapsible Content
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Intro to good design",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  _buildSubLessonCard("Introduction to Swift", true),
                  const SizedBox(height: 10),
                  _buildSubLessonCard("Introduction to Swift", false),
                ],
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubLessonCard(String title, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D), // Dark grey/black from image
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lesson",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isCompleted)
                const Icon(Icons.check_circle_outline, color: Colors.white),
            ],
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "40 Kudos",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Learn",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCertificateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Icon(Icons.credit_card, size: 80, color: Colors.black54),
          const SizedBox(height: 10),
          const Text(
            "Your Certificate is Close",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            "You are doing great! Keep learning to unlock your certificate",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

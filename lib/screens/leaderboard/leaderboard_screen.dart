import 'package:campy/shared/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Leaderboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                Positioned(
                  top: 12,
                  right: 12,
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
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Podium Section
          _buildPodium(),
          const SizedBox(height: 30),
          // List Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildLeaderboardRow("4", "Marsha Fisher", "36 kudos", false),
                _buildLeaderboardRow("5", "Juanita Cormier", "35 kudos", false),
                _buildLeaderboardRow(
                  "6",
                  "You",
                  "34 kudos",
                  true,
                ), // Highlighted row
                _buildLeaderboardRow("7", "Tamara Schmidt", "33 kudos", false),
                _buildLeaderboardRow("8", "Ricardo Veum", "32 kudos", false),
                _buildLeaderboardRow("9", "Gary Sanford", "31 kudos", false),
                _buildLeaderboardRow("10", "Becky Bartell", "30 kudos", false),
                _buildLeaderboardRow("10", "Becky Bartell", "30 kudos", false),
                _buildLeaderboardRow("10", "Becky Bartell", "30 kudos", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Rank 2
        _buildPodiumUser("Meghan Jes...", "40 kudos", "2", 70),
        const SizedBox(width: 15),
        // Rank 1
        _buildPodiumUser("Bryan Wolf", "43 kudos", "1", 90, isWinner: true),
        const SizedBox(width: 15),
        // Rank 3
        _buildPodiumUser("Alex Turner", "38 kudos", "3", 70),
      ],
    );
  }

  Widget _buildPodiumUser(
    String name,
    String kudos,
    String rank,
    double size, {
    bool isWinner = false,
  }) {
    return Column(
      children: [
        if (isWinner)
          const Icon(
            Icons.wind_power_rounded,
            color: Colors.yellow,
            size: 30,
          ), // You can use an SVG for the exact crown
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.grey[300],
                // backgroundImage: NetworkImage('url_here'),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Text(
                rank,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(kudos, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildLeaderboardRow(
    String rank,
    String name,
    String kudos,
    bool isMe,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 15),
          CircleAvatar(radius: 20, backgroundColor: Colors.grey[300]),
          const SizedBox(width: 15),
          Text(
            name,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            kudos,
            style: TextStyle(color: isMe ? Colors.white : Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:campy/api/campy_backend_manager.dart';
import 'package:campy/app_state.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> topUsers = [];
  List<dynamic> otherUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    setState(() => isLoading = true);
    try {
    
      final response = await getUsers(); 

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body)['data'];

       
        users.sort((a, b) => (b['kudos'] ?? 0).compareTo(a['kudos'] ?? 0));

        setState(() {
 
          topUsers = users.take(3).toList();
   
          otherUsers = users.skip(3).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Leaderboard Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Leaderboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Column(
              children: [
                const SizedBox(height: 20),
                if (topUsers.isNotEmpty) _buildPodium(),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: otherUsers.length,
                    itemBuilder: (context, index) {
                      final user = otherUsers[index];
                      final bool isMe = user['_id'] == AppState().userID;
                      return _buildLeaderboardRow(
                        (index + 4).toString(), 
                        isMe ? "You" : (user['name'] ?? "Anonymous"),
                        "${user['kudos'] ?? 0} kudos",
                        isMe,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPodium() {
    final user1 = topUsers.isNotEmpty ? topUsers[0] : null;
    final user2 = topUsers.length > 1 ? topUsers[1] : null;
    final user3 = topUsers.length > 2 ? topUsers[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
     
        if (user2 != null)
          _buildPodiumUser(user2['name'], "${user2['kudos']} kudos", "2", 70),
        const SizedBox(width: 15),
   
        if (user1 != null)
          _buildPodiumUser(
            user1['name'],
            "${user1['kudos']} kudos",
            "1",
            90,
            isWinner: true,
          ),
        const SizedBox(width: 15),
       
        if (user3 != null)
          _buildPodiumUser(user3['name'], "${user3['kudos']} kudos", "3", 70),
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
          const Icon(Icons.emoji_events, color: Colors.orange, size: 30),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.grey[200],
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Text(
                rank,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
        border: isMe ? null : Border.all(color: Colors.grey.shade100),
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
          CircleAvatar(
            radius: 20,
            backgroundColor: isMe ? Colors.white24 : Colors.grey[300],
            child: Text(
              name[0],
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
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

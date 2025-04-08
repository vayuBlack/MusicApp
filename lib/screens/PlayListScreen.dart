import 'package:flutter/material.dart';
import 'package:music_player/screens/MusicPlayerScreen.dart';
import '../models/Song.dart';

class PlaylistScreen extends StatelessWidget {
  final List<Song> songs = [
    Song(title: 'Digital World', artist: 'Amaranthe', filePath: 'music/Amaranthe - Digital World.mp3'),
    Song(title: 'Monster', artist: 'Peyton Parrish', filePath: 'music/Peyton Parrish - Monster.mp3'),
    Song(title: 'Mortal Kombat', artist: 'The Immortals', filePath: 'music/The Immortals - Mortal Kombat.mp3'),
    Song(title: 'Dane', artist: 'Peyton Parrish (Ft. @tommyvex)', filePath: 'music/Peyton Parrish (Ft. @tommyvex) - Dane.mp3'),
    Song(title: 'ReawakeR', artist: 'Lisa (ft. Felix of Stray Kids))', filePath: 'music/Lisa (ft. Felix of Stray Kids) - ReawakeR .mp3'),
    Song(title: 'Elevator Operator', artist: 'Eletric Callboy', filePath: 'music/Electric Callboy - Elevator Operator.mp3'),
    Song(title: 'Pump it', artist: 'Eletric Callboy', filePath: 'music/Eletcric Callboy - Pump It.mp3'),
    Song(title: 'Hypnodancer', artist: 'Little Big', filePath: 'music/Little Big - Hypnodancer.mp3'),
    Song(title: 'To Be Loved', artist: 'Papa Roach', filePath: 'music/Papa Roach - To Be Loved.mp3'),
    Song(title: 'Bring on The Thunder', artist: 'Redhooknoodles', filePath: 'music/Redhooknoodles - Bring on The Thunder.mp3'),
    Song(title: 'Black Thunder', artist: 'The Hu', filePath: 'music/The Hu - Black Thunder (ft. Serj Tankian and DL of Bad Wolves).mp3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Playlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.greenAccent,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0, // Removes shadow
      ),
      body: Stack(
        children: [
          // Ensures the image takes the full screen space
          Positioned.fill(
            child: Image.asset(
              'assets/beatFlow1.jpg',
              // Makes the image cover the whole screen
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Divider(
                color: Colors.greenAccent,
                thickness: 2.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  physics: BouncingScrollPhysics(), // Allows the ListView to scroll properly with bounce effect
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.library_music, color: Colors.greenAccent),
                          title: Text(
                            songs[index].title,
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                          subtitle: Text(
                            songs[index].artist,
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicPlayerScreen(songs: songs, currentIndex: index),
                              ),
                            );
                          },
                        ),
                        Divider(
                          color: Colors.greenAccent,
                          thickness: 0.8,
                          indent: 18,
                          endIndent: 18,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

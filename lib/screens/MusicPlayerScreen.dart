import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';             // Handles playing, pausing, and stopping audio.
import '../../models/Song.dart';                             // Model for Song class which holds song data.

class MusicPlayerScreen extends StatefulWidget {            // Stateful widget to handle song player states.
  final List<Song> songs;                                   // A list containing all available songs.
  final int currentIndex;                                   // The index of the currently selected song.

  MusicPlayerScreen({required this.songs, required this.currentIndex});         // Constructor to pass songs and the index.

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();             // Creates an instance of the AudioPlayer to handle audio operations.
  bool isPlaying = false;                                    // Tracks whether the song is playing or paused.
  bool isShuffling = false;                                  // Tracks whether shuffle mode is enabled.
  bool isRepeating = false;                                  // Tracks whether repeat mode is enabled.

  double progress = 0.0;                                     // Progress to track current position of the song.
  late int currentIndex;                                     // 'late' means that this will be initialized before it's accessed.
  Duration duration = Duration.zero;                         // Holds the total duration of the current song.

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;                      // Get the current song's index from the parent widget.
    playSong();                                              // Start playing the selected song.

    // Listen for position changes in the song to update the progress.
    audioPlayer.onPositionChanged.listen((Duration newPosition) {
      setState(() {
        progress = newPosition.inMilliseconds.toDouble();    // Update progress to the current song position.
      });
    });

    // Listen for changes in the song's duration.
    audioPlayer.onDurationChanged.listen((Duration newDuration) {
      setState(() {
        duration = newDuration;                               // Update the song's total duration when it starts playing.
      });
    });

    // Listen for state changes (completed song) and automatically play the next song.
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        // Play next song, repeat current song, or shuffle depending on the mode.
        if (isRepeating) {
          playSong();                                         // Repeat the current song.
        } else if (isShuffling) {
          playRandomSong();                                   // Shuffle and play a random song.
        } else {
          playNext();                                         // Play the next song in the list.
        }
      }
    });
  }

  @override
  void dispose() {                                            // Dispose resources when the widget is removed.
    audioPlayer.dispose();                                    // Releases the audio resources to prevent memory leaks.
    super.dispose();                                          // Ensure proper cleanup.
  }

  // Function to play the current song at the currentIndex.
  void playSong() async {                                      // 'async' means this function performs asynchronous operations (e.g., stopping and playing audio).
    await audioPlayer.stop();                                 // Stops any currently playing song before starting a new one.
    await audioPlayer.play(AssetSource(widget.songs[currentIndex].filePath));    // Start playing the selected song from assets.
    setState(() {
      isPlaying = true;                                       // Set the state to playing.
    });
  }

  // Function to toggle between play and pause.
  void togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();                             // Pause if the song is currently playing.
    } else {
      await audioPlayer.play(AssetSource(widget.songs[currentIndex].filePath));   // Resume playback.
    }
    setState(() {
      isPlaying = !isPlaying;                                // Toggle play state (play/pause).
    });
  }

  // Function to play the next song in the list if available.
  void playNext() {
    if (currentIndex < widget.songs.length - 1) {             // Check if there is a next song available.
      setState(() {
        currentIndex++;                                       // Increase the index to move to the next song.
      });
      playSong();                                             // Play the next song.
    } else if (isRepeating) {                                 // If repeating, loop back to the first song.
      setState(() {
        currentIndex = 0;
      });
      playSong();
    }
  }

  // Function to play the previous song in the list if available.
  void playPrevious() {
    setState(() {
      if (currentIndex > 0) {                                 // Check if there is a previous song.
        currentIndex--;                                       // Decrease the index to move to previous song.
        playSong();                                           // Play the previous song.
      } else if (isRepeating) {                               // If repeating, loop to the last song.
        setState(() {
          currentIndex = widget.songs.length - 1;
        });
        playSong();
      }
    });
  }

  // Function to shuffle and play a random song from the list
  void playRandomSong() {
    final randomIndex = (widget.songs..shuffle()).firstWhere(
          (song) => widget.songs.indexOf(song) != currentIndex,       // Ensure random song is not the same as the current song
    );
    setState(() {
      currentIndex = widget.songs.indexOf(randomIndex);              // Update the index to the random song's index.
    });
    playSong();  // Play the random song.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.songs[currentIndex].title,                    // Display the current song's title.
          style: TextStyle(color: Colors.greenAccent),
        ),
        backgroundColor: Colors.black,                          // App bar background color.
        elevation: 0,                                           // No shadow beneath the app bar.
        iconTheme: IconThemeData(                              // 'IconThemeData' is used to control the color of the icons inside the AppBar.
          color: Colors.greenAccent,                           // Icons in the AppBar will be green accent.
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(                                      // Fill the screen with an image.
            child: Image.asset(
              'assets/beatFlow1.jpg',                          // Path to the background image.
              fit: BoxFit.cover,                                // Ensure the image covers the screen.
            ),
          ),
          Align(                                // The 'Align' widget is used to position its child widget within a specific area of its parent widget.
            alignment: Alignment.center,                        // Center the child widgets on the screen.
            child: Column(
              mainAxisSize: MainAxisSize.min,                          // Minimize the space used by the column (vertical in this case)..
              children: [
                Image.asset('assets/beatFlow.jpg', height: 200),       // Display album image (size of image: pixel).
                SizedBox(height: 20),                                  // Space between widgets.
                Text(
                  widget.songs[currentIndex].title,              // Display the title of the current song.
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                ),
                Text(
                  widget.songs[currentIndex].artist,             // Display the artist's name.
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                ),
                SizedBox(height: 20),                                           // Space between widgets.
                Slider(
                  value: progress.clamp(0.0, duration.inMilliseconds.toDouble()),     // Update slider with current progress.
                  onChanged: (value) {
                    audioPlayer.seek(Duration(milliseconds: value.toInt()));         // Seek to the specified position in the song.
                  },
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble(),          // Max value is the song duration.
                  activeColor: Colors.greenAccent,                 // Color for the active part of the slider.
                  inactiveColor: Colors.black12,                   // Color for the inactive part of the slider.
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,         // Center the buttons.
                  children: [
                    // Shuffle Button
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: isShuffling ? Colors.blue : Colors.greenAccent,      // Change color based on shuffle state.
                      ),
                      onPressed: () {
                        setState(() {
                          isShuffling = !isShuffling;               // Toggle shuffle state.
                        });
                      },
                    ),
                    // Previous Song Button
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous,                     // Previous song icon.
                        size: 60,
                        color: Colors.greenAccent,
                      ),
                      onPressed: playPrevious,                    // Call playPrevious function when pressed.
                    ),
                    // Play/Pause Button
                    IconButton(
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled              // Show pause icon if playing(ture).
                            : Icons.play_circle_fill,               // Show play icon if paused(false).
                        size: 60,
                        color: Colors.greenAccent,
                      ),
                      onPressed: togglePlayPause,                  // Toggle play/pause when pressed.
                    ),
                    // Next Song Button
                    IconButton(
                      icon: Icon(
                        Icons.skip_next,                         // Next song icon.
                        size: 60,
                        color: Colors.greenAccent,
                      ),
                      onPressed: playNext,                        // Call playNext function when pressed.
                    ),
                    // Repeat Button
                    IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: isRepeating ? Colors.blue : Colors.greenAccent,      // Change color based on repeat state.
                      ),
                      onPressed: () {
                        setState(() {
                          isRepeating = !isRepeating;              // Toggle repeat state.
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

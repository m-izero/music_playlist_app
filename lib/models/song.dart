class Song {
  final String title;
  final String artist;
  final String url;
  final String albumArtUrl;
  final Duration? duration;

  Song({
    required this.title,
    required this.artist,
    required this.url,
    required this.albumArtUrl,
    this.duration,
  });
}

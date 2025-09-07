// Audio File Model
class AudioFile {
  final String name;
  final String path;
  final String size;
  final DateTime lastModified;
  String? artist;
  String? album;
  Duration? duration;

  AudioFile({
    required this.name,
    required this.path,
    required this.size,
    required this.lastModified,
    this.artist,
    this.album,
    this.duration,
  });

  String get displayName => name.replaceAll(RegExp(r'\.[^.]*$'), '');

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'size': size,
        'lastModified': lastModified.toIso8601String(),
        'artist': artist,
        'album': album,
        'duration': duration?.inMilliseconds,
      };

  factory AudioFile.fromJson(Map<String, dynamic> json) => AudioFile(
        name: json['name'],
        path: json['path'],
        size: json['size'],
        lastModified: DateTime.parse(json['lastModified']),
        artist: json['artist'],
        album: json['album'],
        duration: json['duration'] != null
            ? Duration(milliseconds: json['duration'])
            : null,
      );
}

// Playlist Model
class Playlist {
  final String id;
  late final String name;
  final List<AudioFile> songs;
  final DateTime created;

  Playlist({
    required this.id,
    required this.name,
    required this.songs,
    required this.created,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'songs': songs.map((s) => s.toJson()).toList(),
        'created': created.toIso8601String(),
      };

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json['id'],
        name: json['name'],
        songs:
            (json['songs'] as List).map((s) => AudioFile.fromJson(s)).toList(),
        created: DateTime.parse(json['created']),
      );
}

/*
=============
Author: Lucas Josino
Github: https://github.com/LucJosin
Website: https://www.lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucJosin/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucJosin/on_audio_query/blob/main/on_audio_query/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

import 'dart:io';

import 'package:musico/const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Songs(),
    ),
  );
}

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();

    requestPermission();
  }

  var path = '';
  requestPermission() async {
    _createDir();

    final d = await getApplicationSupportDirectory();
    path = d.path;

    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  _createDir() async {
    final documentsDirectory = await getApplicationSupportDirectory();
    //  final path = '${documentsDirectory.path}${Platform.pathSeparator}dirName2';
    final path =
        '/storage/emulated/0/Android/media${Platform.pathSeparator}musico';
    final dir = Directory(path);
    print('path:$path');
    final exist = dir.existsSync();
    if (exist) {
      print('当前文件夹已经存在');
    } else {
      final result = await dir.create();
      print('$result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OnAudioQueryExample"),
        elevation: 2,
      ),
      body: FutureBuilder<List<SongModel>>(
        // Default values:
        future: _audioQuery.querySongs(
          uriType: UriType.EXTERNAL,
          path: AppConst.localMusicPath,
        ),
        builder: (context, item) {
          // Loading content
          if (item.data == null) return const CircularProgressIndicator();

          // When you try "query" without asking for [READ] or [Library] permission
          // the plugin will return a [Empty] list.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          // You can use [item.data!] direct or you can create a:
          // List<SongModel> songs = item.data!;
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(item.data![index].title),
                subtitle: Text(item.data![index].artist ?? "No Artist"),
                trailing: const Icon(Icons.arrow_forward_rounded),
                // This Widget will query/load image. Just add the id and type.
                // You can use/create your own widget/method using [queryArtwork].
                leading: QueryArtworkWidget(
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<MyHomePage> {
  File _image = File("");
  final picker = ImagePicker();
  bool isLoaded = false;
  late var result;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> upload(File imageFile) async {
    // The upload logic remains the same
    // ...
  }

  Future<void> fetch() async {
    var response =
        await http.get(Uri.parse('http://192.168.0.106:5000/upload'));
    result = jsonDecode(response.body);
    print(result[0]['image']);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Select an image"),
          TextButton.icon(
            onPressed: () async => await getImage(),
            icon: Icon(Icons.upload_file),
            label: Text("Browse"),
          ),
          SizedBox(height: 20),
          TextButton.icon(
            onPressed: () => upload(_image),
            icon: Icon(Icons.upload_rounded),
            label: Text("Upload now"),
          ),
          isLoaded
              ? Image.network('http://192.168.0.106:5000/${result[0]['image']}')
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_social/pages/informer_persons_count.dart';
import 'package:quick_social/provider/informer_data_provider.dart';

class InformerCameraDescriptionPage extends StatefulWidget {
  const InformerCameraDescriptionPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _InformerCameraDescriptionPageState();
}

class _InformerCameraDescriptionPageState
    extends State<InformerCameraDescriptionPage> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final informerProfileProvider = Provider.of<InformerDataProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add description',
              style: TextStyle(color: Colors.black),
            ),
            TextButton(
              onPressed: () {
                if (_descriptionController.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Description cannot be empty!';
                  });
                  return;
                } else if (informerProfileProvider.imageurl == null) {
                  setState(() {
                    _errorMessage = 'Please select or capture an image.';
                  });
                  return;
                }
                setState(() {
                  _errorMessage = null;
                });

                informerProfileProvider
                    .setDescription(_descriptionController.text);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const InformerPersonsCount()));
              },
              child: Text(
                'Next',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.022),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          child: Column(
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Add a description',
                  errorText: _errorMessage,
                ),
              ),
              const SizedBox(height: 10),
              if (informerProfileProvider.imageurl != null)
                FutureBuilder<Size>(
                  future: _getImageSize(
                      File(informerProfileProvider.imageurl!.path)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      final size = snapshot.data!;
                      final aspectRatio = size.width / size.height;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double screenHeight =
                              MediaQuery.of(context).size.height;

                          return SizedBox(
                            height: aspectRatio == 0.5625
                                ? screenHeight * 0.75
                                : null,
                            child: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: Image.file(
                                File(informerProfileProvider.imageurl!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text('Image could not be loaded.');
                    }
                  },
                )
              else
                const Text('No image selected.'),
            ],
          ),
        ),
      ),
    );
  }

  Future<Size> _getImageSize(File imageFile) async {
    final completer = Completer<Size>();
    final image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:adoptme/components/custom_snackbar.dart';
import 'package:adoptme/components/custom_textFormField.dart';
import 'package:adoptme/components/my_appbar.dart';
import 'package:adoptme/components/my_button.dart';
import 'package:adoptme/logic/post_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String? selectedValue;
  final List<String> _items = ['Dog', 'Cat', 'Bird', 'Fish', 'Other'];
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  PostLogic postLogic = PostLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Add Post',
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  final picker = ImagePicker();
  File? _image;
  String? imageUrl;
  bool _isUploading = false;

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  OutlineInputBorder outLine(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              _buildTextArea(),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: '+855 12345678',
                controller: _contactController,
                obscureText: false,
                validValue: 'Input your contact number',
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildCategory(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: showOptions,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: _image == null
                    ? const Text('No Image selected')
                    : Image.file(
                        _image!,
                      ),
              ),
              const SizedBox(height: 10),
              InkWell(
                child: const MyButton(textString: 'Post'),
                onTap: () async {
                  String? uid = user?.uid;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    // Prevent dialog dismissal on tap outside
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Loading'), // Dialog title
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              SpinKitChasingDots(
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: index.isEven
                                          ? const Color(0xffff1b7d)
                                          : const Color(0xff54e8f3),
                                    ),
                                  );
                                },
                              ),
                              // Loading indicator inside the dialog
                              const SizedBox(height: 16.0),
                              const Text('Posting...'),
                              // Loading message
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  try {
                    await postLogic.handlePostTap(
                      userId: uid!,
                      caption: _captionController.text,
                      contact: _contactController.text,
                      animalType: _typeAheadController.text,
                      image: _image,
                      onResult: (imageUrl) {
                        _captionController.text = '';
                        _contactController.text = '';
                        _typeAheadController.text = '';
                        setState(() {
                          _image = null;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      onReject: (error) {
                        // Handle the error
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    );
                  } catch (e) {
                    // Handle the error
                    Navigator.of(context).pop(); // Close the dialog
                  }
                  // Rest of your code
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        minLines: 6,
        maxLines: null,
        maxLength: 200,
        controller: _captionController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'Caption',
          enabledBorder: outLine(Theme.of(context).colorScheme.primary),
          focusedBorder: outLine(Theme.of(context).colorScheme.primary),
          errorBorder: outLine(Colors.red),
          focusedErrorBorder: outLine(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: () {
          _typeAheadController.clear();
          FocusScope.of(context).unfocus();
        },
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _typeAheadController,
            decoration: InputDecoration(
              labelText: 'Search Item',
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          itemBuilder: (context, suggestion) => ListTile(
            title: Text(suggestion),
          ),
          suggestionsCallback: (pattern) {
            final List<String> filteredItems = _items
                .where((item) =>
                    item.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
            return filteredItems;
          },
          transitionBuilder: (context, suggestionsBox, controller) =>
              suggestionsBox,
          onSuggestionSelected: (suggestion) {
            _typeAheadController.text = suggestion;
            print('Selected: $suggestion');
          },
          validator: (value) => value!.isEmpty ? 'Select animal type' : null,
          onSaved: (value) {
            selectedValue = value;
          },
        ),
      ),
    );
  }
}

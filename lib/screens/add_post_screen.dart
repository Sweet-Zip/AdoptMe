import 'dart:io';

import 'package:adoptme/components/custom_textFormField.dart';
import 'package:adoptme/components/my_appbar.dart';
import 'package:adoptme/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  minLines: 6,
                  maxLines: null,
                  maxLength: 200,
                  controller: _captionController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Caption',
                    enabledBorder:
                        outLine(Theme.of(context).colorScheme.primary),
                    focusedBorder:
                        outLine(Theme.of(context).colorScheme.primary),
                    errorBorder: outLine(Colors.red),
                    focusedErrorBorder:
                        outLine(Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: '+855 12345678',
                controller: _contactController,
                obscureText: false,
                validValue: 'Input your contact number',
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Padding(
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
                          .where((item) => item
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                      return filteredItems;
                    },
                    transitionBuilder: (context, suggestionsBox, controller) =>
                        suggestionsBox,
                    onSuggestionSelected: (suggestion) {
                      _typeAheadController.text = suggestion;
                      print('Selected: $suggestion');
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Select animal type' : null,
                    onSaved: (value) => selectedValue = value,
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: GestureDetector(
                  onTap: () {},
                  child: const MyButton(
                    textString: 'Post',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

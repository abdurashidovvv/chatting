import 'dart:io';

import 'package:chatting/presentation/bloc/user_data/image_upload/image_upload_bloc.dart';
import 'package:chatting/presentation/bloc/user_data/image_upload/image_upload_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddUserDataScreen extends StatefulWidget {
  const AddUserDataScreen({super.key});

  @override
  State<AddUserDataScreen> createState() => _AddUserDataState();
}

class _AddUserDataState extends State<AddUserDataScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                    // Rasmni yuklash jarayonini boshlang
                    BlocProvider.of<ImageUploadBloc>(context)
                        .add(UploadImageEvent(_image! as ImageSource));
                  }
                },
                child: _image != null
                    ? Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/apple_ic.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Surname',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

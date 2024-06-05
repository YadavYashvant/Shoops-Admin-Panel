import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _name;
  String? _price;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<String> _uploadImage() async {
    final ref = FirebaseStorage.instance.ref().child('items').child(_name!);
    await ref.putFile(_imageFile!);
    return await ref.getDownloadURL();
  }

  Future<void> _addItem() async {
    final imageUrl = await _uploadImage();
    await FirebaseFirestore.instance.collection('items').add({
      'name': _name,
      'price': _price,
      'imageurl': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            if (_imageFile != null)
              Image.file(_imageFile!),
            TextButton(
              child: Text('Pick Image'),
              onPressed: _pickImage,
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) => _name = value,
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              onSaved: (value) => _price = value,
            ),
            ElevatedButton(
              child: const Text('Add Item'),
              onPressed: () async {
                _name = _nameController.text;
                _price = _priceController.text;
                if (_name!.isNotEmpty && _price!.isNotEmpty && _imageFile != null) {
                  await _addItem();
                  _nameController.clear();
                  _priceController.clear();
                  setState(() {
                    _imageFile = null;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_coloured_buttons/gradient_coloured_buttons.dart';
import 'package:grocery_app_admin/components/primary_btn.dart';
import 'package:grocery_app_admin/utils/colors.dart';
import 'package:grocery_app_admin/utils/dimensions.dart';
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
        backgroundColor: Colors.grey[200],
        // backgroundColor: const Color.fromARGB(255, 106, 163, 30),
        centerTitle: true,
        title: Text('Grocery App Admin Panel', style: GoogleFonts.poppins(
          fontSize: getScreenWidth(context) * 0.04,
          fontWeight: FontWeight.w600,
        )),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: getScreenheight(context)*.4, // adjust as needed
                    width: getScreenWidth(context)*.95, // adjust as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (_imageFile != null)
                            Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          Center(
                            child: Text(
                              _imageFile == null ? 'Pick an image' : '',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 24),
                      ),
                      style: GoogleFonts.poppins(fontSize: 24),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(fontSize: 24),
                      ),
                      style: GoogleFonts.poppins(fontSize: 24),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                  ],

                ),

              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: "Add Item",
                /*textStyle: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
                gradientColors: [Colors.green, Colors.amber, Colors.redAccent],
                width: 200,
                height: 50,
                borderRadius: 30.0,*/
                // child: const Text('Add Item'),
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
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../component/function.dart';
import '../../component/theme.dart';
import '../../component/widget.dart';
import '../../firebase/firebase.dart';


class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var formKey = GlobalKey <FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String myName = "";
  String myPhone = "";
  String myAddress = "";
  String myImage = "";
  String dropdownvalue = 'شق الفاوى';
  var refAddress =  FirebaseFirestore.instance.collection("address").snapshots();
  List<String> items =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAddress = dropdownvalue;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    void validateAndSave()async
    {
      final FormState? form = formKey.currentState;
      if (form!.validate())
      {
        form.save();
        if (myImage.isNotEmpty)
          {
            addData(
              context: context,
              phone: myPhone,
              name: myName,
              image: myImage,
              address: myAddress,
              free: true
            );
          }
        else
          {
            showToast(context: context, msg: "أضف صورة من فضلك", color: Colors.red);
          }

      }
    }

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('بيانات توكتوكى',style:headingStyle(color: Colors.white, fontSize: 20) ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("user",).doc(getUserID()).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          nameController.text = snapshot.data?.data()?['name'];
                          myName = snapshot.data?.data()?['name'];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildTextFormFieldToReadOly(
                                obscureText: false,
                                controller: nameController,
                                text: "الأسم",
                                iconPre: Icons.person_add,
                          )
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text("يوجد خطأ");
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  Center(
                            child: Column(
                              children:   const [
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  //--------------------------------------------
                  buildTextFormField(
                      obscureText: false,
                      controller: phoneController,
                      textInputType: TextInputType.phone,
                      text: "أدخل رقم الهاتف",
                      iconPre: Icons.person_add,
                      validate: (value) {
                        if (value == null || value.isEmpty || value.length != 11) {
                          return "أدخل 11 رقم من فضلك";
                        }
                        if (!value.toString().startsWith('01')) {
                          return "من فضلك يجب الرقم يبدأ ب 01";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        myPhone = val;
                      }),
                  //--------------------------------------------
                  //-----------------------------------------------------------

                  SizedBox(
                    height: 80,
                    child: StreamBuilder(
                      stream: refAddress,
                      builder: (context, snapshot) {

                        if (snapshot.hasData) {
                          items.clear();
                          var len = snapshot.data!.docs[0].data().length;
                          for(int i=2;i<=len!;i++)
                          {
                            items.add(snapshot.data?.docs[0]['p'"$i"]);
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color:Colors.teal.shade300,//Colors.green.shade600,
                                border: Border.all(
                                    width: 3.0, color: Colors.indigo.shade700),
                                borderRadius: const BorderRadius.all(Radius.circular(
                                  15.0,
                                ) //
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      buildIcon(icon: Icons.house_outlined, color: Colors.black87),
                                      const SizedBox(width: 10,),
                                      buildText(text: "عنوانى", color: Colors.black87, fontSize: 20),
                                    ],
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                        color:Colors.white,
                                        border: Border.all(color: Colors.indigo, width:3),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const <BoxShadow>[]
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                        dropdownColor: Colors.teal.shade300,
                                        value: dropdownvalue,
                                        elevation: 0,

                                        icon: const Icon(Icons.keyboard_arrow_down,color: Colors.deepPurple,),
                                        items: items.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items,style: headingStyle(color: Colors.purple, fontSize: 16),),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownvalue = newValue!;
                                            myAddress = newValue!;
                                          });
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text("يوجد خطأ");
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  Center(
                            child: Column(
                              children:   const [
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),

                  //-----------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration:  BoxDecoration(
                        color: Colors.teal.shade400,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(15) //                 <--- border radius here
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("أضف صورة" ,style: TextStyle(fontSize: 20),),
                          ),
                          Expanded(
                            child: IconButton(onPressed: (){
                              imageFromCamera();
                            }, icon: const Icon(Icons.camera_alt,color: Colors.deepPurple,)),
                          ),
                          Expanded(
                            child: IconButton(onPressed: (){
                              imageFromGallery();
                            }, icon: const Icon(Icons.image,color: Colors.deepPurple,)),
                          ),

                        ],
                      ),
                    ),
                  ),
                  imageFile == null?Container():
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(
                      imageFile!,
                    ),
                  ),
                  //-----------------------------------------------------------
                  const SizedBox(height: 25,),
                  buildElevatedButton(
                    text: "تسجيل",
                    function: validateAndSave,
                      color: Colors.indigo,
                    icon: Icons.save_as_outlined
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  File? imageFile ;
  Uint8List? byte;
  String? image64;

  imageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery,
      maxHeight: 1000,maxWidth: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      byte = File(imageFile!.path).readAsBytesSync();
      image64 = base64Encode(byte!);
      myImage = image64!;
      //  images.add(image64!);

    }
  }

  imageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera,maxHeight: 350,maxWidth: 350,);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      byte = File(imageFile!.path).readAsBytesSync();
      image64 = base64Encode(byte!);
      myImage = image64!;
      //  images.add(image64!);

    }
  }
}

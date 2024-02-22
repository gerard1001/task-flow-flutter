import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/api/category_api.dart';
import 'package:task_flow_flutter/api/user_api.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/sign-up';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var log = Logger(
    printer: PrettyPrinter(),
  );

  List<ValueItem> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the widget initializes
  }

  Future<void> fetchCategories() async {
    try {
      final response = await CategoryApi.getCategories();

      log.f('******************************************************');
      log.t(response);
      log.f('******************************************************');

      if (response != null && response.statusCode == 200) {
        List<ValueItem> fetchedCategories =
            (response.data as List<dynamic>).map((category) {
          return ValueItem(
            label: category['name'],
            value: category['categoryId'],
          );
        }).toList();

        setState(() {
          categories = fetchedCategories;
        });
      } else {
        log.e('Invalid or unsuccessful response from the API.');
      }
    } catch (e) {
      log.e('Error fetching categories: $e');
    }
  }

  int activeStep = 0;
  int lowerBound = 0;
  int upperBound = 1;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final MultiSelectController categoriesController = MultiSelectController();

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        birthDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  File? pickedImage;

  Future pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      // final imageTemporary = File(pickedFile.path);
      setState(() {
        if (pickedFile != null) {
          pickedImage = File(pickedFile.path);
        }
      });
    } on PlatformException catch (e) {
      log.i(e);
    }
  }

  void showInSnackBar(String value, String status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            status == 'success' ? TaskFlowColors.teal : Colors.red[400],
        content: Text(
          value,
          style: TextStyle(color: TaskFlowColors.primaryLight, fontSize: 18),
        ),
      ),
    );
  }

  void submitFx() {
    if (_formKey.currentState!.validate()) {
      log.t({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'gender': genderController.text,
        'birthDate': birthDateController.text,
        'categories':
            categoriesController.selectedOptions.map((e) => e.value).toList(),
        'image': pickedImage,
      });
    }
  }

  Future registerUser() async {
    if (_formKey.currentState!.validate()) {
      final response = await UserApi.registerUser(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
        genderController.text,
        birthDateController.text,
        categoriesController.selectedOptions.map((e) => e.value).toList(),
        pickedImage!,
      );

      log.f('******************************************************');
      log.t(response);
      log.t(response?.data);
      log.t(response?.statusCode);
      log.f('******************************************************');

      if (response != null && response.statusCode == 201) {
        showInSnackBar(response.data['message'], 'success');
        log.t(response.data);
      } else {
        log.f(response?.data);
        showInSnackBar(response!.data['error'], 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Container(
        padding:
            const EdgeInsets.only(top: 80.0, left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset('assets/images/logo.png',
                    height: 80, width: 80),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Register To TaskFlow',
                style: TaskFlowStyles.largeBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Row(
                children: [
                  const Text(
                    'Already have an account?',
                    style: TaskFlowStyles.medium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // IconStepper(
                      //   stepColor: TaskFlowColors.brown,
                      //   activeStepColor: TaskFlowColors.teal,
                      //   icons: const [
                      //     Icon(Icons.face),
                      //     Icon(Icons.photo),
                      //   ],
                      //   activeStep: activeStep,
                      //   onStepReached: (index) {
                      //     setState(() {
                      //       activeStep = index;
                      //     });
                      //   },
                      // ),
                      // header(),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: activeStep == 0
                            ? primaryInfo(
                                firstNameController,
                                lastNameController,
                                emailController,
                                passwordController)
                            : secondaryInfo(
                                genderController,
                                selectDate,
                                birthDateController,
                                categoriesController,
                                categories,
                                pickImage,
                                pickedImage),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          activeStep == 0 ? Container() : previousButton(),
                          activeStep == upperBound
                              ? MaterialButton(
                                  onPressed: () {
                                    // context.go(TrialPage.routeName);
                                    // print(
                                    //     '******************************************************');
                                    // print(controller.selectedOptions);
                                    // print(
                                    //     '******************************************************');
                                    // log.t(categoriesController
                                    //     .selectedOptions.runtimeType);
                                    registerUser();
                                  },
                                  color: TaskFlowColors.teal,
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 15, bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text('SUBMIT',
                                      style: TextStyle(
                                        color: TaskFlowColors.primaryLight,
                                        fontSize: 24,
                                      )),
                                )
                              : nextButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TaskFlowColors.teal,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        color: TaskFlowColors.secondaryLight,
        icon: const Icon(
          Icons.arrow_forward_outlined,
          size: 32,
        ),
        onPressed: () {
          if (activeStep < upperBound) {
            setState(() {
              activeStep++;
            });
          }
        },
      ),
    );
  }

  Widget previousButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TaskFlowColors.teal,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        color: TaskFlowColors.secondaryLight,
        icon: const Icon(
          Icons.arrow_back_outlined,
          size: 32,
        ),
        onPressed: () {
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
      ),
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Preface';

      default:
        return 'Introduction';
    }
  }
}

Widget primaryInfo(firstNameController, lastNameController, emailController,
    passwordController) {
  return Column(
    children: [
      const SizedBox(height: 20),
      TextFormField(
        controller: firstNameController,
        decoration: InputDecoration(
          labelText: 'First name',
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 20.0, 10.0),
          labelStyle: TextStyle(
            fontSize: 24,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: lastNameController,
        decoration: InputDecoration(
          labelText: 'Last name',
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 20.0, 10.0),
          labelStyle: TextStyle(
            fontSize: 24,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 20.0, 10.0),
          labelStyle: TextStyle(
            fontSize: 24,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 20.0, 10.0),
          labelStyle: TextStyle(
            fontSize: 24,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget secondaryInfo(genderController, selectDate, birthDateController,
    categoriesController, categories, pickImage, pickedImage) {
  return Column(
    children: [
      const SizedBox(height: 20),
      TextFormField(
        controller: genderController,
        decoration: InputDecoration(
          labelText: 'Gender',
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 20.0, 10.0),
          labelStyle: TextStyle(
            fontSize: 24,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: birthDateController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 20.0, 10.0),
          labelText: 'Birth date',
          labelStyle: TextStyle(
            fontSize: 24,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_month_sharp),
        ),
        readOnly: true,
        onTap: () {
          selectDate();
        },
      ),
      const SizedBox(height: 20),
      MultiSelectDropDown(
        controller: categoriesController,
        onOptionSelected: (List<ValueItem> selectedOptions) {},
        options: categories,
        hint: 'Select categories',
        hintColor: TaskFlowColors.secondaryDark,
        hintStyle: TextStyle(
          fontSize: 24,
          color: TaskFlowColors.secondaryDark,
        ),
        selectionType: SelectionType.multi,
        borderRadius: 4,
        fieldBackgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        padding: const EdgeInsets.only(top: 4, left: 10, right: 4, bottom: 4),
        borderWidth: 1,
        borderColor: TaskFlowColors.secondaryDark,
        dropdownBackgroundColor: TaskFlowColors.secondaryLight,
        optionsBackgroundColor: TaskFlowColors.secondaryLight,
        chipConfig: ChipConfig(
          wrapType: WrapType.values[0],
          spacing: 3,
          padding: const EdgeInsets.all(4),
          autoScroll: true,
          labelPadding: const EdgeInsets.only(top: 3, left: 8),
          deleteIconColor: TaskFlowColors.secondaryDark,
          backgroundColor: TaskFlowColors.grey,
          radius: 6,
          labelStyle: TextStyle(
            color: TaskFlowColors.primaryDark,
            fontSize: 20,
          ),
        ),
        dropdownHeight: 250,
        optionTextStyle: const TextStyle(fontSize: 20),
        selectedOptionIcon: const Icon(Icons.check_circle),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  'Upload picture',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0, 10, 0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: TaskFlowColors.brown),
                              child: const Icon(
                                Icons.file_upload_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                          const Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.camera);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: TaskFlowColors.brown),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                          const Text(
                            'Take picture',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: TaskFlowColors.grey,
              ),
              child: pickedImage != null
                  ? Image.file(
                      pickedImage!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                    ),
            )
          ],
        ),
      )
    ],
  );
}

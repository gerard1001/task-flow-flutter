import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/api/category_api.dart';
import 'package:task_flow_flutter/api/user_api.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:task_flow_flutter/pages/get_started_page.dart';
import 'package:task_flow_flutter/pages/sign_in_page.dart';

List<String> genderList = <String>['male', 'female', 'other'];

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

  String? genderValue;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await CategoryApi.getCategories();

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
        log.w(response);
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
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: TaskFlowColors.teal,
                onPrimary: TaskFlowColors.primaryLight,
                onSurface: TaskFlowColors.secondaryDark,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: TaskFlowColors.teal,
                ),
              ),
            ),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        birthDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> setGender(selectedValue) async {
    // await genderValue;
    if (selectedValue != null) {
      setState(() {
        genderValue = selectedValue;
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

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value) || value.isEmpty
        ? 'Enter a valid email address'
        : null;
  }

  void submitFx() {
    if (_formKey.currentState!.validate()) {
      log.t({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'gender': genderValue,
        'birthDate': birthDateController.text,
        'categories':
            categoriesController.selectedOptions.map((e) => e.value).toList(),
        'image': pickedImage,
      });
    }
  }

  void redirectToLogin() {
    context.go(SignInPage.routeName);
  }

  Future registerUser() async {
    if (_formKey.currentState!.validate()) {
      final response = await UserApi.registerUser(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
        genderValue!,
        birthDateController.text,
        categoriesController.selectedOptions
            .map((e) => e.value.toString())
            .toList(),
        pickedImage,
      );

      if (response != null && response.statusCode == 201) {
        log.f(response);
        showInSnackBar(response.data['message'], 'success');
        redirectToLogin();
        setState(() {
          _formKey.currentState!.reset();
          pickedImage = null;
        });
      } else {
        showInSnackBar(response!.data['error'], 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      showBottomNavBar: false,
      popRouteName: GetStartedPage.routeName,
      child: Container(
        padding:
            const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 20),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset('assets/images/logo.png',
                    height: 80, width: 80),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Register To TaskFlow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TaskFlowColors.primaryDark,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Wrap(
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            context.go(SignInPage.routeName);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: TaskFlowColors.teal,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
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
                              passwordController,
                              validateEmail)
                          : secondaryInfo(
                              genderController,
                              selectDate,
                              birthDateController,
                              categoriesController,
                              genderValue,
                              categories,
                              pickImage,
                              pickedImage,
                              setGender,
                              genderList),
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
                                  // submitFx();
                                },
                                color: TaskFlowColors.teal,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 13, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text('SUBMIT',
                                    style: TextStyle(
                                      color: TaskFlowColors.primaryLight,
                                      fontSize: 18,
                                    )),
                              )
                            : nextButton(),
                      ],
                    ),
                  ],
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
      padding: const EdgeInsets.all(4),
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
      padding: const EdgeInsets.all(4),
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
            log.f(activeStep);
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
    passwordController, validateEmail) {
  return Column(
    children: [
      const SizedBox(height: 20),
      TextFormField(
        controller: firstNameController,
        validator: (String? value) {
          if (value != null && value.isEmpty) {
            return "Firstname can't be empty";
          }
          return null;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
          labelText: 'First name',
          labelStyle: TextStyle(
            fontSize: 18,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: lastNameController,
        validator: (String? value) {
          if (value != null && value.isEmpty) {
            return "Lastname can't be empty";
          }
          return null;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
          labelText: 'Last name',
          labelStyle: TextStyle(
            fontSize: 18,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: emailController,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
          labelText: 'Email',
          labelStyle: TextStyle(
            fontSize: 18,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: passwordController,
        validator: (String? value) {
          if (value != null && value.isEmpty) {
            return "Password can't be empty";
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
          labelText: 'Password',
          labelStyle: TextStyle(
            fontSize: 18,
            color: TaskFlowColors.secondaryDark,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget secondaryInfo(
    genderController,
    selectDate,
    birthDateController,
    categoriesController,
    genderValue,
    categories,
    pickImage,
    pickedImage,
    setGender,
    genderList) {
  return Column(
    children: [
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(
        value: genderValue,
        hint: Text(
          "Select gender",
          style: TextStyle(
              color: TaskFlowColors.secondaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        icon: Icon(Icons.arrow_drop_down, color: TaskFlowColors.primaryDark),
        dropdownColor: TaskFlowColors.secondaryLight,
        style: TextStyle(color: TaskFlowColors.primaryDark, fontSize: 18),
        borderRadius: BorderRadius.circular(1),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                BorderSide(color: TaskFlowColors.secondaryDark, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                BorderSide(color: TaskFlowColors.secondaryDark, width: 1),
          ),
        ),
        isExpanded: false,
        onChanged: (String? value) {
          setGender(value);
        },
        items: genderList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? 'Gender is required' : null,
      ),
      const SizedBox(height: 20),
      // TextFormField(
      //   controller: genderController,
      //   decoration: InputDecoration(
      //     contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
      //     labelText: 'Gender',
      //     labelStyle: TextStyle(
      //       fontSize: 18,
      //       color: TaskFlowColors.secondaryDark,
      //     ),
      //     border: const OutlineInputBorder(),
      //   ),
      // ),
      // const SizedBox(height: 20),
      TextFormField(
        controller: birthDateController,
        validator: (String? value) {
          if (value != null && value.isEmpty) {
            return "Birth date can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 15.0),
          labelText: 'Birth date',
          labelStyle: TextStyle(
            fontSize: 18,
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
          fontSize: 18,
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
                Text(
                  'Upload picture',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TaskFlowColors.primaryDark),
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
                                size: 32,
                              ),
                            ),
                          ),
                          const Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 14,
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
                                size: 32,
                              ),
                            ),
                          ),
                          const Text(
                            'Take picture',
                            style: TextStyle(
                              fontSize: 14,
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
// import 'package:task_flow_flutter/pages/trials.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/sign-up';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int activeStep = 0;
  int lowerBound = 0;
  int upperBound = 1;

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  final TextEditingController dateController = TextEditingController();
  final MultiSelectController controller = MultiSelectController();

  var log = Logger(
    printer: PrettyPrinter(),
  );

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      log.i(e);
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child:
                  Image.asset('assets/images/logo.png', height: 80, width: 80),
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
                          ? primaryInfo()
                          : secondaryInfo(selectDate, dateController,
                              controller, pickImage, image),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        activeStep == 0 ? Container() : previousButton(),
                        activeStep == upperBound
                            ? MaterialButton(
                                onPressed: () {
                                  // context.replace(TrialPage.routeName);
                                  // print(
                                  //     '******************************************************');
                                  // print(controller.selectedOptions);
                                  // print(
                                  //     '******************************************************');
                                  log.t(controller.selectedOptions.runtimeType);
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

Widget primaryInfo() {
  return Column(
    children: [
      const SizedBox(height: 20),
      TextFormField(
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

Widget secondaryInfo(selectDate, dateController, controller, pickImage, image) {
  return Column(
    children: [
      const SizedBox(height: 20),
      TextFormField(
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
        controller: dateController,
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
        controller: controller,
        onOptionSelected: (List<ValueItem> selectedOptions) {},
        options: const <ValueItem>[
          ValueItem(label: 'Option 1', value: '1'),
          ValueItem(label: 'Option 2', value: '2'),
          ValueItem(label: 'Option 3', value: '3'),
          ValueItem(label: 'Option 4', value: '4'),
          ValueItem(label: 'Option 5', value: '5'),
          ValueItem(label: 'Option 6', value: '6'),
          ValueItem(label: 'Option 7', value: '7'),
          ValueItem(label: 'Option 8', value: '8'),
          ValueItem(label: 'Option 9', value: '9'),
          ValueItem(label: 'Option 10', value: '10'),
          ValueItem(label: 'Option 11', value: '11'),
          ValueItem(label: 'Option 12', value: '12'),
        ],
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
            )),
        dropdownHeight: 300,
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
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: TaskFlowColors.grey,
              ),
              child: image != null
                  ? Image.file(
                      image!,
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

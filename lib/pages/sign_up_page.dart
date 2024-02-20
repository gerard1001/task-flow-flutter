import 'package:flutter/material.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
import 'package:im_stepper/stepper.dart';

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
                          : secondaryInfo(selectDate, dateController),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        activeStep == 0 ? Container() : previousButton(),
                        activeStep == upperBound
                            ? MaterialButton(
                                onPressed: () {},
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

Widget secondaryInfo(selectDate, dateController) {
  return Column(
    children: [
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Gender',
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
    ],
  );
}

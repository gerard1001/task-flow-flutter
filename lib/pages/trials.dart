import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';

class TrialPage extends StatefulWidget {
  static const String routeName = '/trial';
  const TrialPage({super.key});

  @override
  State<TrialPage> createState() => _TrialPageState();
}

// Create a corresponding State class.
// This class holds data related to the form.
class _TrialPageState extends State<TrialPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<TrialPageState>.
  var log = Logger(
    printer: PrettyPrinter(),
  );

  final userBox = Hive.box('user');

  @override
  void initState() {
    super.initState();
  }

  void submitFx() {
    final abbaController = userBox.get('token', defaultValue: '');
    log.t(abbaController);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return PageWrapper(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: MaterialButton(
          onPressed: () {
            submitFx();
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:task_flow_flutter/components/page_wrapper.dart';
import 'package:task_flow_flutter/config/theme/theme_config.dart';
// import 'package:task_flow_flutter/config/theme/theme_config.dart';

class TrialPage extends StatefulWidget {
  static const String routeName = '/trial';
  const TrialPage({super.key});

  @override
  State<TrialPage> createState() => _TrialPageState();
}

class _TrialPageState extends State<TrialPage> {
  final MultiSelectController _controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('WRAP',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown(
              controller: _controller,
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
              hint: 'Select any',
              hintColor: TaskFlowColors.secondaryDark,
              hintStyle: TextStyle(
                fontSize: 20,
                color: TaskFlowColors.secondaryDark,
              ),
              selectionType: SelectionType.multi,
              borderRadius: 10,
              fieldBackgroundColor: Colors.grey[300]!,
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              borderWidth: 2,
              chipConfig: ChipConfig(
                  wrapType: WrapType.wrap,
                  padding: const EdgeInsets.all(4),
                  autoScroll: true,
                  labelPadding: const EdgeInsets.only(top: 3, left: 8),
                  deleteIconColor: TaskFlowColors.secondaryDark,
                  backgroundColor: TaskFlowColors.grey,
                  labelStyle: TextStyle(
                    color: TaskFlowColors.primaryDark,
                    fontSize: 20,
                  )),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 20),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            const SizedBox(
              height: 50,
            ),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clearAllSelection();
                  },
                  child: const Text('CLEAR'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    // debugPrint(_controller.getSelectedOptions.toString());
                  },
                  child: const Text('Get Selected Options'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.isDropdownOpen) {
                      _controller.hideDropdown();
                    } else {
                      _controller.showDropdown();
                    }
                  },
                  child: const Text('SHOW/HIDE DROPDOWN'),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    ));
  }
}

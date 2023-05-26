import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/models/annotations_model.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/shared/annotated_text_field.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_multi_date_picker.dart';
import 'package:atlast_mobile_app/shared/form_multiselect_dropdown.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
import 'package:atlast_mobile_app/shared/help_popup.dart';
import 'package:atlast_mobile_app/shared/hero_heading.dart';
import 'package:atlast_mobile_app/shared/layouts/full_page.dart';
import 'package:atlast_mobile_app/shared/layouts/single_child_scroll_bare.dart';
import 'package:atlast_mobile_app/shared/smart_autofill_text.dart';

class CreatorCampaignCatalyst extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;
  final Future<void> Function(
    String catalyst, {
    CatalystOutputTypes type,
  }) analyzeCatalyst;
  final void Function({
    List<int>? postTimestamps,
    int? startTimestamp,
    int? endTimestamp,
    List<SocialMediaPlatforms>? platforms,
    CatalystCampaignOutputTypes? campaignOutputType,
    int? maximumPosts,
  }) updateCatalyst;
  final CatalystBreakdown catalyst;
  final List<Annotation> annotations;

  const CreatorCampaignCatalyst({
    Key? key,
    required this.navKey,
    required this.analyzeCatalyst,
    required this.updateCatalyst,
    required this.catalyst,
    required this.annotations,
  }) : super(key: key);

  @override
  _CreatorCampaignCatalystState createState() =>
      _CreatorCampaignCatalystState();
}

class _CreatorCampaignCatalystState extends State<CreatorCampaignCatalyst> {
  // form variables
  final _formKey = GlobalKey<FormState>();
  String _catalystPrev = "";
  final AnnotatedTextController _catalystInputController =
      AnnotatedTextController();
  final FocusNode _catalystNode = FocusNode();
  List<SocialMediaPlatforms> _listOfSelectedPlatforms = [];
  bool _isListOfSelectedPlatformsAutoGenerated = false;
  bool _listOfSelectedPlatformsHasError = false;
  final GlobalKey _platformNode = GlobalKey(); // hack for non-text field inputs
  final TextEditingController _startDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final GlobalKey _dateNode = GlobalKey();
  bool _isDateAutoGenerated = false;
  final TextEditingController _endDateController = TextEditingController();
  bool _dateControllersHasError = false;

  // form advanced options
  bool _isAdvancedOptionsOpen = false;
  final TextEditingController _campaignSizeController = TextEditingController();

  void _toggleAdvancedOptionsOpen() {
    setState(() => _isAdvancedOptionsOpen = !_isAdvancedOptionsOpen);
  }

  void _handleBack() {
    widget.navKey.currentState!.pop();
  }

  void _handleContinue() {
    widget.navKey.currentState!.pushNamed("/campaign-2");
  }

  void _handleChangeCatalyst() async {
    if (_catalystPrev == _catalystInputController.text) return;
    _catalystPrev = _catalystInputController.text;

    await widget.analyzeCatalyst(
      _catalystInputController.text,
      type: CatalystOutputTypes.campaign,
    );

    setState(() {
      if (widget.catalyst.derivedStartTimestamp != null) {
        _startDate = DateTime.fromMillisecondsSinceEpoch(
            widget.catalyst.derivedStartTimestamp!);
        _startDateController.text =
            DateFormat('yyyy-MM-dd').format(_startDate!);
        _isDateAutoGenerated = true;
      }
      if (widget.catalyst.derivedEndTimestamp != null) {
        _endDate = DateTime.fromMillisecondsSinceEpoch(
            widget.catalyst.derivedEndTimestamp!);
        _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
        _isDateAutoGenerated = true;
      }
      if (_isListOfSelectedPlatformsAutoGenerated ||
          widget.catalyst.derivedPlatforms.isNotEmpty) {
        _listOfSelectedPlatforms = widget.catalyst.derivedPlatforms;
      }
      if (widget.catalyst.derivedPlatforms.isNotEmpty) {
        _isListOfSelectedPlatformsAutoGenerated = true;
      }
    });
    _catalystNode.requestFocus(); // hack to stop losing focus on setState()
  }

  void _handleChangeSelectedPlatforms(List<dynamic> newList) {
    widget.updateCatalyst(platforms: newList as List<SocialMediaPlatforms>);
    setState(() {
      _listOfSelectedPlatforms = newList;
      _isListOfSelectedPlatformsAutoGenerated = false;
    });
  }

  void _handleChangeDate(DateTimeRange dateRange) {
    widget.updateCatalyst(
      startTimestamp: dateRange.start.millisecondsSinceEpoch,
      endTimestamp: dateRange.end.millisecondsSinceEpoch,
    );
    setState(() {
      _startDateController.text =
          DateFormat('yyyy-MM-dd').format(dateRange.start);
      _startDate = dateRange.start;
      _endDateController.text = DateFormat('yyyy-MM-dd').format(dateRange.end);
      _startDate = dateRange.start;
      _isDateAutoGenerated = false;
    });
  }

  void _handleChangeCampaignOutputType(CatalystCampaignOutputTypes? newType) {
    CatalystCampaignOutputTypes newTypeFinal =
        newType ?? CatalystCampaignOutputTypes.daily;
    widget.updateCatalyst(campaignOutputType: newTypeFinal);
  }

  void _handleChangeCampaignSize() {
    if (_campaignSizeController.text != "") {
      widget.updateCatalyst(
        maximumPosts: int.parse(_campaignSizeController.text),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // listen for changes to autofill
    _catalystInputController.addListener(_handleChangeCatalyst);
    _campaignSizeController.addListener(_handleChangeCampaignSize);
  }

  Widget _buildForm() {
    _catalystInputController.annotations = widget.annotations;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What is your campaign about?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: HelpPopup(
              title: "Describe your campaign!",
              content:
                  "Using as much detail, describe your campaign (including dates, frequency, platforms, etc). We'll convert everything you type here into meaningful information for your campaign!",
              child: CustomFormTextField(
                focusNode: _catalystNode,
                controller: _catalystInputController,
                placeholderText:
                    "Ex. Instagram campaign from today until next Friday, promoting a discount of \$20 for a dozen roses and free delivery",
                vSize: 6,
                autocorrect: true,
                validator: (String? val) {
                  if (val == null ||
                      val == "" ||
                      widget.catalyst.derivedPrompt == "") {
                    return 'Enter a more detailed description of your campaign!';
                  }
                  return null;
                },
              ),
            ),
          ),
          const Text(
            "What account(s) do you want to post on?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              children: [
                CustomFormMultiselectDropdown(
                  listOfOptions: socialMediaPlatformsOptions,
                  listOfSelectedOptions: _listOfSelectedPlatforms,
                  setListOfSelectedOptions: _handleChangeSelectedPlatforms,
                  placeholder: "Select platform(s)",
                  hasError: _listOfSelectedPlatformsHasError,
                  validationMsg: "Select at least one platform!",
                  key: _platformNode,
                ),
                if (_isListOfSelectedPlatformsAutoGenerated)
                  const SmartAutofillText(),
              ],
            ),
          ),
          const Text(
            "What is the duration of your campaign?",
            style: AppText.bodyBold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomFormMultiDatePicker(
                    key: _dateNode,
                    startDateController: _startDateController,
                    endDateController: _endDateController,
                    currDateRange: _startDate != null && _endDate != null
                        ? DateTimeRange(start: _startDate!, end: _endDate!)
                        : null,
                    setDate: _handleChangeDate,
                    startDate: DateTime.now(),
                    hasError: _dateControllersHasError,
                    validationMsg: "Start and end date cannot be empty!",
                  ),
                ),
                if (_isDateAutoGenerated) const SmartAutofillText()
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              icon: Icon(
                _isAdvancedOptionsOpen
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: AppColors.black, //for icon color
              ),
              label: Text(
                _isAdvancedOptionsOpen
                    ? 'Hide advanced options'
                    : 'Show advanced options',
                style: const TextStyle(color: AppColors.black),
              ),
              onPressed: _toggleAdvancedOptionsOpen,
            ),
          ),
          Visibility(
            visible: _isAdvancedOptionsOpen,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What type of campaign is this?",
                    style: AppText.bodyBold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: DropdownButtonFormField(
                      items: catalystCampaignOutputOptions.entries
                          .map((e) => DropdownMenuItem(
                              value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: _handleChangeCampaignOutputType,
                      value: widget.catalyst.campaignOutputType,
                    ),
                  ),
                  const Text(
                    "Maximum number of posts in campaign?",
                    style: AppText.bodyBold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: CustomFormTextField(
                      keyboardType: TextInputType.number,
                      controller: _campaignSizeController,
                      validator: (String? val) {
                        if (val != null && val != "" && int.parse(val) <= 0) {
                          return 'Maximum number of posts must be greater than zero';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutFullPage(
      handleBack: _handleBack,
      appBarContent: const AppBarSteps(totalSteps: 3, currStep: 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroHeading(text: "Make a Campaign"),
          Expanded(
            child: SingleChildScrollBare(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildForm(),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              handlePressed: () {
                // FocusManager.instance.primaryFocus?.unfocus();
                _formKey.currentState!.save();
                // Validate returns true if the form is valid, or false otherwise.
                bool platformsErrorCheck = _listOfSelectedPlatforms.isEmpty;
                bool datesErrorCheck = _startDateController.text == "" ||
                    _endDateController.text == "";
                if (platformsErrorCheck != _listOfSelectedPlatformsHasError ||
                    datesErrorCheck != _dateControllersHasError) {
                  setState(() {
                    _listOfSelectedPlatformsHasError = platformsErrorCheck;
                    _dateControllersHasError = datesErrorCheck;
                  });
                }

                if (platformsErrorCheck) {
                  if (_platformNode.currentContext != null) {
                    Scrollable.ensureVisible(_platformNode.currentContext!);
                  }
                } else if (datesErrorCheck) {
                  if (_dateNode.currentContext != null) {
                    Scrollable.ensureVisible(_dateNode.currentContext!);
                  }
                }
                if (_formKey.currentState!.validate() &&
                    !platformsErrorCheck &&
                    !datesErrorCheck) {
                  _handleContinue();
                }
              },
              fillColor: AppColors.primary,
              text: 'Continue',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _catalystInputController.removeListener(_handleChangeCatalyst);
    _catalystInputController.dispose();
    _campaignSizeController.removeListener(_handleChangeCampaignSize);
    _campaignSizeController.dispose;
    _startDateController.dispose();
    _endDateController.dispose();
    _catalystNode.dispose();
    super.dispose();
  }
}

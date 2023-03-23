import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:atlast_mobile_app/configs/theme.dart';
import 'package:atlast_mobile_app/constants/catalyst_output_types.dart';
import 'package:atlast_mobile_app/constants/social_media_platforms.dart';
import 'package:atlast_mobile_app/models/catalyst_model.dart';
import 'package:atlast_mobile_app/shared/annotated_text_field.dart';
import 'package:atlast_mobile_app/shared/app_bar_steps.dart';
import 'package:atlast_mobile_app/shared/button.dart';
import 'package:atlast_mobile_app/shared/form_date_picker.dart';
import 'package:atlast_mobile_app/shared/form_multiselect_dropdown.dart';
import 'package:atlast_mobile_app/shared/form_text_field.dart';
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
    CatalystCampaignOutputTypes? campaignType,
    int? maximumPosts,
  }) updateCatalyst;
  final CatalystBreakdown catalyst;
  final List<DateAnnotation> dateAnnotations;
  final List<SocialMediaPlatformAnnotation> socialMediaPlatformAnnotations;

  const CreatorCampaignCatalyst({
    Key? key,
    required this.navKey,
    required this.analyzeCatalyst,
    required this.updateCatalyst,
    required this.catalyst,
    required this.dateAnnotations,
    required this.socialMediaPlatformAnnotations,
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
  List<SocialMediaPlatforms> _listOfSelectedPlatforms = [];
  bool _listOfSelectedPlatformsHasError = false;
  final TextEditingController _startDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _endDateController = TextEditingController();
  bool _dateControllersHasError = false;
  CatalystCampaignOutputTypes _campaignOutputType =
      CatalystCampaignOutputTypes.daily;

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
      }
      if (widget.catalyst.derivedEndTimestamp != null) {
        _endDate = DateTime.fromMillisecondsSinceEpoch(
            widget.catalyst.derivedEndTimestamp!);
        _endDateController.text = DateFormat('yyyy-MM-dd').format(_endDate!);
      }
      _listOfSelectedPlatforms = widget.catalyst.derivedPlatforms;
    });
  }

  void _handleChangeSelectedPlatforms(List<dynamic> newList) {
    widget.updateCatalyst(platforms: newList as List<SocialMediaPlatforms>);
    setState(() => _listOfSelectedPlatforms = newList);
  }

  void _handleChangeStartDate(DateTime date, String formattedDate) {
    widget.updateCatalyst(startTimestamp: date.millisecondsSinceEpoch);
    setState(() {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      _startDateController.text = formattedDate;
      _startDate = date;
      if (_endDate != null && _endDate!.isBefore(date)) {
        _endDateController.text = "";
        _endDate = null;
      }
    });
  }

  void _handleChangeEndDate(DateTime date, String formattedDate) {
    widget.updateCatalyst(endTimestamp: date.millisecondsSinceEpoch);
    setState(() {
      _endDateController.text = formattedDate;
      _endDate = date;
    });
  }

  void _handleChangeCampaignOutputType(CatalystCampaignOutputTypes? newType) {
    CatalystCampaignOutputTypes newTypeFinal =
        newType ?? CatalystCampaignOutputTypes.daily;
    setState(() => _campaignOutputType = newTypeFinal);
    widget.updateCatalyst(campaignType: newTypeFinal);
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
    List<Annotation> textAnnotations = [];
    textAnnotations.addAll(widget.dateAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));
    textAnnotations.addAll(widget.socialMediaPlatformAnnotations.map(
      (annot) => Annotation(
        range: annot.range,
        style: annot.style,
      ),
    ));
    _catalystInputController.annotations = textAnnotations;

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
            child: CustomFormTextField(
              controller: _catalystInputController,
              placeholderText:
                  "Ex. Instagram campaign approaching Valentines day, promoting a discount of \$20 for a dozen roses and free delivery",
              vSize: 6,
              validator: (String? val) {
                if (val == null ||
                    val == "" ||
                    widget.catalyst.derivedPrompt == "") {
                  return 'Enter a more detailed description of your campaign!';
                }
              },
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
                  validationMsg: "Must select at least one platform",
                ),
                const SmartAutofillText()
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
                Row(
                  children: [
                    Flexible(
                      child: CustomFormDatePicker(
                        controller: _startDateController,
                        setDate: _handleChangeStartDate,
                        placeholderText: "Start date",
                        currDate: _startDate,
                        startDate: DateTime.now(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          height: 1, width: 15, color: AppColors.black),
                    ),
                    Flexible(
                      child: CustomFormDatePicker(
                        controller: _endDateController,
                        setDate: _handleChangeEndDate,
                        placeholderText: "End date",
                        currDate: _endDate,
                        startDate: _startDate ?? DateTime.now(),
                      ),
                    ),
                  ],
                ),
                _dateControllersHasError
                    ? const Text(
                        "Start and end date cannot be empty!",
                        style: TextStyle(color: AppColors.error),
                      )
                    : const SizedBox(height: 0),
                const SmartAutofillText()
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
                      value: _campaignOutputType,
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
      appBarContent: const AppBarSteps(totalSteps: 4, currStep: 1),
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
                _formKey.currentState!.save();
                // Validate returns true if the form is valid, or false otherwise.
                bool platformsErrorCheck = _listOfSelectedPlatforms.length < 1;
                bool datesErrorCheck = _startDateController.text == "" ||
                    _endDateController.text == "";
                if (platformsErrorCheck != _listOfSelectedPlatformsHasError ||
                    datesErrorCheck != _dateControllersHasError) {
                  setState(() {
                    _listOfSelectedPlatformsHasError = platformsErrorCheck;
                    _dateControllersHasError = datesErrorCheck;
                  });
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
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:mwc/index.dart';

class TesterGuide extends StatefulWidget {
  const TesterGuide({super.key});

  @override
  State<TesterGuide> createState() => _TesterGuideState();
}

class _TesterGuideState extends State<TesterGuide> {
  @override
  Widget build(BuildContext context) {
    final List<String> instructions = [
      SetLocalizations.of(context).getText('required_field'),
      SetLocalizations.of(context).getText('start_instructions'),
      SetLocalizations.of(context).getText('enter_health_info'),
      SetLocalizations.of(context).getText('bluetooth_connection_instructions'),
      SetLocalizations.of(context).getText('measure_instructions'),
      SetLocalizations.of(context).getText('bluetooth_switch_instructions'),
      SetLocalizations.of(context).getText('measure_again_instructions'),
    ];
    final List<String> highlights = [
      SetLocalizations.of(context).getText('review_report_instructions'),
      SetLocalizations.of(context).getText('start_button_instructions'),
      SetLocalizations.of(context).getText('participant_info_entry_instructions'),
      SetLocalizations.of(context).getText('bluetooth_connection_info'),
      SetLocalizations.of(context).getText('measure_plantar_pressure_info'),
      SetLocalizations.of(context).getText('bluetooth_connection_info'),
      SetLocalizations.of(context).getText('bluetooth_switch_info'),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              child: Image(image: AssetImage('assets/images/Fisica.png')),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 80),
              child: Text(
                'Thank you for proceeding with the\nexperience of Fisica service.\nPlease experience the service\nby pressing the button below',
                style: AppFont.r16,
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: LodingButtonWidget(
                      onPressed: () async {
                        context.goNamed('TestTos');
                      },
                      text: 'Start',
                      options: LodingButtonOptions(
                        height: 56.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: AppColors.Black,
                        textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: AppColors.Black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ), // Version s
          ],
        ),
      ),
    );
  }

  List<TextSpan> _highlightText(String text, String highlight) {
    List<TextSpan> spans = [];
    int start = text.indexOf(highlight);
    if (start == -1) {
      spans.add(TextSpan(text: text));
      return spans;
    }
    if (start > 0) {
      spans.add(TextSpan(text: text.substring(0, start)));
    }
    spans.add(TextSpan(
      text: highlight,
      style: TextStyle(backgroundColor: const Color.fromARGB(91, 205, 255, 139)),
    ));
    spans.add(TextSpan(text: text.substring(start + highlight.length)));
    return spans;
  }
}

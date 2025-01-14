import 'package:flutter/material.dart';
import 'package:mwc/index.dart';

class Plantype extends StatefulWidget {
  final String name;
  final Map<String, bool> checkboxes;
  final Function(String) onCompleted;

  const Plantype({
    Key? key,
    required this.name,
    required this.checkboxes,
    required this.onCompleted,
  }) : super(key: key);

  @override
  _PlantypeState createState() => _PlantypeState();
}

class _PlantypeState extends State<Plantype> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 44.0, 0.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x25090F13),
              offset: Offset(0.0, 2.0),
            )
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.0,
                    height: 30.0,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 32.0),
                child: Text(widget.name, style: AppFont.b24.overrides(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start, // 자식들을 Row의 시작 부분에 정렬
                  children: [
                    Theme(
                      data: ThemeData(
                        checkboxTheme: CheckboxThemeData(
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        unselectedWidgetColor: AppColors.Gray200,
                      ),
                      child: Checkbox(
                        value: widget.checkboxes.values.every((v) => v == true),
                        onChanged: (bool? value) {
                          setState(() {
                            widget.checkboxes.keys.forEach((key) {
                              widget.checkboxes[key] = value!;
                            });
                          });
                        },
                        activeColor: AppColors.Black,
                        checkColor: AppColors.primaryBackground,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        '전체',
                        style: AppFont.s12.overrides(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: (100 / 30),
                children: widget.checkboxes.keys.map((String key) {
                  return Container(
                    height: 100,
                    child: Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            unselectedWidgetColor: AppColors.Gray200,
                          ),
                          child: Checkbox(
                            value: widget.checkboxes[key],
                            onChanged: (bool? value) {
                              setState(() {
                                widget.checkboxes[key] = value!;
                              });
                            },
                            activeColor: AppColors.Black,
                            checkColor: AppColors.primaryBackground,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                          child: Text(
                            key,
                            style: AppFont.s12.overrides(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56.0,
                      child: LodingButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onCompleted(widget.checkboxes.keys.where((String key) => widget.checkboxes[key]!).join(', '));
                        },
                        text: SetLocalizations.of(context).getText(
                          'tjsxor' /* 선택 */,
                        ),
                        options: LodingButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: AppColors.primary,
                          textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

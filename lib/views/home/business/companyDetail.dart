import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mwc/index.dart';
import 'package:mwc/views/home/business/employee.dart';

class CompanyDetaile extends StatefulWidget {
  final Map company;

  const CompanyDetaile({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyDetaile> createState() => _CompanyDetaileState();
}

class _CompanyDetaileState extends State<CompanyDetaile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  Map? company; // API 결과로 받아온 회사 정보

  @override
  void initState() {
    super.initState();
    getCompanies(); // 화면 시작 시 API 호출
  }

  // API에서 회사 정보를 가져오는 메서드
  Future<void> getCompanies() async {
    setState(() {
      isLoading = true;
    });

    String comid = widget.company['companyId'];
    final url = Uri.parse('http://${AppStateNotifier.instance.testurl}/demo/v1/btob/companies/$comid');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map jsonResponse = jsonDecode(response.body);
      setState(() {
        company = jsonResponse;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load company details');
    }
  }

  bool isOpen({
    required String weekdayOpeningTime,
    required String weekdayClosingTime,
    required String weekendOpeningTime,
    required String weekendClosingTime,
    required String holidayOpeningTime,
    required String holidayClosingTime,
  }) {
    // 현재 시간과 요일 가져오기
    DateTime now = DateTime.now();
    int weekday = now.weekday; // 1 (월요일) ~ 7 (일요일)

    // 현재 시간이 "HH:mm:ss" 형식의 시간을 넘지 않도록
    DateTime _parseTime(String timeString) {
      List<String> parts = timeString.split(':');
      return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    }

    DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

    // 평일, 주말, 공휴일 시간 파싱
    DateTime weekdayOpen = _parseTime(weekdayOpeningTime);
    DateTime weekdayClose = _parseTime(weekdayClosingTime);
    DateTime weekendOpen = _parseTime(weekendOpeningTime);
    DateTime weekendClose = _parseTime(weekendClosingTime);
    DateTime holidayOpen = _parseTime(holidayOpeningTime);
    DateTime holidayClose = _parseTime(holidayClosingTime);

    // 평일 (월요일~금요일): weekday 값이 1~5
    if (weekday >= 1 && weekday <= 5) {
      return currentTime.isAfter(weekdayOpen) && currentTime.isBefore(weekdayClose);
    }
    // 주말 (토요일): weekday 값이 6
    else if (weekday == 6) {
      return currentTime.isAfter(weekendOpen) && currentTime.isBefore(weekendClose);
    }
    // 공휴일 (일요일): weekday 값이 7
    else if (weekday == 7) {
      return currentTime.isAfter(holidayOpen) && currentTime.isBefore(holidayClose);
    }

    return false; // 기타 상황에서는 영업 중이 아님
  }

  String _formatTime(String time) {
    // 시간을 "HH:mm" 형식으로 변환
    List<String> parts = time.split(':');
    return '${parts[0]}:${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    // 데이터가 로드 중이거나, 로드가 완료되지 않았을 때 다른 화면을 표시
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 상태 표시
      );
    }

    // company 데이터가 null인 경우
    if (company == null) {
      return Scaffold(
        body: Center(child: Text('No company data available')), // 데이터가 없을 때
      );
    }

    // 회사 정보가 있을 때만 화면을 렌더링 (null 체크 제거)
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: AppColors.Black,
            iconTheme: IconThemeData(color: AppColors.primaryBackground // 뒤로가기 아이콘의 색상을 빨간색으로 설정
                ),
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(company!['companyName'], style: AppFont.b24.overrides(color: AppColors.primaryBackground)),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    company!['mainImageUrl'], // null 체크 필요 없음
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/default_image.png', fit: BoxFit.cover); // 에러 시 기본 이미지 표시
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8),
                    _buildCategoryListView(company!['companyCategories']), // null 체크 필요 없음
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.share),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.Gray100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: AppColors.Black,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                company!['companyAddress'], // null 체크 필요 없음
                                style: AppFont.s12.overrides(color: AppColors.Black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.Black,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                  isOpen(
                                    weekdayOpeningTime: company!['weekdayOpeningTime'],
                                    weekdayClosingTime: company!['weekdayClosingTime'],
                                    weekendOpeningTime: company!['weekendOpeningTime'],
                                    weekendClosingTime: company!['weekendClosingTime'],
                                    holidayOpeningTime: company!['holidayOpeningTime'],
                                    holidayClosingTime: company!['holidayClosingTime'],
                                  )
                                      ? 'Open'
                                      : 'Close',
                                  style: AppFont.s12.overrides(color: AppColors.Black)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Text(
                                // 평일, 주말, 공휴일 영업 시간 출력
                                'weekday ${_formatTime(company!['weekdayOpeningTime'])} - ${_formatTime(company!['weekdayClosingTime'])}\n'
                                'weekend ${_formatTime(company!['weekendOpeningTime'])} - ${_formatTime(company!['weekendClosingTime'])}\n'
                                'holiday ${_formatTime(company!['holidayOpeningTime'])} - ${_formatTime(company!['holidayClosingTime'])}',
                                style: AppFont.r16.overrides(color: AppColors.Gray700, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Text('Trainers', style: AppFont.s18.overrides(color: AppColors.Black)),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Total ${company!['employees'].length} people', style: TextStyle(color: Colors.pink)),
                      ],
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true, // 부모 스크롤 뷰와 충돌 방지
                      physics: NeverScrollableScrollPhysics(), // 부모 스크롤뷰로 스크롤 처리
                      itemCount: company!['employees'].length, // 직원 수
                      itemBuilder: (context, index) {
                        final employee = company!['employees'][index]; // 각 직원 정보

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            child: (Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(employee['mainPhotoUrl']), // 직원 사진
                                          backgroundColor: Colors.grey[300],
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(employee['employeeName'], style: AppFont.r16),
                                            Text(
                                              '${employee['employeePosition']} | ${employee['employeeInfo']}',
                                              style: AppFont.r16.overrides(fontSize: 12, color: AppColors.Gray700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // 상세 정보 페이지로 이동 (Navigator 사용)
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => employeeview(employees: employee),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 26,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                          color: AppColors.Black,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'View profile',
                                            style: AppFont.s12.overrides(color: AppColors.primaryBackground),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
                                  child: Row(
                                    children: [
                                      if (employee['photoUrl1'] != null) _buildImage(employee['photoUrl1']),
                                      if (employee['photoUrl2'] != null) _buildImage(employee['photoUrl2']),
                                      if (employee['photoUrl3'] != null) _buildImage(employee['photoUrl3']),
                                      if (employee['photoUrl4'] != null) _buildImage(employee['photoUrl4']),
                                      if (employee['photoUrl5'] != null) _buildImage(employee['photoUrl5']),
                                      if (employee['photoUrl6'] != null) _buildImage(employee['photoUrl6']),
                                      if (employee['photoUrl7'] != null) _buildImage(employee['photoUrl7']),
                                      if (employee['photoUrl8'] != null) _buildImage(employee['photoUrl8']),
                                      if (employee['photoUrl9'] != null) _buildImage(employee['photoUrl9']),
                                    ],
                                  ),
                                ),
                                Divider()
                              ],
                            )),
                            // title: Text(employee['employeeName'], style: TextStyle(fontWeight: FontWeight.bold)),
                            // subtitle: Text('${employee['employeePosition']} | ${employee['employeeInfo']}'),
                            // trailing: ElevatedButton(
                            //   onPressed: () {},
                            //   child: Text('프로필 보기'),
                            // ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

// Helper method to build image widget
  Widget _buildImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Image.network(
        imageUrl,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 120,
            height: 120,
            color: Colors.grey,
            child: Icon(Icons.error, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildCategoryListView(List<dynamic> categories) {
    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤

        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,

        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
            child: Container(
              height: 30,
              width: 97,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24)), color: AppColors.Gray100),
              child: Center(
                  child: Text(
                category['category'],
                style: AppFont.s12,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrainerTile(String name, String description) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, color: Colors.black),
      ),
      title: Text(name),
      subtitle: Text(description),
      trailing: ElevatedButton(
        onPressed: () {},
        child: Text('프로필 보기'),
      ),
    );
  }
}

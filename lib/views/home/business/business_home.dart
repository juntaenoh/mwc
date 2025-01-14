import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:mwc/main.dart';
import 'package:mwc/views/home/business/companyDetail.dart';
import 'package:provider/provider.dart';

class BusinessHome extends StatefulWidget {
  const BusinessHome({Key? key}) : super(key: key);

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  String categoryFilter = '';
  String sortFilter = '';

  bool isLoading = false;
  List companies = []; // API 결과로 받아온 회사 리스트

  @override
  void initState() {
    super.initState();
    fetchCompanies(); // 화면 시작 시 API 호출
  }

  // API에서 회사 리스트를 가져오는 메서드
  Future<void> fetchCompanies({String? query, String? category, String? sortBy}) async {
    setState(() {
      isLoading = true;
    });

    String urlcategory = category ?? '';
    String urlquery = query ?? '';
    String urlsortBy = sortBy ?? '';

    // API 요청 URL에 검색 필터를 추가
    final url = Uri.parse(
        'http://${AppStateNotifier.instance.testurl}/demo/v1/btob/companies?categories=$urlcategory&companyName=$urlquery&sortBy=$urlsortBy');

    final response = await http.get(url);
    loggerNoStack.t({'Name': 'fetchCompanies', 'url': url});

    if (response.statusCode == 200) {
      final List jsonResponse = jsonDecode(response.body);
      setState(() {
        companies = jsonResponse;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.statusCode);
    }
  }

  String _mapSortValueToLabel(String value) {
    switch (value) {
      case 'registrationDateAsc':
        return 'Latest'; // 'registrationDateAsc' -> 'Latest'
      case 'registrationDateDesc':
        return 'Oldest'; // 'registrationDateDesc' -> 'Oldest'
      case 'totalViewCountAsc':
        return 'Least Viewed'; // 'totalViewCountAsc' -> 'Least Viewed'
      case 'totalViewCountDesc':
        return 'Most Viewed'; // 'totalViewCountDesc' -> 'Most Viewed'
      default:
        return value; // 기본적으로 값 자체를 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          titleSpacing: 10,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: _buildAppHeader(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.Gray500, width: 1),
                  borderRadius: BorderRadius.circular(54),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    // 검색 필터 적용
                    fetchCompanies(query: value, category: categoryFilter, sortBy: sortFilter);
                  },
                  style: AppFont.r16.overrides(color: AppColors.Gray500),
                  decoration: InputDecoration(
                    hintText: 'Search company...',
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: AppColors.Gray500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),

              // 카테고리 필터
              Row(
                children: [
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.Gray500),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: DropdownButton<String>(
                      underline: SizedBox.shrink(), // 밑줄 제거
                      value: categoryFilter.isEmpty ? null : categoryFilter, // 선택한 값이 없으면 null로 설정
                      hint: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                        child: Text(
                          'Type', // 기본 힌트 텍스트를 'Type'으로 설정
                          style: AppFont.s12w, // 텍스트 스타일 적용
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          categoryFilter = newValue ?? ''; // 선택한 값이 없으면 빈 값으로 설정
                        });
                        fetchCompanies(query: searchController.text, category: categoryFilter, sortBy: sortFilter); // 값이 변경될 때 데이터 갱신
                      },
                      items: <String>['PILATES', 'GYM', 'HOSPITAL', 'ALL'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value == 'ALL' ? '' : value, // 'ALL'은 빈 값으로 처리
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                            child: Text(
                              value,
                              style: AppFont.s12w, // 텍스트 스타일 적용
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.Gray500),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: DropdownButton<String>(
                      value: sortFilter.isEmpty ? null : sortFilter,
                      hint: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                        child: Text(
                          'Sort', // 기본 힌트 텍스트를 'Sort'로 설정
                          style: AppFont.s12w,
                        ),
                      ),
                      underline: SizedBox.shrink(), // 밑줄 제거
                      onChanged: (String? newValue) {
                        setState(() {
                          sortFilter = newValue ?? '';
                        });
                        fetchCompanies(query: searchController.text, category: categoryFilter, sortBy: sortFilter);
                      },
                      items: <String>['registrationDateAsc', 'registrationDateDesc', 'totalViewCountAsc', 'totalViewCountDesc'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                            child: Text(
                              _mapSortValueToLabel(value), // 짧은 레이블로 표시
                              style: AppFont.s12w, // 텍스트 스타일 적용
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),

              SizedBox(height: 12),

              // 회사 리스트
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: companies.length,
                        itemBuilder: (BuildContext context, int index) {
                          final company = companies[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: GestureDetector(
                              onTap: () {
                                // 상세 정보 페이지로 이동 (Navigator 사용)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompanyDetaile(company: company),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                height: 160,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.Gray500),
                                  image: DecorationImage(
                                    image: NetworkImage(company['subImageUrl']), // URL 이미지
                                    fit: BoxFit.cover, // 이미지가 컨테이너를 덮도록 설정
                                  ),
                                  borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(company['companyName'], style: AppFont.b24w),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.place_outlined,
                                          color: AppColors.primaryBackground,
                                          size: 12,
                                        ),
                                        Text(company['companyAddress'], style: AppFont.s12w.overrides(color: AppColors.Gray100)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Businesses near me',
          style: AppFont.b24w,
        )
      ],
    );
  }
}

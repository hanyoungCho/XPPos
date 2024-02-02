const
  { Common Code }
  CCC_APP_TITLE     = 'XPartners POS System';
  CCC_UPDATE_URL    = 'http://xgolf.solbipos.kr';
  CCC_SOLBIPOS_URL  = 'http://www.solbipos.com';
  CCC_NHNKCP_URL    = 'https://www.kcp.co.kr';
  CCC_XGOLF_URL     = 'https://www.xgolf.com';
  CCC_XGOLF_API_URL = 'https://xgolfapi.xgolf.com';
  CCC_XTOUCH_URL    = 'https://www.xpartners.co.kr';
  CCC_WEATHER_URL   = 'https://www.openweathermap.org';
  CCC_XTOUCH_REGISTRY_KEY = 'SOFTWARE\XPartners\POSApp';
  CCC_GMAIL_LOG_PWD = '6DCEFAA0E75B9C0B58A4A715B33948A923A8FCE3FC'; //Use StrEncrypt('SOLBIPOS1544');

  { Content-Type }
  CCT_CONTENT_DELIMITER   = '&';
  CCT_CONTENT_NONE        = 0;
  CCT_CONTENT_URL_ENCODED = 1;
  CCT_CONTENT_JSON        = 2;
  CCT_CONTENT_XML         = 3;

  { XGOLF Member Search Value Type }
  CVT_XGOLF_QRCODE    = 'QR';
  CVT_XGOLF_HPNO      = 'HP';
  CVT_XGOLF_MEMBER_ID = 'ID';

  { Discount Division }
  CDD_FIXED_AMT   = 'A'; //정액
  CDD_PERCENT     = 'R'; //정율

  { Coupon Used Division }
  CCU_USED        = 'Y';
  CCU_DO_NOT_USED = 'N';
  CCU_USE_ALLOWED = 'R';

  { Window Messages }
  WM_USER         = $0400; //1024
  CWM_USER        = WM_USER + 1000;
  CWM_APP_HIDE    = CWM_USER + 1;
  CWM_COPY_DATA   = CWM_USER + 2;
  CWM_FINGERPRINT = CWM_USER + 3;

  { TID Default }
//  GCD_CREDIT_TID  = '1002189855';
//  GCD_PAYCO_TID   = GCD_CREDIT_TID;

  { System Default }
  GSD_AUTO_REBOOT_TIME      = '04:00';
  GSD_LAUNCHER_NAME         = 'XGLauncher';
  GSD_FIR_ENROLL_QUALITY    = 90;     //지문 저장 품질(30 < 100)
  GSD_FIR_IDENTIFY_QUALITY  = 90;     //지문 인식 품질(0 < 100)
  GSD_FIR_VERIFY_QUALITY    = 90;     //지문 비교 품질(0 < 100)
  GSD_FIR_SECURITY_LEVEL    = 9;      //지문 보안 레벨(1 < 10)
  GSD_FIR_DEFAULT_TIMEOUT   = 10000;  //지문 처리 타임아웃(MilliSecs.)
  GSD_TCP_DEFAULT_TIMEOUT   = 5000;   //TCP 소켓 통신 타임아웃(MilliSecs.)
  GSD_MYSQL_DEFAULT_TIMEOUT = 3600;   //MySQL DB 타임아웃(Secs.)

  { Back-Office Connection Default }
  GCD_BACKOFFICE_HOST = 'https://xtouch.xpartners.co.kr';
  GCD_NOTICE_URI = '/system/noticeList';

  { ASP Server Connection Default }
  GCD_API_SERVER_HOST = 'https://xtouch.xpartners.co.kr';

  { TestBed Server Connection Default }
  GCD_TEST_BACKOFFICE = 'https://test.xpartners.co.kr'; //'http://alm.wixnet.co.kr:81';
  GCD_TEST_API_SERVER = 'https://test.xpartners.co.kr'; //'http://alm.wixnet.co.kr:81';

  { 웰빙클럽 }
  GCD_WBCLUB_CODE            = '00001';
  GCD_WBCLUB_HOST            = 'https://partnerapi.wbcm.co.kr/openapi/';
  GCD_WBCLUB_APPROVAL_URI    = 'approval';
  GCD_WBCLUB_APPROVAL_SELECT_URI = 'approvalwithjongmok';
  GCD_WBCLUB_CANCEL_URI      = 'approvalcancel';
  GCD_WBCLUB_TEST_API_TOKEN  = 'NU9lcExJNTRzQ25jVGNNTEFhd09EZz09';
  GCD_WBCLUB_TEST_STORE_CODE = 'SBAA14070003';
  GCD_WBCLUB_TEST_MEMBER_NO  = '021688699816886998';

  { 리프레쉬클럽 }
  GCD_RFCLUB_CODE            = '00002';
  GCD_RFCLUB_HOST            = 'https://api.refreshclub.co.kr';
  GCD_RFCLUB_TEST_HOST       = 'http://v2dev.refreshclub.co.kr';
  GCD_RFCLUB_TEST_API_TOKEN  = 'ra3589nRmlh821bX';
  GCD_RFCLUB_TEST_STORE_CODE = '686';
  GCD_RFCLUB_TEST_MEMBER_NO  = '18472';

  { 리프레쉬골프 }
  GCD_RFGOLF_CODE            = '00003';
  GCD_RFGOLF_HOST            = 'https://api.refreshgolf.com/v1/checkin/kiosk';
  GCD_RFGOLF_TEST_HOST       = 'http://demoapi.refreshgolf.com/v1/checkin/kiosk';
  GCD_RFGOLF_TEST_API_TOKEN  = 'a20b65c2b29c1c70733b25808ae3fa846c880c31';
  GCD_RFGOLF_TEST_STORE_CODE = '17';
  GCD_RFGOLF_TEST_MEMBER_NO  = '69418';

  { 아이코젠 }
  GCD_IKOZEN_CODE            = '00004';
  GCD_IKOZEN_HOST            = '';
  GCD_IKCLUB_TEST_HOST       = '';
  GCD_IKOZEN_APPROVAL_URI    = '';
  GCD_IKOZEN_TEST_API_TOKEN  = '';
  GCD_IKOZEN_TEST_STORE_CODE = '';
  GCD_IKOZEN_TEST_MEMBER_NO  = '';

  { 더라운지멤버스 }
  GCD_TRMEMBERS_HOST         = 'https://api.theloungemembers.com/api/v2/';
  GCD_TRMEMBERS_TEST_HOST    = 'https://dev-api.theloungemembers.com/api/v2/';
  GCD_TRMEMBERS_APPROVAL_URI = 'use';
  GCD_TRMEMBERS_CANCEL_URI   = 'cancel';
  GCD_TRMEMBERS_INFO_URI     = 'info';

  { 스마틱스 }
  GCD_SMARTIX_CODE           = '00007';
  GCD_SMARTIX_HOST           = '';

  { 우편번호 검색 Host }
  GCD_ZIPCODE_HOST    = 'http://asp.solbipos.com/DaumPost/DaumPost.asp';

  { 타석입장 준비시간(분) }
  GCD_PREPARE_MIN     = 5;
  { 타석종료 예고 잔여시간(분) }
  GCD_GAMEOVER_ALARM_MIN = 5;
  { 슬라이드 이미지 전환 주기(초) }
  GCD_SLIDE_INTERVAL  = 5000;

  { Server Connection Default }
  CCD_MOBILE_AD_PORT  = 9000;
  CCD_TEEBOX_HOST     = '127.0.0.1';
  CCD_TEEBOX_API_PORT = 3308;
  CCD_TEEBOX_DB_PORT  = 3306;
  CCD_TEEBOX_DB       = 'xgolf';
  CCD_TEEBOX_USER     = 'xgolf';
  CCD_TEEBOX_PWD      = 'xgolf0105';
  CCD_ADMINCALL_PORT  = 6001;

  { POS 운영방식 구분(POS Type) }
  CPO_SALE_TEEBOX      = 0; //선불POS - 프런트(타석예약)
  CPO_SALE_CAFE        = 1; //선불POS - 카페, 홍보관(캐슬렉스)
  CPO_SALE_FOODCOURT   = 2; //선불POS - 구내식당(쇼골프)
  CPO_SALE_SCREEN_ROOM = 3; //후불POS - 룸 단위로 운영하는 스크린골프
  CPO_SALE_RESTRAUNT   = 4; //후불POS - 테이블 단위로 운영하는 요식업종
  CPO_SALE_LESSON_ROOM = 5; //선불POS - 레슨룸(파스텔골프클럽)

  { 연습장 형태 구분 }
  CGD_OUTDOOR         = 1;  //실외
  CGD_INDOOR          = 2;  //실내

  { 성별 구분 }
  CSD_SEX_ALL         = 0;  //공용
  CSD_SEX_MALE        = 1;  //남
  CSD_SEX_FEMALE      = 2;  //여

  { 구역 구분 }
  CZD_ZONE_ALL        = 'X';  //공용
  CZD_ZONE_MALE       = 'M';  //남
  CZD_ZONE_FEMALE     = 'F';  //여

  { 라커 위치 구분 }
  CLZ_LOCKER_TOP      = 'U';
  CLZ_LOCKER_MID      = 'K';
  CLZ_LOCKER_BOTTOM   = 'L';
  CLZ_LOCKER_A        = 'A';
  CLZ_LOCKER_B        = 'B';
  CLZ_LOCKER_ALL      = 'X';

  { 상품 카테고리 구분 }
  CAT_SALE_TEEBOX     = 1;  //타석
  CAT_SALE_LOCKER     = 2;  //라커
  CAT_SALE_GENERAL    = 3;  //일반

  { 상품 구분 }
  CPD_TEEBOX      = 'S';  //타석
  CPD_LOCKER      = 'L';  //라커
  CPD_KEEP_AMT    = 'K';  //(사물함)보증금
  CPD_GENERAL     = 'G';  //일반
//  CPL_DIV_LESSON_STUDIO = 'O'; //레슨
  CPD_LESSON      = 'O'; //레슨
  CPD_RESERVE     = 'V'; //예약
  CPD_FACILITY    = 'A';  //시설

  { 타석 상품 구분 }
  CTP_DAILY   = 'D';  //일일
  CTP_COUPON  = 'C';  //쿠폰
  CTP_TERM    = 'R';  //기간
  CTP_FREE    = 'F';  //무료
  CTP_TIME    = 'T';  //시간제(숏게임 등)
  CTP_CHANGE  = 'H';  //전환상품
  CTP_PUTTING = 'B';  //벙커,퍼팅
  CTP_LESSON  = 'E';  //레슨(연습장)
  CTP_LESSON_STUDIO = 'O'; //레슨 스튜디오
  CTP_LESSON_RESERVE = 'V'; //레슨 예약

  { 할인 구분 }
  CDC_COUPON          = 'C';  //쿠폰 할인
  CDC_CARD_IMMEDIATE  = 'P';  //카드사 즉시할인

  { 상품 상태 구분 }
  CPS_PRODUCT_INUSE   = 1;  //이용중
  CPS_PRODUCT_CLOSE   = 2;  //만료
  CPS_PRODUCT_RECESS  = 3;  //휴회
  CPS_PRODUCT_BEFORE  = 4;  //이용전
  CPS_PRODUCT_PAUSE   = 5;  //일시중지

  CPS_LOCKER_EMPTY    = 0;  //빈 라커
  CPS_LOCKER_INUSE    = 1;  //이용중
  CPS_LOCKER_MATURITY = 3;  //만기
  CPS_LOCKER_DISABLED = 9;  //사용불가

  { 글꼴 색상 구분 }
  CTC_EXPIRED   = $00808080; //만료
  CTC_IMMINENT  = $00544ED6; //만료 임박
  CTC_RECESS    = $000080FF; //휴회 //$00C08000

  { 타석 구역 구분 }
  CTZ_GDR             = 'A';  //GDR
  CTZ_SWING_ANALYZE   = 'B';  //스윙분석기
  CTZ_SWING_ANALYZE_2 = 'D';  //스윙분석기2
  CTZ_VIP_COUPLE      = 'C';  //VIP룸(커플)
  CTZ_GENERAL         = 'G';  //일반
  CTZ_LEFT_RIGHT      = 'L';  //좌우겸용
  CTZ_LEFT            = 'O';  //좌타석
  CTZ_LESSON          = 'R';  //레슨구역
  CTZ_SEMI_AUTO       = 'S';  //반자동
  CTZ_SHORT_GAME      = 'P';  //숏게임
  CTZ_TRACKMAN        = 'T';  //트랙맨
  CTZ_VIP             = 'V';  //VIP타석
  CTZ_VIP_SINGLE      = 'X';  //VIP룸(싱글)
  CTZ_SPECIAL         = 'W';  //S석
  CTZ_INDOOR          = 'I';  //실내타석
  CTZ_SCREEN_INDOOR   = 'E';  //스크린(실내)
  CTZ_SCREEN_OUTDOOR  = 'H';  //스크린(야외)

  { 타석 예약 회원 구분 }
  CTR_DAILY_MEMBER    = '1';  //일일타석권 예약
  CTR_TERM_MEMBER     = '2';  //기간회원 예약
  CTR_COUPON_MEMBER   = '3';  //쿠폰회원 예약

  { 부대시설 이용권 구분 }
  CAT_PARKING_TICKET  = 'PZ';
  CAT_SAUNA_TICKET    = 'SB';
  CAT_FITNESS_TICKET  = 'FH';

  { 부대시설 이용권 구분 }
  CAK_TEEUP_ERROR     = 1; //타석기 고장
  CAK_KIOSK_ERROR     = 2; //키오스크 고장
  CAK_KIOSK_PAPER_ERROR = 3; //키오스크 용지 없음

  { 빠른타석 표시 구분 }
  CQM_HORIZONTAL      = 0;
  CQM_VERTICAL        = 1;
  CQM_TOP_SIDE        = 2;

  { 냉/온풍기 상태 구분 }
  CAS_ON              = 1;
  CAS_OFF             = 0;

  { 지문 인식기 구분 }
  CFT_NITGEN          = 0;   //니트젠 햄스터 III
  CFT_UC              = 1;   //유니온커뮤니티 FOH02

  { 할인쿠폰 이용조건 }
  CCU_REPEAT          = '1'; //중복할인
  CCU_EXCLUSIVE       = '2'; //단독할인

  { 클라이언트 구분 }
  CCT_KIOSK           = 'K'; //키오스크
  CCT_MOBILE          = 'M'; //모바일
  CCT_POS             = 'P'; //POS
  CCT_TELE_RESERVED   = 'T'; //전화예약

  { 타석 레이아웃 정보 }
  CTL_TEEBOX_FLOORS   = 3;
  CTL_TEEBOX_COLS     = 24;
  CTL_TEEBOX_MAX      = (CTL_TEEBOX_FLOORS * CTL_TEEBOX_COLS);

  { 타석 상태 정보 }
  CTS_TEEBOX_NOTUSED  = -1; //사용불가
  CTS_TEEBOX_READY    = 0;  //대기중
  CTS_TEEBOX_USE      = 1;  //사용중
  CTS_TEEBOX_HOLD     = 3;  //임시예약(홀드)
  CTS_TEEBOX_RESERVED = 4;  //예약
  CTS_TEEBOX_STOP_ALL = 7;  //볼 회수(전 타석 사용 중지)
  CTS_TEEBOX_STOP     = 8;  //점검중 등록(개별 타석)
  CTS_TEEBOX_ERROR    = 9;  //타석기 기기 장애(개별 타석)

  { 타석기AD 서브 에러 코드 }
  CTS_TEEBOXAD_UNKNOWN  = 0; //기기고장
  CTS_TEEBOXAD_STOP_BALL= 1; //볼걸림
  CTS_TEEBOXAD_NO_BALL  = 2; //볼없음
  CTS_TEEBOXAD_NO_AUTO  = 3; //수동제어
  CTS_TEEBOXAD_MOTOR    = 4; //모터이상
  CTS_TEEBOXAD_COM      = 8; //통신이상
  CTS_TEEBOXAD_COM_ERROR= 9; //통신불량
  CTS_TEEBOXAD_CALL     = 10; //타석에서 CALL 호출
  CTS_TEEBOXAD_ERROR_11 = 11; //조작S/W 에러
  CTS_TEEBOXAD_ERROR_12 = 12; //조작S/W 에러
  CTS_TEEBOXAD_ERROR_13 = 13; //조작S/W 에러
  CTS_TEEBOXAD_ERROR_14 = 14; //조작S/W 에러
  CTS_TEEBOXAD_ERROR_15 = 15; //조작S/W 에러

  { 코드 그룹 }
  CCG_MENU_GROUP      = 'menu_group_code';
  CCG_FLOOR_ZONE      = 'floor_zone_code';
  CCG_LOCKER_ZONE     = 'locker_zone_code';
  CCG_TEEBOX_ZONE     = 'seat_zone_code';
  CCG_MEMBER_CUSTOMER = 'member_customer_code';
  CCG_MEMBER_GROUP    = 'member_group_code';

  { 타석 상태 구분 색상 }
  GCR_COLOR_VIP       = $0000CBFF;
  GCR_COLOR_READY     = $0045D10E; //$005FB459;
  GCR_COLOR_ERROR     = $00777777;
  GCR_COLOR_SOON      = $00544ED6;
  GCR_COLOR_PLAY      = $00000000;
  GCR_COLOR_WAIT      = $0000CBFF;
  GCR_COLOR_HOLD      = $008282AC;
  GCR_COLOR_HOLD_SELF = $00004080; //$000080FF;
  GCR_COLOR_BACK_LABEL= $00FFFFFF;
  GCR_COLOR_BACK_PANEL= $00595959; //$00FFDB99; //$00F4F9EA;

  { QR코드 구분 }
  CQT_HEAD_MEMBER     = '1'; //연습장 회원 QR코드 체계 변경(20220802): M-.. -> 1.. (10자리)
  CQT_HEAD_COUPON     = 'C-';
  CQT_HEAD_XGOLF      = 'X-';

  { 회원 인식코드 구분 }
  CMC_MEMBER_CODE     = 0; //회원코드
  CMC_MEMBER_QRCODE   = 1; //연습장 회원 QR코드
  CMC_XGOLF_QRCODE    = 2; //엑스골프 회원 QR코드
  CMC_WELFARE_CODE    = 3; //복지카드 일련번호
  CMC_EMPLOYEE_NAME   = 4; //직원명
  CMC_MEMBER_CARD_UID = 5; //멤버십카드 고유번호
  CMC_MEMBER_MSCARD   = 6; //(구)MS카드 회원번호

  { 데이터 모드 }
  CDM_VIEW_ONLY       = 0;
  CDM_NEW_DATA        = 1;
  CDM_EDIT_DATA       = 2;

  { 결제 수단 }
  CPM_CARD            = 'CARD';       //신용카드
  CPM_CASH            = 'CASH';       //현금
  CPM_PAYCO_CARD      = 'PAYCOCARD';  //페이코 신용카드
  CPM_PAYCO_COUPON    = 'PAYCOCPN';   //페이코 쿠폰
  CPM_PAYCO_POINT     = 'PAYCOPNT';   //페이코 포인트
  CPM_SALES_COUPON    = 'SALESCPN';   //할인 쿠폰
  CPM_FREE_COUPON     = 'FREECPN';    //무료 쿠폰
  CPM_POINT           = 'POINT';      //포인트
  CPM_WELFARE         = 'WELFARE';    //복지카드

  { 인터넷 승인 구분 }
  CIA_TERMINAL  = 0;
  CIA_INTERNET  = 1;

  { 거래 승인 구분 }
  CCA_CANCEL    = 0;  //취소거래
  CCA_APPROVAL  = 1;  //승인거래
  CCA_CANCELED  = 2;  //취소된 원승인거래

  { 매출금액 과세 구분(Sale Tax Type) }
  CTT_TAX       = 1;  //과세
  CTT_TAX_FREE  = 2;  //비과세

  { 라커 정렬 구분(LockerList Order) }
  CLO_FLOOR_ZONE_LOCKER = 1;
  CLO_FLOOR_LOCKER_ZONE = 2;

  { 주차관제 업체 구분 }
  CPV_HANIL     = 0;  //한일테크닉스: JMS골프클럽

  { 저장 대상 DB }
  CTD_LOCAL     = 0;
  CTD_SERVER    = 1;

  { 로컬 데이터 파일 }
  CDB_EXTENSION       = '.xdb';
  CDB_VERSION         = 'XGVersion' + CDB_EXTENSION;
  CDB_CONFIG          = 'XGConfig' + CDB_EXTENSION;
  CDB_TEEBOX          = 'XGTeeBox' + CDB_EXTENSION;
  CDB_TEEBOX_STATUS   = 'XGTeeBoxStatus' + CDB_EXTENSION;
  CDB_TEEBOX_RESERVED = 'XGTeeBoxStatus' + CDB_EXTENSION;
  CDB_PROD_TEEBOX     = 'XGProdTeeBox' + CDB_EXTENSION;
  CDB_PROD_GENERAL    = 'XGProdGeneral' + CDB_EXTENSION;
  CDB_PLU_CLASS       = 'XGPluClass' + CDB_EXTENSION;
  CDB_PLU_ITEMS       = 'XGPluItems' + CDB_EXTENSION;
  CDB_MEMBER          = 'XGMember' + CDB_EXTENSION;
  CDB_LOCKER          = 'XGLocker' + CDB_EXTENSION;
  CDB_PROD_LOCKER     = 'XGProdLocker' + CDB_EXTENSION;

	{ 플러그인 모듈(Plugin Module) }
  CPL_EXTENSION         = '.bpl';
  CPL_START             = 'XGDashboard' + CPL_EXTENSION;
  CPL_SUB_MONITOR       = 'XGSubMonitor' + CPL_EXTENSION;
  CPL_WEBVIEW           = 'XGWebView' + CPL_EXTENSION;

	{ 플러그인 커맨드(Plugin Command) }
  CPC_INIT              = 'CPC_INIT';
  CPC_CLOSE             = 'CPC_CLOSE';
  CPC_SET_FOREGROUND    = 'CPC_SET_FOREGROUND';
  CPC_TEEBOX_LAYOUT     = 'CPC_TEEBOX_LAYOUT';
  CPC_TEEBOX_STATUS     = 'CPC_TEEBOX_STATUS';
  CPC_TEEBOX_SELECT     = 'CPC_TEEBOX_SELECT';
  CPC_TEEBOX_GETDATA    = 'CPC_TEEBOX_GETDATA';
  CPC_TEEBOX_COUNTER    = 'CPC_TEEBOX_COUNTER';
  CPC_TEEBOX_SCOREBOARD = 'CPC_TEEBOX_SCOREBOARD';
  CPC_QUICK_SCOREBOARD  = 'CPC_QUICK_SCOREBOARD';
  CPC_PRIVACY_AGREEMENT = 'CPC_PRIVACY_AGREEMENT';
  CPC_REBOOT_SYSTEM     = 'CPC_REBOOT_SYSTEM';
  CPC_NOTICE_REFRESH    = 'CPC_NOTICE_REFRESH';
  CPC_AFFILIATE_REFRESH = 'CPC_AFFILIATE_REFRESH';
  CPC_RESTORE_WEB_POS   = 'CPC_RESTORE_WEB_POS';
  CPC_WEBCAM_PREVIEW    = 'CPC_WEBCAM_PREVIEW';
  CPC_FINGERPRINT_PREVIEW = 'CPC_FINGERPRINT_PREVIEW';
  CPC_WEATHER_REFRESH   = 'CPC_WEATHER_REFRESH';
  CPC_ACTIVE_TABLE      = 'CPC_ACTIVE_TABLE'; //주문 테이블 변경
  CPC_REFRESH_GROUP_TABLE = 'CPC_REFRESH_GROUP_TABLE';

  CPC_SET_SUBVIEW       = 'CPC_SET_SUBVIEW';
  CPC_APPLY_CONFIG      = 'CPC_APPLY_CONFIG';
  CPC_SALE_RESULT       = 'CPC_SALE_RESULT';
  CPC_CARD_CANCEL       = 'CPC_CARD_CANCEL';
  CPC_CASH_CANCEL       = 'CPC_CASH_CANCEL';
  CPC_PAYCO_CANCEL      = 'CPC_PAYCO_CANCEL';
  CPC_CLEAR_SALE        = 'CPC_CLEAR_SALE';
  CPC_CLEAR_TEEBOX_SELECTED = 'CPC_CLEAR_TEEBOX_SELECTED';

  CPC_SEARCH_ADDR       = 'CPC_SEARCH_ADDR';
  CPC_PHOTO_CAPTURED    = 'CPC_PHOTO_CAPTURED';

  CPC_SEND_RECEIPT_NO   = 'CPC_SEND_RECEIPT_NO';
  CPC_SEND_SCAN_DATA    = 'CPC_SEND_SCAN_DATA';
  CPC_SEND_QRCODE_XGOLF = 'CPC_SEND_QRCODE_XGOLF';
  CPC_SEND_QRCODE_MEMBER  = 'CPC_SEND_QRCODE_MEMBER';
  CPC_SEND_QRCODE_COUPON  = 'CPC_SEND_QRCODE_COUPON';
  CPC_SEND_QRCODE_CHECKIN = 'CPC_SEND_QRCODE_CHECKIN';
  CPC_SEND_MSCARD_MEMBER  = 'CPC_SEND_MSCARD_MEMBER';
  CPC_SEND_MEMBER_NO    = 'CPC_SEND_MEMBER_NO';
  CPC_SEND_MEMBER_CLEAR = 'CPC_SEND_MEMBER_CLEAR';
  CPC_SEND_RFID_DATA    = 'CPC_SEND_RFID_DATA';
  CPC_SEND_CHEQUE_NO    = 'CPC_SEND_CHEQUE_NO';
  CPC_SEND_COUPON_INFO  = 'CPC_SEND_COUPON_INFO';
  CPC_SEND_WELFARE_CODE = 'CPC_SEND_WELFARE_CODE';
  CPC_SEND_TEEBOX_PROD_CD = 'CPC_SEND_TEEBOX_PROD_CD';
  CPC_SEND_TEEBOX_PURCHASE_CD = 'CPC_SEND_TEEBOX_PURCHASE_CD';

  CPC_SELECT_PROD_ITEM  = 'CPC_SELECT_PROD_ITEM';
  CPC_CHANGE_PROD_SALE  = 'CPC_CHANGE_PROD_SALE';

  CPC_TEEBOX_HOLD       = 'CPC_TEEBOX_HOLD';
  CPC_TEEBOX_HOLD_CANCEL= 'CPC_TEEBOX_HOLD_CANCEL';
  CPC_TEEBOX_READY      = 'CPC_TEEBOX_READY';
  CPC_TEEBOX_READY_ALL  = 'CPC_TEEBOX_READY_ALL';
  CPC_TEEBOX_STOP       = 'CPC_TEEBOX_STOP';
  CPC_TEEBOX_STOP_ALL   = 'CPC_TEEBOX_STOP_ALL';
  CPC_TEEBOX_EMERGENCY  = 'CPC_TEEBOX_EMERGENCY';

	{ 플러그인 파라메터명(Plugin Param Name) }
  CPP_OWNER_ID          = 'CPP_OWNER_ID';
  CPP_POS_NAME          = 'CPP_POS_NAME';
  CPP_USER_NAME         = 'CPP_USER_NAME';
  CPP_FORM_TITLE        = 'CPP_FORM_TITLE';
  CPP_FORM_ALIGN        = 'CPP_FORM_ALIGN';
  CPP_DATA_MODE         = 'CPP_DATA_MODE';
  CPP_IDLE_MODE         = 'CPP_IDLE_MODE';
  CPP_EMERGENCY_MODE    = 'CPP_EMERGENCY_MODE';
  CPP_SCAN_MODE         = 'CPP_SCAN_MODE';
  CPP_USE_DOT_KEY       = 'CPP_USE_DOT_KEY';
  CPP_ACTIVE            = 'CPP_ACTIVE';
  CPP_NAVIGATE_URL      = 'CPP_NAVIGATE_URL';
  CPP_SHOW_NAVIGATOR    = 'CPP_SHOW_NAVIGATOR';
  CPP_SHOW_NO_MORE      = 'CPP_SHOW_NO_MORE';
  CPP_BACK_COLOR        = 'CPP_BACK_COLOR';
  CPP_FONT_SIZE_ADJUST  = 'CPP_FONT_SIZE_ADJUST';
  CPP_RECT_TOP          = 'CPP_RECT_TOP';
  CPP_RECT_LEFT         = 'CPP_RECT_LEFT';
  CPP_RECT_HEIGHT       = 'CPP_RECT_HEIGHT';
  CPP_RECT_WIDTH        = 'CPP_RECT_WIDTH';
  CPP_USE_POPUP         = 'CPP_USE_POPUP';

  CPP_MEMBER_NO         = 'CPP_MEMBER_NO';
  CPP_MEMBER_NAME       = 'CPP_MEMBER_NAME';
  CPP_HP_NO             = 'CPP_HP_NO';
  CPP_CAR_NO            = 'CPP_CAR_NO';
  CPP_BARCODE           = 'CPP_BARCODE';
  CPP_QRCODE            = 'CPP_QRCODE';
  CPP_MEMBER_CARD_UID   = 'CPP_MEMBER_CARD_UID';
  CPP_WELFARE_CODE      = 'CPP_WELFARE_CODE';
  CPP_PHOTO_BITMAP      = 'CPP_PHOTO_BITMAP';
  CPP_ADDR_ZIPCODE      = 'CPP_ADDR_ZIPCODE';
  CPP_ADDR_ADDRESS      = 'CPP_ADDR_ADDRESS';

  CPP_TABLE_INDEX       = 'CPP_TABLE_INDEX';
  CPP_TEEBOX_NO         = 'CPP_TEEBOX_NO';
  CPP_TEEBOX_INDEX      = 'CPP_TEEBOX_INDEX';
  CPP_TEEBOX_NAME       = 'CPP_TEEBOX_NAME';
  CPP_TEEBOX_STATUS     = 'CPP_TEEBOX_STATUS';
  CPP_TEEBOX_RESERVED   = 'CPP_TEEBOX_RESERVED';
  CPP_TEEBOX_SELECTED   = 'CPP_TEEBOX_SELECTED';
  CPP_TEEBOX_ENDTIME    = 'CPP_TEEBOX_ENDTIME';
  CPP_TEEBOX_PROD_CHANGE= 'CPP_TEEBOX_PROD_CHANGE'; //전환상품 선택 여부 (2020-03-10)
  CPP_FLOOR_CODE        = 'CPP_FLOOR_CODE';
  CPP_FLOOR_INDEX       = 'CPP_FLOOR_INDEX';
  CPP_QUICK_INDEX       = 'CPP_QUICK_INDEX';
  CPP_ZONE_CODE         = 'CPP_ZONE_CODE';

  CPP_PLAYING_COUNT     = 'CPP_PLAYING_COUNT';    //타석 이용 중인 타석수
  CPP_WAITING_COUNT     = 'CPP_WAITING_COUNT';    //타석 대기 중인 회원수
  CPP_READY_COUNT       = 'CPP_READY_COUNT';      //즉시 이용 가능한 타석수
  CPP_ASSIGN_MIN        = 'CPP_ASSIGN_MIN';
  CPP_REMAIN_MIN        = 'CPP_REMAIN_MIN';
  CPP_PREPARE_MIN       = 'CPP_PREPARE_MIN';
  CPP_PLAY_YN           = 'CPP_PLAY_YN';

  CPP_RECEIPT_NO        = 'CPP_RECEIPT_NO';     //영수증번호
  CPP_SALE_DIV          = 'CPP_SALE_DIV';
  CPP_LOCKER_SELECT     = 'CPP_LOCKER_SELECT';
  CPP_LOCKER_INFO       = 'CPP_LOCKER_INFO';
  CPP_PRODUCT_DIV       = 'CPP_PRODUCT_DIV';
  CPP_TEEBOX_PROD_DIV   = 'CPP_TEEBOX_PROD_DIV';
  CPP_PURCHASE_CD       = 'CPP_PURCHASE_CD';
  CPP_PRODUCT_CD        = 'CPP_PRODUCT_CD';
  CPP_PRODUCT_AMT       = 'CPP_PRODUCT_AMT';
  CPP_PRODUCT_QTY       = 'CPP_PRODUCT_QTY';
  CPP_PRODUCT_NAME      = 'CPP_PRODUCT_NAME';
  CPP_AVAIL_ZONE_CD     = 'CPP_AVAIL_ZONE_CD';  //상품 이용이 가능한 구역구분 코드들(','로 구분)
  CPP_SELL_AMT          = 'CPP_SELL_AMT';       //판매 금액
  CPP_CHARGE_AMT        = 'CPP_CHARGE_AMT';     //청구 금액(받을 금액)
  CPP_VAT_AMT           = 'CPP_VAT_AMT';        //부가세
  CPP_PAID_AMT          = 'CPP_PAID_AMT';       //결제 금액
  CPP_DISCOUNT_AMT      = 'CPP_DISCOUNT_AMT';   //할인 금액
  CPP_XGOLF_DC_AMT      = 'CPP_XGOLF_DC_AMT';   //엑스골프 멤버십 할인금액
  CPP_UNPAID_AMT        = 'CPP_UNPAID_AMT';     //미결제 금액
  CPP_CHANGE_AMT        = 'CPP_CHANGE_AMT';     //거스름돈
  CPP_CHEQUE_NO         = 'CPP_CHEQUE_NO';      //수표번홓
  CPP_CHEQUE_AMT        = 'CPP_CHEQUE_AMT';     //수표금액
  CPP_SALEMODE_YN       = 'CPP_SALEMODE_YN';    //판매모드 여부
  CPP_APPROVAL_YN       = 'CPP_APPROVAL_YN';    //결제 취소 또는 승인 여부
  CPP_APPROVAL_NO       = 'CPP_APPROVAL_NO';    //승인번호
  CPP_APPROVAL_DATE     = 'CPP_APPROVAL_DATE';  //결제 취소시 원거래일자
  CPP_APPROVAL_AMT      = 'CPP_APPROVAL_AMT';   //결제 취소시 원승인금액

  { 제휴사(웰빙클럽,리프레쉬클럽,리프레쉬골프,아이코젠 등) }
  CPP_AFFILIATE_YN        = 'CPP_AFFILIATE_YN'; //제휴연동여부
  CPP_AFFILIATE_CODE      = 'CPP_AFFILIATE_CODE'; //제휴사구분코드
  CPP_AFFILIATE_ITEM      = 'CPP_AFFILIATE_ITEM'; //제휴사항목코드
  CPP_AFFILIATE_DATA      = 'CPP_AFFILIATE_DATA'; //식별수단인식결과데이터
  CPP_AFFILIATE_MEMBER_CD = 'CPP_AFFILIATE_MEMBER_CD'; //회원번호
  CPP_AFFILIATE_EXEC_ID   = 'CPP_AFFILIATE_EXEC_ID'; //종목코드
  CPP_AFFILIATE_EXEC_TIME = 'CPP_AFFILIATE_EXEC_TIME'; //서버Unix타임

  { 미디어 파일 }
  CMF_WAV_SUCCESS      = 'success.wav';
  CMF_WAV_FAIL         = 'failure.wav';

{ EOF }

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
  CDD_FIXED_AMT   = 'A'; //����
  CDD_PERCENT     = 'R'; //����

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
  GSD_FIR_ENROLL_QUALITY    = 90;     //���� ���� ǰ��(30 < 100)
  GSD_FIR_IDENTIFY_QUALITY  = 90;     //���� �ν� ǰ��(0 < 100)
  GSD_FIR_VERIFY_QUALITY    = 90;     //���� �� ǰ��(0 < 100)
  GSD_FIR_SECURITY_LEVEL    = 9;      //���� ���� ����(1 < 10)
  GSD_FIR_DEFAULT_TIMEOUT   = 10000;  //���� ó�� Ÿ�Ӿƿ�(MilliSecs.)
  GSD_TCP_DEFAULT_TIMEOUT   = 5000;   //TCP ���� ��� Ÿ�Ӿƿ�(MilliSecs.)
  GSD_MYSQL_DEFAULT_TIMEOUT = 3600;   //MySQL DB Ÿ�Ӿƿ�(Secs.)

  { Back-Office Connection Default }
  GCD_BACKOFFICE_HOST = 'https://xtouch.xpartners.co.kr';
  GCD_NOTICE_URI = '/system/noticeList';

  { ASP Server Connection Default }
  GCD_API_SERVER_HOST = 'https://xtouch.xpartners.co.kr';

  { TestBed Server Connection Default }
  GCD_TEST_BACKOFFICE = 'https://test.xpartners.co.kr'; //'http://alm.wixnet.co.kr:81';
  GCD_TEST_API_SERVER = 'https://test.xpartners.co.kr'; //'http://alm.wixnet.co.kr:81';

  { ����Ŭ�� }
  GCD_WBCLUB_CODE            = '00001';
  GCD_WBCLUB_HOST            = 'https://partnerapi.wbcm.co.kr/openapi/';
  GCD_WBCLUB_APPROVAL_URI    = 'approval';
  GCD_WBCLUB_APPROVAL_SELECT_URI = 'approvalwithjongmok';
  GCD_WBCLUB_CANCEL_URI      = 'approvalcancel';
  GCD_WBCLUB_TEST_API_TOKEN  = 'NU9lcExJNTRzQ25jVGNNTEFhd09EZz09';
  GCD_WBCLUB_TEST_STORE_CODE = 'SBAA14070003';
  GCD_WBCLUB_TEST_MEMBER_NO  = '021688699816886998';

  { ��������Ŭ�� }
  GCD_RFCLUB_CODE            = '00002';
  GCD_RFCLUB_HOST            = 'https://api.refreshclub.co.kr';
  GCD_RFCLUB_TEST_HOST       = 'http://v2dev.refreshclub.co.kr';
  GCD_RFCLUB_TEST_API_TOKEN  = 'ra3589nRmlh821bX';
  GCD_RFCLUB_TEST_STORE_CODE = '686';
  GCD_RFCLUB_TEST_MEMBER_NO  = '18472';

  { ������������ }
  GCD_RFGOLF_CODE            = '00003';
  GCD_RFGOLF_HOST            = 'https://api.refreshgolf.com/v1/checkin/kiosk';
  GCD_RFGOLF_TEST_HOST       = 'http://demoapi.refreshgolf.com/v1/checkin/kiosk';
  GCD_RFGOLF_TEST_API_TOKEN  = 'a20b65c2b29c1c70733b25808ae3fa846c880c31';
  GCD_RFGOLF_TEST_STORE_CODE = '17';
  GCD_RFGOLF_TEST_MEMBER_NO  = '69418';

  { �������� }
  GCD_IKOZEN_CODE            = '00004';
  GCD_IKOZEN_HOST            = '';
  GCD_IKCLUB_TEST_HOST       = '';
  GCD_IKOZEN_APPROVAL_URI    = '';
  GCD_IKOZEN_TEST_API_TOKEN  = '';
  GCD_IKOZEN_TEST_STORE_CODE = '';
  GCD_IKOZEN_TEST_MEMBER_NO  = '';

  { ������������ }
  GCD_TRMEMBERS_HOST         = 'https://api.theloungemembers.com/api/v2/';
  GCD_TRMEMBERS_TEST_HOST    = 'https://dev-api.theloungemembers.com/api/v2/';
  GCD_TRMEMBERS_APPROVAL_URI = 'use';
  GCD_TRMEMBERS_CANCEL_URI   = 'cancel';
  GCD_TRMEMBERS_INFO_URI     = 'info';

  { ����ƽ�� }
  GCD_SMARTIX_CODE           = '00007';
  GCD_SMARTIX_HOST           = '';

  { ������ȣ �˻� Host }
  GCD_ZIPCODE_HOST    = 'http://asp.solbipos.com/DaumPost/DaumPost.asp';

  { Ÿ������ �غ�ð�(��) }
  GCD_PREPARE_MIN     = 5;
  { Ÿ������ ���� �ܿ��ð�(��) }
  GCD_GAMEOVER_ALARM_MIN = 5;
  { �����̵� �̹��� ��ȯ �ֱ�(��) }
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

  { POS ���� ����(POS Type) }
  CPO_SALE_TEEBOX      = 0; //����POS - ����Ʈ(Ÿ������)
  CPO_SALE_CAFE        = 1; //����POS - ī��, ȫ����(ĳ������)
  CPO_SALE_FOODCOURT   = 2; //����POS - �����Ĵ�(�����)
  CPO_SALE_SCREEN_ROOM = 3; //�ĺ�POS - �� ������ ��ϴ� ��ũ������
  CPO_SALE_RESTRAUNT   = 4; //�ĺ�POS - ���̺� ������ ��ϴ� ��ľ���
  CPO_SALE_LESSON_ROOM = 5; //����POS - ������(�Ľ��ڰ���Ŭ��)

  { ������ ���� ���� }
  CGD_OUTDOOR         = 1;  //�ǿ�
  CGD_INDOOR          = 2;  //�ǳ�

  { ���� ���� }
  CSD_SEX_ALL         = 0;  //����
  CSD_SEX_MALE        = 1;  //��
  CSD_SEX_FEMALE      = 2;  //��

  { ���� ���� }
  CZD_ZONE_ALL        = 'X';  //����
  CZD_ZONE_MALE       = 'M';  //��
  CZD_ZONE_FEMALE     = 'F';  //��

  { ��Ŀ ��ġ ���� }
  CLZ_LOCKER_TOP      = 'U';
  CLZ_LOCKER_MID      = 'K';
  CLZ_LOCKER_BOTTOM   = 'L';
  CLZ_LOCKER_A        = 'A';
  CLZ_LOCKER_B        = 'B';
  CLZ_LOCKER_ALL      = 'X';

  { ��ǰ ī�װ��� ���� }
  CAT_SALE_TEEBOX     = 1;  //Ÿ��
  CAT_SALE_LOCKER     = 2;  //��Ŀ
  CAT_SALE_GENERAL    = 3;  //�Ϲ�

  { ��ǰ ���� }
  CPD_TEEBOX      = 'S';  //Ÿ��
  CPD_LOCKER      = 'L';  //��Ŀ
  CPD_KEEP_AMT    = 'K';  //(�繰��)������
  CPD_GENERAL     = 'G';  //�Ϲ�
//  CPL_DIV_LESSON_STUDIO = 'O'; //����
  CPD_LESSON      = 'O'; //����
  CPD_RESERVE     = 'V'; //����
  CPD_FACILITY    = 'A';  //�ü�

  { Ÿ�� ��ǰ ���� }
  CTP_DAILY   = 'D';  //����
  CTP_COUPON  = 'C';  //����
  CTP_TERM    = 'R';  //�Ⱓ
  CTP_FREE    = 'F';  //����
  CTP_TIME    = 'T';  //�ð���(������ ��)
  CTP_CHANGE  = 'H';  //��ȯ��ǰ
  CTP_PUTTING = 'B';  //��Ŀ,����
  CTP_LESSON  = 'E';  //����(������)
  CTP_LESSON_STUDIO = 'O'; //���� ��Ʃ���
  CTP_LESSON_RESERVE = 'V'; //���� ����

  { ���� ���� }
  CDC_COUPON          = 'C';  //���� ����
  CDC_CARD_IMMEDIATE  = 'P';  //ī��� �������

  { ��ǰ ���� ���� }
  CPS_PRODUCT_INUSE   = 1;  //�̿���
  CPS_PRODUCT_CLOSE   = 2;  //����
  CPS_PRODUCT_RECESS  = 3;  //��ȸ
  CPS_PRODUCT_BEFORE  = 4;  //�̿���
  CPS_PRODUCT_PAUSE   = 5;  //�Ͻ�����

  CPS_LOCKER_EMPTY    = 0;  //�� ��Ŀ
  CPS_LOCKER_INUSE    = 1;  //�̿���
  CPS_LOCKER_MATURITY = 3;  //����
  CPS_LOCKER_DISABLED = 9;  //���Ұ�

  { �۲� ���� ���� }
  CTC_EXPIRED   = $00808080; //����
  CTC_IMMINENT  = $00544ED6; //���� �ӹ�
  CTC_RECESS    = $000080FF; //��ȸ //$00C08000

  { Ÿ�� ���� ���� }
  CTZ_GDR             = 'A';  //GDR
  CTZ_SWING_ANALYZE   = 'B';  //�����м���
  CTZ_SWING_ANALYZE_2 = 'D';  //�����м���2
  CTZ_VIP_COUPLE      = 'C';  //VIP��(Ŀ��)
  CTZ_GENERAL         = 'G';  //�Ϲ�
  CTZ_LEFT_RIGHT      = 'L';  //�¿���
  CTZ_LEFT            = 'O';  //��Ÿ��
  CTZ_LESSON          = 'R';  //��������
  CTZ_SEMI_AUTO       = 'S';  //���ڵ�
  CTZ_SHORT_GAME      = 'P';  //������
  CTZ_TRACKMAN        = 'T';  //Ʈ����
  CTZ_VIP             = 'V';  //VIPŸ��
  CTZ_VIP_SINGLE      = 'X';  //VIP��(�̱�)
  CTZ_SPECIAL         = 'W';  //S��
  CTZ_INDOOR          = 'I';  //�ǳ�Ÿ��
  CTZ_SCREEN_INDOOR   = 'E';  //��ũ��(�ǳ�)
  CTZ_SCREEN_OUTDOOR  = 'H';  //��ũ��(�߿�)

  { Ÿ�� ���� ȸ�� ���� }
  CTR_DAILY_MEMBER    = '1';  //����Ÿ���� ����
  CTR_TERM_MEMBER     = '2';  //�Ⱓȸ�� ����
  CTR_COUPON_MEMBER   = '3';  //����ȸ�� ����

  { �δ�ü� �̿�� ���� }
  CAT_PARKING_TICKET  = 'PZ';
  CAT_SAUNA_TICKET    = 'SB';
  CAT_FITNESS_TICKET  = 'FH';

  { �δ�ü� �̿�� ���� }
  CAK_TEEUP_ERROR     = 1; //Ÿ���� ����
  CAK_KIOSK_ERROR     = 2; //Ű����ũ ����
  CAK_KIOSK_PAPER_ERROR = 3; //Ű����ũ ���� ����

  { ����Ÿ�� ǥ�� ���� }
  CQM_HORIZONTAL      = 0;
  CQM_VERTICAL        = 1;
  CQM_TOP_SIDE        = 2;

  { ��/��ǳ�� ���� ���� }
  CAS_ON              = 1;
  CAS_OFF             = 0;

  { ���� �νı� ���� }
  CFT_NITGEN          = 0;   //��Ʈ�� �ܽ��� III
  CFT_UC              = 1;   //���Ͽ�Ŀ�´�Ƽ FOH02

  { �������� �̿����� }
  CCU_REPEAT          = '1'; //�ߺ�����
  CCU_EXCLUSIVE       = '2'; //�ܵ�����

  { Ŭ���̾�Ʈ ���� }
  CCT_KIOSK           = 'K'; //Ű����ũ
  CCT_MOBILE          = 'M'; //�����
  CCT_POS             = 'P'; //POS
  CCT_TELE_RESERVED   = 'T'; //��ȭ����

  { Ÿ�� ���̾ƿ� ���� }
  CTL_TEEBOX_FLOORS   = 3;
  CTL_TEEBOX_COLS     = 24;
  CTL_TEEBOX_MAX      = (CTL_TEEBOX_FLOORS * CTL_TEEBOX_COLS);

  { Ÿ�� ���� ���� }
  CTS_TEEBOX_NOTUSED  = -1; //���Ұ�
  CTS_TEEBOX_READY    = 0;  //�����
  CTS_TEEBOX_USE      = 1;  //�����
  CTS_TEEBOX_HOLD     = 3;  //�ӽÿ���(Ȧ��)
  CTS_TEEBOX_RESERVED = 4;  //����
  CTS_TEEBOX_STOP_ALL = 7;  //�� ȸ��(�� Ÿ�� ��� ����)
  CTS_TEEBOX_STOP     = 8;  //������ ���(���� Ÿ��)
  CTS_TEEBOX_ERROR    = 9;  //Ÿ���� ��� ���(���� Ÿ��)

  { Ÿ����AD ���� ���� �ڵ� }
  CTS_TEEBOXAD_UNKNOWN  = 0; //������
  CTS_TEEBOXAD_STOP_BALL= 1; //���ɸ�
  CTS_TEEBOXAD_NO_BALL  = 2; //������
  CTS_TEEBOXAD_NO_AUTO  = 3; //��������
  CTS_TEEBOXAD_MOTOR    = 4; //�����̻�
  CTS_TEEBOXAD_COM      = 8; //����̻�
  CTS_TEEBOXAD_COM_ERROR= 9; //��źҷ�
  CTS_TEEBOXAD_CALL     = 10; //Ÿ������ CALL ȣ��
  CTS_TEEBOXAD_ERROR_11 = 11; //����S/W ����
  CTS_TEEBOXAD_ERROR_12 = 12; //����S/W ����
  CTS_TEEBOXAD_ERROR_13 = 13; //����S/W ����
  CTS_TEEBOXAD_ERROR_14 = 14; //����S/W ����
  CTS_TEEBOXAD_ERROR_15 = 15; //����S/W ����

  { �ڵ� �׷� }
  CCG_MENU_GROUP      = 'menu_group_code';
  CCG_FLOOR_ZONE      = 'floor_zone_code';
  CCG_LOCKER_ZONE     = 'locker_zone_code';
  CCG_TEEBOX_ZONE     = 'seat_zone_code';
  CCG_MEMBER_CUSTOMER = 'member_customer_code';
  CCG_MEMBER_GROUP    = 'member_group_code';

  { Ÿ�� ���� ���� ���� }
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

  { QR�ڵ� ���� }
  CQT_HEAD_MEMBER     = '1'; //������ ȸ�� QR�ڵ� ü�� ����(20220802): M-.. -> 1.. (10�ڸ�)
  CQT_HEAD_COUPON     = 'C-';
  CQT_HEAD_XGOLF      = 'X-';

  { ȸ�� �ν��ڵ� ���� }
  CMC_MEMBER_CODE     = 0; //ȸ���ڵ�
  CMC_MEMBER_QRCODE   = 1; //������ ȸ�� QR�ڵ�
  CMC_XGOLF_QRCODE    = 2; //�������� ȸ�� QR�ڵ�
  CMC_WELFARE_CODE    = 3; //����ī�� �Ϸù�ȣ
  CMC_EMPLOYEE_NAME   = 4; //������
  CMC_MEMBER_CARD_UID = 5; //�����ī�� ������ȣ
  CMC_MEMBER_MSCARD   = 6; //(��)MSī�� ȸ����ȣ

  { ������ ��� }
  CDM_VIEW_ONLY       = 0;
  CDM_NEW_DATA        = 1;
  CDM_EDIT_DATA       = 2;

  { ���� ���� }
  CPM_CARD            = 'CARD';       //�ſ�ī��
  CPM_CASH            = 'CASH';       //����
  CPM_PAYCO_CARD      = 'PAYCOCARD';  //������ �ſ�ī��
  CPM_PAYCO_COUPON    = 'PAYCOCPN';   //������ ����
  CPM_PAYCO_POINT     = 'PAYCOPNT';   //������ ����Ʈ
  CPM_SALES_COUPON    = 'SALESCPN';   //���� ����
  CPM_FREE_COUPON     = 'FREECPN';    //���� ����
  CPM_POINT           = 'POINT';      //����Ʈ
  CPM_WELFARE         = 'WELFARE';    //����ī��

  { ���ͳ� ���� ���� }
  CIA_TERMINAL  = 0;
  CIA_INTERNET  = 1;

  { �ŷ� ���� ���� }
  CCA_CANCEL    = 0;  //��Ұŷ�
  CCA_APPROVAL  = 1;  //���ΰŷ�
  CCA_CANCELED  = 2;  //��ҵ� �����ΰŷ�

  { ����ݾ� ���� ����(Sale Tax Type) }
  CTT_TAX       = 1;  //����
  CTT_TAX_FREE  = 2;  //�����

  { ��Ŀ ���� ����(LockerList Order) }
  CLO_FLOOR_ZONE_LOCKER = 1;
  CLO_FLOOR_LOCKER_ZONE = 2;

  { �������� ��ü ���� }
  CPV_HANIL     = 0;  //������ũ�н�: JMS����Ŭ��

  { ���� ��� DB }
  CTD_LOCAL     = 0;
  CTD_SERVER    = 1;

  { ���� ������ ���� }
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

	{ �÷����� ���(Plugin Module) }
  CPL_EXTENSION         = '.bpl';
  CPL_START             = 'XGDashboard' + CPL_EXTENSION;
  CPL_SUB_MONITOR       = 'XGSubMonitor' + CPL_EXTENSION;
  CPL_WEBVIEW           = 'XGWebView' + CPL_EXTENSION;

	{ �÷����� Ŀ�ǵ�(Plugin Command) }
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
  CPC_ACTIVE_TABLE      = 'CPC_ACTIVE_TABLE'; //�ֹ� ���̺� ����
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

	{ �÷����� �Ķ���͸�(Plugin Param Name) }
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
  CPP_TEEBOX_PROD_CHANGE= 'CPP_TEEBOX_PROD_CHANGE'; //��ȯ��ǰ ���� ���� (2020-03-10)
  CPP_FLOOR_CODE        = 'CPP_FLOOR_CODE';
  CPP_FLOOR_INDEX       = 'CPP_FLOOR_INDEX';
  CPP_QUICK_INDEX       = 'CPP_QUICK_INDEX';
  CPP_ZONE_CODE         = 'CPP_ZONE_CODE';

  CPP_PLAYING_COUNT     = 'CPP_PLAYING_COUNT';    //Ÿ�� �̿� ���� Ÿ����
  CPP_WAITING_COUNT     = 'CPP_WAITING_COUNT';    //Ÿ�� ��� ���� ȸ����
  CPP_READY_COUNT       = 'CPP_READY_COUNT';      //��� �̿� ������ Ÿ����
  CPP_ASSIGN_MIN        = 'CPP_ASSIGN_MIN';
  CPP_REMAIN_MIN        = 'CPP_REMAIN_MIN';
  CPP_PREPARE_MIN       = 'CPP_PREPARE_MIN';
  CPP_PLAY_YN           = 'CPP_PLAY_YN';

  CPP_RECEIPT_NO        = 'CPP_RECEIPT_NO';     //��������ȣ
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
  CPP_AVAIL_ZONE_CD     = 'CPP_AVAIL_ZONE_CD';  //��ǰ �̿��� ������ �������� �ڵ��(','�� ����)
  CPP_SELL_AMT          = 'CPP_SELL_AMT';       //�Ǹ� �ݾ�
  CPP_CHARGE_AMT        = 'CPP_CHARGE_AMT';     //û�� �ݾ�(���� �ݾ�)
  CPP_VAT_AMT           = 'CPP_VAT_AMT';        //�ΰ���
  CPP_PAID_AMT          = 'CPP_PAID_AMT';       //���� �ݾ�
  CPP_DISCOUNT_AMT      = 'CPP_DISCOUNT_AMT';   //���� �ݾ�
  CPP_XGOLF_DC_AMT      = 'CPP_XGOLF_DC_AMT';   //�������� ����� ���αݾ�
  CPP_UNPAID_AMT        = 'CPP_UNPAID_AMT';     //�̰��� �ݾ�
  CPP_CHANGE_AMT        = 'CPP_CHANGE_AMT';     //�Ž�����
  CPP_CHEQUE_NO         = 'CPP_CHEQUE_NO';      //��ǥ���P
  CPP_CHEQUE_AMT        = 'CPP_CHEQUE_AMT';     //��ǥ�ݾ�
  CPP_SALEMODE_YN       = 'CPP_SALEMODE_YN';    //�ǸŸ�� ����
  CPP_APPROVAL_YN       = 'CPP_APPROVAL_YN';    //���� ��� �Ǵ� ���� ����
  CPP_APPROVAL_NO       = 'CPP_APPROVAL_NO';    //���ι�ȣ
  CPP_APPROVAL_DATE     = 'CPP_APPROVAL_DATE';  //���� ��ҽ� ���ŷ�����
  CPP_APPROVAL_AMT      = 'CPP_APPROVAL_AMT';   //���� ��ҽ� �����αݾ�

  { ���޻�(����Ŭ��,��������Ŭ��,������������,�������� ��) }
  CPP_AFFILIATE_YN        = 'CPP_AFFILIATE_YN'; //���޿�������
  CPP_AFFILIATE_CODE      = 'CPP_AFFILIATE_CODE'; //���޻籸���ڵ�
  CPP_AFFILIATE_ITEM      = 'CPP_AFFILIATE_ITEM'; //���޻��׸��ڵ�
  CPP_AFFILIATE_DATA      = 'CPP_AFFILIATE_DATA'; //�ĺ������νİ��������
  CPP_AFFILIATE_MEMBER_CD = 'CPP_AFFILIATE_MEMBER_CD'; //ȸ����ȣ
  CPP_AFFILIATE_EXEC_ID   = 'CPP_AFFILIATE_EXEC_ID'; //�����ڵ�
  CPP_AFFILIATE_EXEC_TIME = 'CPP_AFFILIATE_EXEC_TIME'; //����UnixŸ��

  { �̵�� ���� }
  CMF_WAV_SUCCESS      = 'success.wav';
  CMF_WAV_FAIL         = 'failure.wav';

{ EOF }
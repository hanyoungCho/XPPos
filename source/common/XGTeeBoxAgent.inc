const
  { 공통 }
  CCS_LAUNCHER_TITLE: string = 'XPartners AppLauncher for TeeBoxAgent';
  CCS_LAUNCHER_NAME: string = 'XGLauncher.exe';
  CCC_XTOUCH_API_URL: string = 'https://xtouch.xpartners.co.kr';
  CCC_ELOOM_API_URL: string = 'https://api.eloomgolf.com';

  CCN_TEST_PREPARE_SECONDS: Integer = 60 * 2;
  CCN_TEST_ASSIGN_SECONDS: Integer = 60 * 100;

  CCN_COLOR_NORMAL = $00002D00;
  CCN_COLOR_ADMIN  = $000000E6;

  CCS_DSAPP_NAME: string = 'DisplaySwitch.exe';

  { 윈도우 메시지 }
  CWM_DO_DOWNLOAD       = $0400 + 1000;
  CWM_DO_DELETE_LOG     = $0400 + 1001;
  CWM_DO_UPDATE_LOG     = $0400 + 1002;
  CWM_DO_REBOOT         = $0400 + 1003;
  CWM_DO_SHUTDOWN       = $0400 + 1004;
  CWM_DO_TEEBOX_IDLE    = $0400 + 1005;
  CWM_DO_TOPMOST        = $0400 + 1006;
  CWM_DO_READ_CONFIG    = $0400 + 1007;
  CWM_DO_WRITE_CONFIG   = $0400 + 1008;
  CWM_DO_ELOOM_CONFIG   = $0400 + 1009;
  CWM_SET_PREPARE_SECS  = $0400 + 1010;
  CWM_SET_REMAIN_SECS   = $0400 + 1011;
  CWM_REQ_TEEBOX_STATUS = $0400 + 1012;

  { 타석기 에이전트 제어 }
  CTA_CTRL_SHUTDOWN   = 0;
  CTA_CTRL_REBOOT     = 1;
  CTA_CTRL_UPDATE     = 2;
  CTA_CTRL_CLOSE      = 3;
  CTA_CTRL_LBP_ON     = 4;
  CTA_CTRL_LBP_OFF    = 5;
  CTA_CTRL_PLUG_ON    = 6;
  CTA_CTRL_PLUG_OFF   = 7;
  CTA_CTRL_WAKEONLAN  = 8;

  { 타석 동작 상태 & 타석기AD 브로드캐스팅 API }
  TBS_TEEBOX_IDLE       = 9000; //콘텐츠 재생
  TBS_TEEBOX_PREPARE    = 9001; //준비
  TBS_TEEBOX_START      = 9002; //시작
  TBS_TEEBOX_STOP       = 9003; //종료
  TBS_TEEBOX_STATUS     = 9004; //현재 타석상태 조회
  TBS_TEEBOX_AGENT      = 9005; //타석기PC 셧다운, 리부팅, 셀프 업데이트
  TBS_TEEBOX_CHANGE     = 9006; //이용 중인 타석의 이용시간 변경
  TBS_TEEBOX_GET_CONFIG = 9902; //타석별 설정 정보 수신
  TBS_TEEBOX_sET_CONFIG = 9903; //타석별 설정 정보 송신

  { 서버 서비스 공급자 }
  SSP_XPARTNERS = 0;  //엑스파트너스
  SSP_ELOOM     = 1;  //이룸

  { 골프 시뮬레이터 유형 }
  GST_KAKAO_VX = 0;  //카카오VX
  GST_GDR      = 1;  //골프존(구형)
  GST_GDR_PLUS = 2;  //골프존(신형)

  { 스마트플러그 유형 }
  SPT_TAPO    = 0;  //TAPO(TP-LINK)
  SPT_SONOFF  = 1;  //SONOFF
  SPT_HEJHOME = 2;  //MOKO(고퀄,하이홈)

  { 빔 프로젝터 유형 }
  LDP_HITACHI = 0;  //HITACHI
  LDP_EPSON   = 1;  //EPSON
  LDP_SONY    = 2;  //SONY
  LDP_SAMSUNG = 3;  //삼성
  LDP_LG      = 4;  //엘지

{ EOF }

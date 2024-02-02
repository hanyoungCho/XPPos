const
  CK_LICENSE_KEY = 'SLBPSK.CB1112022_ncysW5kq8RmQ';
  VG_LICENSE_KEY = '1791553139800639204523-73SOLBIPOS';

  { 타석기 시뮬레이터 윈도우 정보 }
  SIM_KAKAO_VX_WINDOW = 'TR';
  SIM_KAKAO_VX_CLASS  = 'UnityWndClass';

  { 타석 동작 상태 & 타석기AD 브로드캐스팅 API }
  TBS_TEEBOX_IDLE       = 9000; //콘텐츠 재생
  TBS_TEEBOX_READY      = 9001; //준비
  TBS_TEEBOX_START      = 9002; //시작
  TBS_TEEBOX_STOP       = 9003; //종료
  TBS_TEEBOX_STATUS     = 9004; //현재 타석상태 조회
  TBS_TEEBOX_AGENT      = 9005; //타석기PC 셧다운, 리부팅, 셀프 업데이트
  TBS_TEEBOX_CHANGE     = 9006; //이용 중인 타석의 이용시간 변경
  TBS_TEEBOX_GET_CONFIG = 9902; //타석별 설정 정보 수신
  TBS_TEEBOX_sET_CONFIG = 9903; //타석별 설정 정보 송신

  { 결과 구분 코드 }
  CRC_SUCCESS       = '0000';
  CRC_NO_SUCH_DATA  = '9999';
  CRC_YES           = 'Y';
  CRC_NO            = 'N';
  CRC_USING         = 'M';
  CRC_OFF           = 0;
  CRC_ON            = 1;

  { 서버 서비스 공급자 }
  SSP_XPARTNERS = 0;  //엑스파트너스
  SSP_ELOOM     = 1;  //이룸

  { 골프 시뮬레이터 유형 }
  GST_KAKAO_VX = 0;  //카카오VX
  GST_GDR      = 1;  //골프존(구형)
  GST_GDR_PLUS = 2;  //골프존(신형)
  GST_QED      = 3;  //큐이디

  { 스마트플러그 유형 }
  SPT_TAPO   = 0;  //TAPO(TP-LINK)
  SPT_SONOFF = 1;  //SONOFF
  SPT_MOKO   = 2;  //MOKO(고퀄,하이홈)

  { 빔 프로젝터 유형 }
  LDP_HITACHI = 0;  //HITACHI
  LDP_EPSON   = 1;  //EPSON
  LDP_SONY    = 2;  //SONY
  LDP_SAMSUNG = 3;  //삼성
  LDP_LG      = 4;  //엘지

{ EOF }

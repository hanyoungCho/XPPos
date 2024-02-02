const
  { 모바일AD API }
  GC_MAPI_TEEBOX_STATUS_ALL       = 1001; //층별 또는 전체 가동 상황
  GC_MAPI_TEEBOX_STATUS           = 1002; //타석별 가동 상황
  GC_MAPI_TEEBOX_RESERVE          = 1003; //예약 등록 요청
  GC_MAPI_TEEBOX_MEMBER           = 1004; //회원별 예약 내역
  GC_MAPI_TEEBOX_CANCEL           = 1005; //예약 취소 요청
  GC_MAPI_TEEBOX_HOLD             = 1006; //임시예약 등록/취소 요청

  { ELOOM 전용 }
  GC_MPAI_TEEBOX_STATUS_ELOOM     = 8001; //가동 상황 조회
  GC_MAPI_TEEBOX_CHANGE_ELOOM     = 8002; //예약 변경 요청
  GC_MAPI_TEEBOX_CLOSE_ELOOM      = 8003; //이용 종료 요청
  GC_MAPI_TEEBOX_MOVE_ELOOM       = 8004; //이동 등록 요청
  GC_MAPI_TEEBOX_ERROR_ELOOM      = 8005; //장애 등록/해제 요청
  GC_MAPI_TEEBOX_IMMEDIATE_ELOOM  = 8006; //예약 즉시 배정

  { 실내연습장 전용 }
  GC_MAPI_TEEBOX_CONTROL_INDOOR   = 8007; //시뮬레이터PC 제어(셧다운, 리부팅), 프로그램 업데이트 등
  GC_MAPI_DEVICE_CONTROL_INDOOR   = 8008; //장치 원격 제어

  { 장치 구분 }
  GC_MPAI_DEVICE_LBP              = 100; //빔 프로젝터

  { 장치 제어 구분 }
  GC_MPAI_CONTROL_LBP_POWER       = 101; //빔 프로젝터 전원 제어

  { 서버 정보 }
  GC_API_SERVER_HOST = 'https://api.eloomgolf.com';

{ EOF }
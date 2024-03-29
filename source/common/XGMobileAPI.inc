const
  { 모바일AD API Id }
  GC_MAPI_TEEBOX_STATUS_ALL       = 1001; //층별 또는 전체 타석 가동 상황
  GC_MAPI_TEEBOX_STATUS           = 1002; //타석별 타석 가동 상황
  GC_MAPI_TEEBOX_RESERVE          = 1003; //타석예약 요청
  GC_MAPI_TEEBOX_MEMBER           = 1004; //회원별 타석예약 내역
  GC_MAPI_TEEBOX_CANCEL           = 1005; //타석예약 취소 요청
  GC_MAPI_TEEBOX_HOLD             = 1006; //임시예약 등록/취소 요청(ELOOM)
  GC_MAPI_TEEBOX_NOSHOW_RESERVE   = 1007; //노쇼 예약(끼워 넣기) 등록 요청

  { ELOOM 전용 }
  GC_MPAI_TEEBOX_STATUS_ELOOM     = 8001; //타석 가동 상황 조회
  GC_MAPI_TEEBOX_CHANGE_ELOOM     = 8002; //타석예약 변경 요청
  GC_MAPI_TEEBOX_CLOSE_ELOOM      = 8003; //타석종료 요청
  GC_MAPI_TEEBOX_MOVE_ELOOM       = 8004; //타석이동 등록 요청
  GC_MAPI_TEEBOX_ERROR_ELOOM      = 8005; //타석장애 등록/해제 요청
  GC_MAPI_TEEBOX_IMMEDIATE_ELOOM  = 8006; //타석예약 즉시 배정

  { 실내연습장 전용 }
  GC_MAPI_TEEBOX_CONTROL_INDOOR   = 8007; //시뮬레이터PC 제어(셧다운, 리부팅), 프로그램 업데이트 등
  GC_MAPI_DEVICE_CONTROL_INDOOR   = 8008; //장치 원격 제어

  { 장치 구분 }
  GC_MPAI_DEVICE_LBP              = 100; //빔 프로젝터

  { 장치 제어 구분 }
  GC_MPAI_CONTROL_LBP_POWER       = 101; //빔 프로젝터 전원 제어

{ EOF }
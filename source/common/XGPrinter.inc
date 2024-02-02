resourcestring
  { 프린터 제어코드 }
  rptReceiptInit           = '{!}';   // 프린터 초기화
  rptLF                    = '{-}';   // 줄바꿈
  rptReceiptCharNormal     = '{N}';   // 일반 글자
  rptReceiptCharBold       = '{B}';   // 굵은 글자
  rptReceiptCharInverse    = '{I}';   // 역상 글자
  rptReceiptCharUnderline  = '{U}';   // 밑줄 글자
  rptReceiptAlignLeft      = '{L}';   // 왼쪽 정렬
  rptReceiptAlignCenter    = '{C}';   // 가운데 정렬
  rptReceiptAlignRight     = '{R}';   // 오른쪽 정렬
  rptReceiptSizeNormal     = '{S}';   // 보통 크기
  rptReceiptSizeWidth      = '{X}';   // 가로확대 크기
  rptReceiptSizeHeight     = '{Y}';   // 세로확대 크기
  rptReceiptSizeBoth       = '{Z}';   // 가로세로확대 크기
  rptReceiptSize3Times     = '{3}';   // 가로세로3배확대 크기
  rptReceiptSize4Times     = '{4}';   // 가로세로4배확대 크기
  rptReceiptCut            = '{/}';   // 용지커팅
  rptReceiptImage1         = '{*}';   // 그림 인쇄 1
  rptReceiptImage2         = '{@}';   // 그림 인쇄 2
  rptReceiptImage3         = '{**}';  // 그림 인쇄 3
  rptReceiptImage4         = '{@@}';  // 그림 인쇄 4
  rptReceiptCashDrawerOpen = '{O}';   // 금전함 열기
  rptReceiptSpacingNormal  = '{=}';   // 줄간격 보통
  rptReceiptSpacingNarrow  = '{&}';   // 줄간격 좁음
  rptReceiptSpacingWide    = '{\}';   // 줄간격 넓음
  rptBarCodeBegin128       = '{<}';   // 바코드 출력 시작 CODE128
  rptBarCodeBegin39        = '{[}';   // 바코드 출력 시작 CODE39
  rptBarCodeEnd            = '{>}';   // 바코드 출력 끝

//  rptReceiptFont12x24      = '{F0}';  // Character Font A (12x24)
//  rptReceiptFont9x17       = '{F1}';  // Character Font A (9x17)

  { 프린터 출력 명령 (영수증 별도 출력에서 사용함) }
  rptReceiptCharSaleDate   = '{D}';   // 판매일자
  rptReceiptCharPosNo      = '{P}';   // 포스번호
  rptReceiptCharPosName    = '{Q}';   // 포스명
  rptReceiptCharBillNo     = '{A}';   // 빌번호
  rptReceiptCharDateTime   = '{E}';   // 출력일시

{ EOF }

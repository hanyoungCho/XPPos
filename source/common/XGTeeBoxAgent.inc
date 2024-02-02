const
  { ���� }
  CCS_LAUNCHER_TITLE: string = 'XPartners AppLauncher for TeeBoxAgent';
  CCS_LAUNCHER_NAME: string = 'XGLauncher.exe';
  CCC_XTOUCH_API_URL: string = 'https://xtouch.xpartners.co.kr';
  CCC_ELOOM_API_URL: string = 'https://api.eloomgolf.com';

  CCN_TEST_PREPARE_SECONDS: Integer = 60 * 2;
  CCN_TEST_ASSIGN_SECONDS: Integer = 60 * 100;

  CCN_COLOR_NORMAL = $00002D00;
  CCN_COLOR_ADMIN  = $000000E6;

  CCS_DSAPP_NAME: string = 'DisplaySwitch.exe';

  { ������ �޽��� }
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

  { Ÿ���� ������Ʈ ���� }
  CTA_CTRL_SHUTDOWN   = 0;
  CTA_CTRL_REBOOT     = 1;
  CTA_CTRL_UPDATE     = 2;
  CTA_CTRL_CLOSE      = 3;
  CTA_CTRL_LBP_ON     = 4;
  CTA_CTRL_LBP_OFF    = 5;
  CTA_CTRL_PLUG_ON    = 6;
  CTA_CTRL_PLUG_OFF   = 7;
  CTA_CTRL_WAKEONLAN  = 8;

  { Ÿ�� ���� ���� & Ÿ����AD ��ε�ĳ���� API }
  TBS_TEEBOX_IDLE       = 9000; //������ ���
  TBS_TEEBOX_PREPARE    = 9001; //�غ�
  TBS_TEEBOX_START      = 9002; //����
  TBS_TEEBOX_STOP       = 9003; //����
  TBS_TEEBOX_STATUS     = 9004; //���� Ÿ������ ��ȸ
  TBS_TEEBOX_AGENT      = 9005; //Ÿ����PC �˴ٿ�, ������, ���� ������Ʈ
  TBS_TEEBOX_CHANGE     = 9006; //�̿� ���� Ÿ���� �̿�ð� ����
  TBS_TEEBOX_GET_CONFIG = 9902; //Ÿ���� ���� ���� ����
  TBS_TEEBOX_sET_CONFIG = 9903; //Ÿ���� ���� ���� �۽�

  { ���� ���� ������ }
  SSP_XPARTNERS = 0;  //������Ʈ�ʽ�
  SSP_ELOOM     = 1;  //�̷�

  { ���� �ùķ����� ���� }
  GST_KAKAO_VX = 0;  //īī��VX
  GST_GDR      = 1;  //������(����)
  GST_GDR_PLUS = 2;  //������(����)

  { ����Ʈ�÷��� ���� }
  SPT_TAPO    = 0;  //TAPO(TP-LINK)
  SPT_SONOFF  = 1;  //SONOFF
  SPT_HEJHOME = 2;  //MOKO(����,����Ȩ)

  { �� �������� ���� }
  LDP_HITACHI = 0;  //HITACHI
  LDP_EPSON   = 1;  //EPSON
  LDP_SONY    = 2;  //SONY
  LDP_SAMSUNG = 3;  //�Ｚ
  LDP_LG      = 4;  //����

{ EOF }
const
	{ Ư�� ���� }
  _SOH  = Chr($01);
  _STX  = Chr($02); //Start String
  _ETX  = Chr($03); //End String
  _BS   = Chr($08); //Back Space
  _TAB  = Chr($09); //Tab
  _LF   = Chr($0A); //Line Feed
  _CR   = Chr($0d); //Carrige Return
  _FS   = Chr($1C); //File Separator
  _GS   = Chr($1D); //Group Separator
  _RS   = Chr($1E); //Record Separator
  _US   = Chr($1F); //Unit Separator
  _CRLF = _CR + _LF;
  _LFCR = _LF + _CR;

  { ��� ���� �ڵ� }
  CRC_SUCCESS = '0000';
  CRC_SUCCESS_2 = 'P03A'; //������ ���� �̹� �Ϸ�Ǿ����� ������������ ���� �� ���û �ÿ� ���ŵǴ� ����ڵ�
  CRC_NO_SUCH_DATA = '9999';
  CRC_NO_DATA = '9991';
  CRC_YES = 'Y';
  CRC_NO = 'N';
  CRC_USING = 'M';

  CRC_OFF = 0;
  CRC_ON = 1;

{ EOF }
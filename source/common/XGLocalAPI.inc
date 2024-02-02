const
  { ���� API Id }
  GC_API_TERMINAL         = 1001; //�͹̳� ����
  GC_API_STORE            = 1002; //����� ����
  GC_API_ACCOUNT          = 1003; //����� ���� ����
  GC_API_CODE             = 1004; //���� �ڵ�
  GC_API_CONFIG           = 1005; //ȯ�漳��
  GC_API_TEEBOX           = 1006; //Ÿ�� ����
  GC_API_LOCKER           = 1007; //��Ŀ ����
  GC_API_TABLE            = 1008; //���̺�(��) ����
  GC_API_PROD_TEEBOX      = 1009; //Ÿ�� ��ǰ ����
  GC_API_PROD_LOCKER      = 1010; //��Ŀ ��ǰ ����
  GC_API_PROD_GENERAL     = 1011; //�Ϲ� ��ǰ ����
  GC_API_PLU_LIST         = 1012; //PLU  ���� ����
  GC_API_ADVERTISE        = 1013; //���� ����
  GC_API_MEMBER           = 1014; //ȸ�� ����
  GC_API_MEMBER_TEEBOX    = 1015; //ȸ���� Ÿ�� ������ǰ
  GC_API_MEMBER_LOCKER    = 1016; //ȸ���� ��Ŀ ������ǰ
  GC_API_LOCKER_STATUS    = 1017; //��Ŀ � ��Ȳ
  GC_API_SALE_RECEIPT     = 1018; //�ŷ� ����
  GC_API_CALENDAR         = 1019; //���� ����
  GC_API_PROD_TEEBOX_TIME = 1020; //Ÿ����ǰ ���ð�

  GC_API_DATASET_COUNT    = 20;

  GC_API_LIVE_TEEBOX_AD     = 2001; //Ÿ����AD ���̺� üũ
  GC_API_SEND_SMS           = 2002; //���ڸ޽���(SMS) ���� ��û
  GC_API_LOCKER_END         = 2003; //��Ŀ ����
  GC_API_SEND_MEMBER_QRCODE = 2004; //ȸ�� QR�ڵ� ���� ��û
  GC_API_FREE_PARKING_YN    = 2005; //���� ������ ���ο��� ����

  GC_RESULT_SUCCESS       = '0000';
  GC_RESULT_SERVER_DENIED = '9001';

  GC_API_METHOD_GET       = 'GET';
  GC_API_METHOD_POST      = 'POST';
  GC_API_METHOD_PUT       = 'PUT';

  { DBSync Flag }
  GC_DBSYNC_NEW           = 'N'; //�ű� ���: ȸ������ ���, Ÿ������ ���(K701)
  GC_DBSYNC_CHANGE        = 'U'; //����: ȸ������ ����, Ÿ������ ����(K703)
  GC_DBSYNC_ASSIGN        = 'I'; //����: Ÿ�� ����(K702)
  GC_DBSYNC_ASSIGN_END    = 'Q'; //����: Ÿ������ ����(K705)
  GC_DBSYNC_MOVE          = 'M'; //�̵�: Ÿ�� �̵�(K706)
  GC_DBSYNC_DELETE        = 'D'; //����
  GC_DBSYNC_NEED_DETAIL   = 'S'; //�󼼳��� ����ȭ ó�� �ʿ�
  GC_DBSYNC_APPROVE       = 'A'; //����
  GC_DBSYNC_CANCEL        = 'X'; //���: �ŷ����� ���, Ÿ������ ���(K704)
  GC_DBSYNC_CLEAR         = 'E'; //����: Ÿ�� ����, ��Ŀ ����(K711)
  GC_DBSYNC_SALE_CHANGE   = 'R'; //��ȯ��ǰ �ŷ�
  GC_DBSYNC_CASH_RECEIPT  = 'C'; //���ݿ����� ����
  GC_DBSYNC_COMPLETE      = 'Y'; //�Ϸ�

{ EOF }
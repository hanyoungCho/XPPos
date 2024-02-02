CREATE DEFINER=`xgolf`@`%` PROCEDURE `SP_INS_ERROR_LOG`(
/*****

	[Project]
		XPartners 골프연습장 POS 시스템
	[Object Name]
		SP_INS_ERROR_LOG
	[Description]
		DB 프로시저 실행 중 에러를 기록한다.
	[Parameters]
		=================================================================
		Parameter       Direction   Type		    Decription
        ---------------	-----------	--------------- ---------------------
	    p_proc_name		IN			varchar(50)		프로시저 명
	    p_error_code	IN			int(11)			에러 코드
	    p_error_text	IN			varchar(500)	에러 내용
		=================================================================
	[Usage]
		call xgolf.SP_SET_TEEBOX_ASSIGN_YN(1000, 'Y');
	[History]
		=================================================================
		Revision	Modified	Writer	Remark
		-----------	-----------	-------	---------------------------------
		1.0.0.0		2020.04.29	이선우	최초 작성
		=================================================================

	Copyrightⓒ(주)솔비포스 2020. All rights reserved.

*****/
	IN p_proc_name VARCHAR(50)
	, IN p_error_code INT
	, IN p_error_text VARCHAR(500)
)
BEGIN
	INSERT INTO error_log (
        log_datetime
		, proc_name
        , error_code
        , error_text
    )
    VALUES (
		left(date_format(Now(3), '%Y%m%d%H%i%s.%f'), 18)
		, p_proc_name
        , p_error_code
        , p_error_text
    );
END
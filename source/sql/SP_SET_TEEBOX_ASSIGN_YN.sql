CREATE DEFINER=`xgolf`@`%` PROCEDURE `SP_SET_TEEBOX_ASSIGN_YN`(
/*****

	[Project]
		XPartners 골프연습장 POS 시스템
	[Object Name]
		SP_SET_TEEBOX_ASSIGN_YN
	[Description]
		타석배정표 재발행 여부를 저장한다.
	[Parameters]
		=================================================================
		Parameter       Direction   Type		    Decription
        ---------------	-----------	--------------- ---------------------
	    p_use_seq		IN			int(11)			일련번호(PK)
	    p_assign_yn		IN			varchar(1)		재발행 여부(Y/N)
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
	IN p_use_seq int(11)
	, IN p_assign_yn varchar(1)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQLSTATE = RETURNED_SQLSTATE, @CODE = MYSQL_ERRNO, @TEXT = MESSAGE_TEXT;
        CALL SP_INS_ERROR_LOG('SP_SET_TEEBOX_ASSIGN_YN', @CODE, CONCAT('error=', @CODE, ' (', @SQLSTATE,  '): ', @TEXT));
	END;

	UPDATE seat_use
		SET assign_yn = p_assign_yn
	WHERE use_seq = p_use_seq;
END
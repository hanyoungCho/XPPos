CREATE DEFINER=`xgolf`@`%` PROCEDURE `SP_GET_TEEBOX_RESERVED`(
/*****

	[Project]
		XPartners 골프연습장 POS 시스템
	[Object Name]
		SP_GET_TEEBOX_RESERVED
	[Description]
		타석 예약 상항를 조회한다.
	[Parameters]
		=================================================================
		Parameter       Direction   Type		    Decription
        ---------------	-----------	--------------- ---------------------
	    p_store_cd		IN			varchar(5)		사업장 코드
		=================================================================
	[Usage]
		call xgolf.SP_GET_TEEBOX_RESERVED('A1001');
	[History]
		=================================================================
		Revision	Modified	Writer	Remark
		-----------	-----------	-------	---------------------------------
		1.0.0.0		2020.04.29	이선우	최초 작성
		=================================================================

	Copyrightⓒ(주)솔비포스 2020. All rights reserved.

*****/
	IN p_store_cd varchar(5)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1 @SQLSTATE = RETURNED_SQLSTATE, @CODE = MYSQL_ERRNO, @TEXT = MESSAGE_TEXT;
        CALL SP_INS_ERROR_LOG('SP_GET_TEEBOX_RESERVED', @CODE, CONCAT('error=', @CODE, ' (', @SQLSTATE,  '): ', @TEXT));
	END;

	SELECT
		t1.use_seq
		, t1.seat_no AS teebox_no
		, t2.seat_nm AS teebox_nm
		, t2.use_status
		, t2.floor_zone_code AS floor_cd
		, t2.seat_zone_code AS vip_yn
		, t2.use_yn
		, t1.reserve_root_div
		, t1.assign_yn
		, t1.product_seq AS product_cd
		, t1.product_nm AS product_nm
		, ifnull(t1.use_minute, 0) AS assign_min
		, ifnull(t1.use_balls, 0) AS assign_balls
		, ifnull(t1.delay_minute, 0) AS prepare_min
		, concat(t1.use_seq_date, lpad(t1.use_seq_no, 4, '0')) AS reserve_no
		, t1.reserve_div
		, t1.purchase_seq AS purchase_cd
		, t1.member_seq AS member_no
		, t1.member_nm
		, t1.memo
		, ifnull(date_format(t1.reserve_date, '%Y-%m-%d %H:%i:%s'), '') AS reserve_datetime
		, ifnull(date_format(date_add(ifnull(t1.reserve_date, now()), INTERVAL t1.delay_minute + FN_TEEBOX_DELAY_MINUTE(t1.store_cd,t1.seat_no) MINUTE), '%Y-%m-%d %H:%i:%s'), '') as start_datetime -- AD지연시간에서 무조건 더하기(2020.03.03)
		, ifnull(date_format(date_add(ifnull(t1.reserve_date, now()), INTERVAL t1.delay_minute + t1.use_minute + FN_TEEBOX_DELAY_MINUTE(t1.store_cd,t1.seat_no) MINUTE), '%Y-%m-%d %H:%i:%s'), '') AS end_datetime
		, ifnull(date_format(t1.reg_date, '%Y-%m-%d %H:%i:%s'), '') AS reg_datetime
	FROM seat_use t1, seat t2
	WHERE t1.store_cd = t2.store_cd
	AND t1.seat_no = t2.seat_no
	AND t1.store_cd = p_store_cd
	AND t1.use_status in ('1', '4')
	ORDER BY t1.use_seq;
END
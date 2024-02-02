CREATE DEFINER=`xgolf`@`%` PROCEDURE `SP_GET_TEEBOX_STATUS`(
/*****

	[Project]
		XPartners 골프연습장 POS 시스템
	[Object Name]
		SP_GET_TEEBOX_STATUS
	[Description]
		타석 가동 상항를 조회한다.
	[Parameters]
		=================================================================
		Parameter       Direction   Type		    Decription
        ---------------	-----------	--------------- ---------------------
	    p_store_cd		IN			varchar(5)		사업장 코드
		=================================================================
	[Usage]
		call xgolf.SP_GET_TEEBOX_STATUS('A1001');
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
        CALL SP_INS_ERROR_LOG('SP_GET_TEEBOX_STATUS', @CODE, CONCAT('error=', @CODE, ' (', @SQLSTATE,  '): ', @TEXT));
	END;

	SELECT
		t1.seat_no AS teebox_no
        , t1.seat_nm AS teebox_nm
		, CASE
			WHEN t1.use_status = '0' or t1.use_status = '1' THEN ifnull(t2.use_status, '0') -- 대기, 이용중일 때는 seat_use.use_status 참조
			ELSE t1.use_status -- seat 의 상태값 조회
		  END AS use_status
		, t1.heat_status
		, ifnull(
			CASE
				WHEN t2.use_status = '1' THEN t1.remain_minute
				ELSE timestampdiff(MINUTE, now(), date_add(t2.reserve_date, INTERVAL t2.delay_minute + t2.use_minute + fn_teebox_delay_minute(t1.store_cd, t1.seat_no) MINUTE))
			END, 0) AS remain_min
		, t1.remain_ball AS remain_balls
		, t2.use_seq AS reserve_no
		, t2.reserve_div
		, t2.product_seq AS product_cd
		, t2.product_nm
		, t2.member_seq AS member_no
		, t2.member_nm
		, t2.memo
		, t1.floor_zone_code AS floor_cd
		, if(t1.seat_zone_code = 'V', 'Y', 'N') AS vip_yn
		, t1.seat_zone_code AS zone_div
		, t1.use_yn
		, t1.mobile_view_yn
        , ifnull(date_format(t2.reserve_date, '%Y-%m-%d %H:%i:%s'), '') AS reserve_date
        , ifnull(date_format(
			CASE
				WHEN t2.use_status = '1' THEN t2.start_date
				ELSE date_add(t2.reserve_date, INTERVAL t2.delay_minute MINUTE)
			END, '%Y-%m-%d %H:%i:%s'), '') AS start_date
		, ifnull(date_format(
			CASE
				WHEN t2.use_status = '1' THEN date_add(now(), INTERVAL t1.remain_minute MINUTE)
				ELSE date_add(t2.reserve_date, INTERVAL t2.delay_minute + t2.use_minute + fn_teebox_delay_minute(t1.store_cd, t1.seat_no) MINUTE)
			END, '%Y-%m-%d %H:%i:%s'), '') AS end_date
        , ifnull(t2.delay_minute, 0) AS delay_minute
        , ifnull(t2.use_minute, 0) AS use_minute
	FROM seat t1
	LEFT OUTER JOIN (
		SELECT
			sub1.seat_no
			, sub1.use_seq
			, sub2.use_status
			, sub2.reserve_div
			, sub2.reserve_date
			, sub2.start_date
			, sub2.delay_minute
			, sub2.use_minute
			, sub2.product_seq
			, sub2.product_nm
			, sub2.member_seq
			, sub2.member_nm
			, sub2.memo
		FROM (
			SELECT seat_no, max(use_seq) AS use_seq
			FROM seat_use
			WHERE store_cd = p_store_cd
			AND use_status IN ('1', '4')
			GROUP BY seat_no
		) sub1
		LEFT OUTER JOIN seat_use sub2
		ON (
			sub1.use_seq = sub2.use_seq
		)
	) t2
	ON (
		t1.seat_no = t2.seat_no
	)
	WHERE t1.store_cd = p_store_cd;
END
package com.psnm.dtok.com.mainlogin.biz;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import nexcore.framework.core.Constants;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.IUserInfo;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.CryptoUtils;
import com.psnm.common.util.PsnmStringUtil;
import com.psnm.common.util.PsnmUtils;
import com.psnm.common.util.SHA256SaltHash;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FLOGIN001</li>
 * <li>설  명 : 로그인 로그아웃 처리 FU</li>
 * <li>작성일 : 2014-11-19 15:09:41</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class FLOGIN001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FLOGIN001(){
		super();
	}

	/**
	 * 사용자ID로 사용자정보 조회하여 로그인 처리함
	 *
	 * @author admin (admin)
	 * @since 2014-11-19 15:09:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	//@SuppressWarnings("rawtypes")
	public IDataSet fSearchLogin(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

	    Map<String, Object> param = requestData.getFieldMap(); // { USER_ID, PWD, USER_IP }
	    if (log.isDebugEnabled()) {
			//log.debug("<로그인처리> 입력데이터 : " + param);
		}

	    DLOGIN001  duLOGIN  = (DLOGIN001) lookupDataUnit(DLOGIN001.class);
	    DLINLOG001 duLINLOG = (DLINLOG001) lookupDataUnit(DLINLOG001.class);
	    DMENU001   duMENU   = (DMENU001) lookupDataUnit(DMENU001.class);

		try {
			String userId = (String)param.get("USER_ID");
			String pwd = (String)param.get("PWD");
			String pwdEnc = SHA256SaltHash.encode(pwd, userId); //해쉬
			if (log.isDebugEnabled()) {
				//log.debug("<로그인처리> PWD = [" + pwd + "], 해시된PWD = [" + pwdEnc + "]");
			}

			//1. 사용자정보 조회
			Map<String, Object> userMap = duLOGIN.dSearchLogin(requestData, onlineCtx).getFieldMap();

	        String _pwd           = PsnmStringUtil.isNullToString(userMap.get("PWD"           )); //비밀번호 
	        String login_fail_cnt = PsnmStringUtil.isNullToString(userMap.get("LOGIN_FAIL_CNT")); //로그인실패횟수
	        String attcCat        = PsnmStringUtil.isNullToString(userMap.get("ATTC_CAT"      )); //소속구분[공통코드:ZBAS_C_00380]

	        /*
	        String pwd_end_dt     = PsnmStringUtil.isNullToString(userMap.get("PWD_END_DT"    )); //비밀번호종료일(비밀번호사용종료일)
	        String real_biz_yn    = PsnmStringUtil.isNullToString(userMap.get("REAL_BIZ_YN"   )); //실명인증여부
	        String p_flag         = PsnmStringUtil.isNullToString(userMap.get("P_FLAG"        )); //비밀번호구분(Y신규N기존)
	        String out_user_typ   = PsnmStringUtil.isNullToString(userMap.get("OUT_USER_TYP"  )); //외부사용자구분[공통코드:OUT_USER_TYP]
	        String last_login_dt  = PsnmStringUtil.isNullToString(userMap.get("LAST_LOGIN_DT" )); //최종로그인일자
	        */

	        int nLoginFailCnt = NumberUtils.toInt(login_fail_cnt, 0);
	        if ( nLoginFailCnt > 5 ) {
	        	throw new BizRuntimeException("PSNM-E002", new String[]{"\n\n(원인) 로그인실패회수 초과!"});
	        }

	        if ( ! StringUtils.equals(pwdEnc, _pwd) ) {
	        	throw new BizRuntimeException("PSNM-E002", new String[]{"\n\n(원인) 아이디 비밀번호를 확인하십시오!"});
	        }

	        //1.5 로그인로그 조회
	        if ( StringUtils.equals("91204841", userId) ) {
	        	log.info("<로그인처리> 중복 허용 : 사용자ID = [" + userId + "]");
	        }
	        else {
		        IRecordSet rsLoginLog = duLOGIN.dSearchRecentLoginLog(requestData, onlineCtx).getRecordSet("ds");
				//로그인 되어있는 아이피와 접속 아이피가 같으면 접속
		        if(rsLoginLog.getRecordCount()>0)
		        {
		        	if(rsLoginLog.get(0,1).equals((String)param.get("USER_IP"))){
						duLOGIN.dUpdateLogout(requestData, onlineCtx);
		        	}
		        	else {
					log.warn("<로그인처리> 중복으로 로그인할 수 없습니다! " + rsLoginLog.getRecordCount() + "");
					throw new BizRuntimeException("PSNM-E002", new String[]{"\n\n(원인) 중복으로 로그인할 수 없습니다!"});
		        	}
				}
	        }
	        
	        String stopYn = PsnmStringUtil.isNullToString(userMap.get("STOP_YN"           )); // D-tok정지여부
	        String stopRsn = PsnmStringUtil.isNullToString(userMap.get("STOP_RSN_NM"           )); // DSM통제사유
	        if ("Y".equals(stopYn))
	        {
	        	throw new BizRuntimeException("PSNM-E002", new String[]{"\n\n(원인) Dtok 사용통제[사유 : " + stopRsn + "]!"});
	        }

	        //2. 사용자 정보 객체 생성 및 정보 설정
			UserInfo userInfo = this.getUserInfo(userMap);
			userInfo.setIp( PsnmStringUtil.isNullToString(param.get("USER_IP")) );
			userInfo.put("IS_MOBILE", PsnmStringUtil.isNullToString((String)param.get("IS_MOBILE"))); //mobile.jsp 인경우 'Y' //@since 2015-03
			userInfo.put("RUNTIME_MODE", nexcore.framework.core.util.BaseUtils.getRuntimeMode()); //@since 2015-04

			requestData.putField("LOGIN_FAIL_YN", "N"); //로그인성공
			requestData.putField("SUCC_YN", "Y");
			requestData.putField("IP", userInfo.getIp()); //사용자IP

	        if ( StringUtils.equals("N", PsnmStringUtil.isNullToString(userMap.get("DSMUSER_YN"))) ) {
	        	responseData.putField("DSMUSER_YN", "N"); //DSM사용자여부
	        }

			//3. 로그인실패건수를 초기화
			duLOGIN.dUpdateFailCnt(requestData, onlineCtx); 

			//4. 사용자 권한그룹 조회
			IRecordSet rsAuthGrp = duLOGIN.dSearchUserAuthGrpByDuty(requestData, onlineCtx).getRecordSet("ds");
			if ( null!=rsAuthGrp && rsAuthGrp.getRecordCount() > 0 ) {
				List<Map<String, Object>> listAuthGrp = PsnmUtils.toMapList(rsAuthGrp); //넥스코어 레코드셋을 List<Map>으로 변환
				userInfo.put("authgrp", listAuthGrp);
			}

			//5. 사용자 데이터권한 조직목록 조회(임직원인 경우에만 조회)
			if ( StringUtils.equals("1", attcCat) || StringUtils.equals("2", attcCat) || StringUtils.equals("3", attcCat) ) {
				IDataSet _dsparam5 = new DataSet();
				_dsparam5.putFieldMap( userMap );
				IRecordSet rsDataAuth = duLOGIN.dSearchUserDataAuthOrg(_dsparam5, onlineCtx).getRecordSet("ds");
				List<Map<String, Object>> listDataAuth = PsnmUtils.toMapList(rsDataAuth); //넥스코어 레코드셋을 List<Map>으로 변환
				userInfo.put("dataauthorg", listDataAuth);
			}
			else {
				//임직원이 아닌 경우, 분기별 본인인증을 하도록 유도함.
				//String realBizDt = PsnmStringUtil.isNullToString(userMap.get("REAL_BIZ_DT"     )); //실명인증일자
				String daysBizDt = PsnmStringUtil.isNullToString(userMap.get("DAYS_REAL_BIZ_DT")); //실명인증후 흐른 일수

				try {
					if ( Integer.parseInt(daysBizDt) > 91 ) {
						responseData.putField("NEED_TO_CHECK_NAME", "Y"); //분기별 본인확인 필요
					}
				}
				catch (Exception e) {
					responseData.putField("NEED_TO_CHECK_NAME", "Y"); //분기별 본인확인 필요(본인인증을 하지 않음 상태임)
				}
			}

			//6. 로그인로그를 등록
			duLINLOG.dInsertLog(requestData, onlineCtx);

			//7. 최상위 메뉴목록을 조회하여 반환
			requestData.putField("MENU_TYP_CD", "1"); //대메뉴만 조회
			IRecordSet rsTopMenu = duMENU.dSearchMenuTree(requestData, onlineCtx).getRecordSet("ds");

			responseData.putRecordSet("top-menu", rsTopMenu);

			List<Map<String, Object>> topMenuList = PsnmUtils.toMapList(rsTopMenu); //넥스코어 레코드셋을 List<Map>으로 변환
			log.debug("<로그인처리> psnm-topmenus\n\n" + topMenuList + "\n\n\n\n");

			userInfo.put("psnm-topmenus", topMenuList);

			//99. 사용자정보르 응답데이터 설정
			responseData.putField(Constants.USER, userInfo); //응답데이터 설정
		}
		catch (BizRuntimeException be) {
			String errMesg = be.getMessage();

			log.error("<로그인처리> <오류> <비즈니스실행시간오류> 에러메시지 : " + errMesg);

			if ( null!=errMesg && errMesg.indexOf("비밀번호")>=0 ) { //비밀번호 틀린 경우만 실패건수 +1 함
				requestData.putField("LOGIN_FAIL_YN", "Y"); //로그인실패
				requestData.putField("SUCC_YN",       "N");
				duLOGIN.dUpdateFailCnt(requestData, onlineCtx);
			}
			throw be;
		}
		catch (NullPointerException npe) {
			throw new BizRuntimeException("PSNM-E002", new String[]{"\n\n(원인) 아이디 비밀번호를 확인하십시오!"});
		}
		catch (Exception e) {
			String errMsg = "\n\n(원인) " + e.getMessage();
			log.error("<로그인처리> <오류> " + errMsg);
			throw new BizRuntimeException("PSNM-E002", new String[]{errMsg});
		}
		responseData.setOkResultMessage("PSNM-I002", new String[]{"로그인"}); //"정상적으로 {0} 되었습니다."

	    return responseData;
	}

	/**
	 * 
	 * @param  user
	 * @return
	 */
	private UserInfo getUserInfo(Map<String, Object> user) {
		if (null==user) {
			throw new BizRuntimeException("PSNM-E002", new String[]{"(원인) 사용자정보가 없습니다!"});
		}

	    // 사용자 정보 객체(nexcore.framework.core.data.user.UserInfo) 생성 및 정보 설정
		UserInfo userInfo = new UserInfo();

		// 사용자 기본 항목 설정
	    userInfo.setLoginId( PsnmStringUtil.isNullToString(user.get("USER_ID")) );
	    userInfo.setLoginTime( new java.util.Date() );
	    userInfo.setLocale( Locale.getDefault() );

	    // 사용자 추가 항목 설정
	    userInfo.put("USER_ID"       , PsnmStringUtil.isNullToString(user.get("USER_ID"       ))); //USER_ID
        userInfo.put("U_KEY_ID"      , PsnmStringUtil.isNullToString(user.get("U_KEY_ID"      ))); //UKey ID
        userInfo.put("USER_CD"       , PsnmStringUtil.isNullToString(user.get("USER_CD"       ))); //사번
        userInfo.put("USER_NM"       , PsnmStringUtil.isNullToString(user.get("USER_NM"       ))); //사용자이름(마스킹)
        userInfo.put("USER_NAME"     , PsnmStringUtil.isNullToString(user.get("USER_NAME"     ))); //사용자이름(원본)
        userInfo.put("WPHON"         , PsnmStringUtil.isNullToString(user.get("WPHON"         ))); //유선전화
        userInfo.put("USER_GRP"      , PsnmStringUtil.isNullToString(user.get("USER_GRP"      ))); //사용자그룹[공통코드:ZBAS_C_00250]
        userInfo.put("ORG_ID"        , PsnmStringUtil.isNullToString(user.get("ORG_ID"        ))); //소속
        userInfo.put("ORG_AREA"      , PsnmStringUtil.isNullToString(user.get("ORG_AREA"      ))); //근무지
        userInfo.put("PWD_END_DT"    , PsnmStringUtil.isNullToString(user.get("PWD_END_DT"    ))); //비밀번호종료일(비밀번호사용종료일)
        userInfo.put("DUTY"          , PsnmStringUtil.isNullToString(user.get("DUTY"          ))); //직무
        userInfo.put("POS_AGENCY"    , PsnmStringUtil.isNullToString(user.get("POS_AGENCY"    ))); //소속대리점
        userInfo.put("ATTC_CAT"      , PsnmStringUtil.isNullToString(user.get("ATTC_CAT"      ))); //소속구분[공통코드:ZBAS_C_00380]
        userInfo.put("HAPPY_SMS1"    , PsnmStringUtil.isNullToString(user.get("HAPPY_SMS1"    ))); //HAPPY_SMS1
        userInfo.put("HAPPY_SMS2"    , PsnmStringUtil.isNullToString(user.get("HAPPY_SMS2"    ))); //HAPPY_SMS2
        userInfo.put("HAPPY_SMS3"    , PsnmStringUtil.isNullToString(user.get("HAPPY_SMS3"    ))); //HAPPY_SMS3
        userInfo.put("ACC_SMS1"      , PsnmStringUtil.isNullToString(user.get("ACC_SMS1"      ))); //ACC_SMS1
        userInfo.put("ACC_SMS2"      , PsnmStringUtil.isNullToString(user.get("ACC_SMS2"      ))); //ACC_SMS2
        userInfo.put("BIZ_JM_NUM"    , PsnmStringUtil.isNullToString(user.get("BIZ_JM_NUM"    ))); //주민등록번호
        userInfo.put("REAL_BIZ_YN"   , PsnmStringUtil.isNullToString(user.get("REAL_BIZ_YN"   ))); //실명인증여부
        userInfo.put("PORTAL_USER_ID", PsnmStringUtil.isNullToString(user.get("PORTAL_USER_ID"))); //포탈통합ID
        userInfo.put("MST_MBL_PHONE" , PsnmStringUtil.isNullToString(user.get("MST_MBL_PHONE" ))); //대표이동전화번호
        userInfo.put("EMAIL_RECV_CL" , PsnmStringUtil.isNullToString(user.get("EMAIL_RECV_CL" ))); //E-MAIL수신구분(01:직책자REPORT)
        userInfo.put("P_FLAG"        , PsnmStringUtil.isNullToString(user.get("P_FLAG"        ))); //비밀번호구분(Y신규N기존)
        userInfo.put("NEW_ORG_ID"    , PsnmStringUtil.isNullToString(user.get("NEW_ORG_ID"    ))); //신소속조직
        userInfo.put("USER_TYP"      , PsnmStringUtil.isNullToString(user.get("USER_TYP"      ))); //사용자유형
        userInfo.put("RPSTY"         , PsnmStringUtil.isNullToString(user.get("RPSTY"         ))); //직책[공통코드:ZBAS_C_00210]
        userInfo.put("OUT_USER_TYP"  , PsnmStringUtil.isNullToString(user.get("OUT_USER_TYP"  ))); //외부사용자구분[공통코드:OUT_USER_TYP]
        userInfo.put("CPLAZA_ORG_CD" , PsnmStringUtil.isNullToString(user.get("CPLAZA_ORG_CD" ))); //CLOVERPLAZA조직코드(=거래처코드 / MA코드)
        userInfo.put("TRSP_DEALCO_CD", PsnmStringUtil.isNullToString(user.get("TRSP_DEALCO_CD"))); //3차점거래처코드
        userInfo.put("LOGIN_FAIL_CNT", PsnmStringUtil.isNullToString(user.get("LOGIN_FAIL_CNT"))); //로그인실패횟수
        userInfo.put("LAST_LOGIN_DT" , PsnmStringUtil.isNullToString(user.get("LAST_LOGIN_DT" ))); //최종로그인일자
        userInfo.put("OUT_ORG_ID"    , PsnmStringUtil.isNullToString(user.get("OUT_ORG_ID"    ))); //외부조직 ID
        userInfo.put("DUTY_NM"       , PsnmStringUtil.isNullToString(user.get("DUTY_NM"       ))); //직무명
        userInfo.put("DUTY_USER_TYP" , PsnmStringUtil.isNullToString(user.get("DUTY_USER_TYP" ))); //USER_TYP in (TBAS_DUTY_MGMT)
        userInfo.put("MBR_RPSTY"     , PsnmStringUtil.isNullToString(user.get("MBR_RPSTY"     ))); //직책코드 (TBAS_OUT_ORG_MBR_MGMT)
        userInfo.put("RPSTY_NM"      , PsnmStringUtil.isNullToString(user.get("RPSTY_NM"      ))); //직책명

        userInfo.put("SALE_TEAM_ORG_ID", PsnmStringUtil.isNullToString(user.get("SALE_TEAM_ORG_ID" ))); //영업팀 조직ID
        userInfo.put("SALE_DEPT_ORG_ID", PsnmStringUtil.isNullToString(user.get("SALE_DEPT_ORG_ID" ))); //영업국 조직ID
        userInfo.put("HDQT_PART_ORG_ID", PsnmStringUtil.isNullToString(user.get("HDQT_PART_ORG_ID" ))); //본사파트 조직ID
        userInfo.put("HDQT_TEAM_ORG_ID", PsnmStringUtil.isNullToString(user.get("HDQT_TEAM_ORG_ID" ))); //본사팀 조직ID

        userInfo.put("SALE_AGNT_ORG_ID", PsnmStringUtil.isNullToString(user.get("CPLAZA_ORG_CD"    ))); //에이전트ID=CLOVERPLAZA조직코드(=거래처코드 / MA코드)
        userInfo.put("SALE_AGNT_ORG_NM", PsnmStringUtil.isNullToString(user.get("SALE_AGNT_ORG_NM" ))); //에이전트명
        userInfo.put("SALE_TEAM_ORG_NM", PsnmStringUtil.isNullToString(user.get("SALE_TEAM_ORG_NM" ))); //영업팀 조직명
        userInfo.put("SALE_DEPT_ORG_NM", PsnmStringUtil.isNullToString(user.get("SALE_DEPT_ORG_NM" ))); //영업국 조직명
        userInfo.put("HDQT_PART_ORG_NM", PsnmStringUtil.isNullToString(user.get("HDQT_PART_ORG_NM" ))); //본사파트 조직명
        userInfo.put("HDQT_TEAM_ORG_NM", PsnmStringUtil.isNullToString(user.get("HDQT_TEAM_ORG_NM" ))); //본사팀 조직명
        userInfo.put("CS_YN"      				 , PsnmStringUtil.isNullToString(user.get("CS_YN"       ))); // 에이전트 국장업무대행여부
        
        userInfo.put("DSMUSER_YN"      , PsnmStringUtil.isNullToString(user.get("DSMUSER_YN"       ))); //DSM사용자여부
        userInfo.put("NICK_NM"         , PsnmStringUtil.isNullToString(user.get("NICK_NM"          ))); //닉네임 in (DSM_USER)
        userInfo.put("PIC_FILE_ID"     , PsnmStringUtil.isNullToString(user.get("PIC_FILE_ID"      ))); //사진파일ID (DSM_USER)
        userInfo.put("MBL_PHON"        , PsnmStringUtil.isNullToString(user.get("MBL_PHON"         ))); //이동전화 (DSM_USER)
        userInfo.put("MBL_PHON_NUM"    , PsnmStringUtil.isNullToString(user.get("MBL_PHON_NUM"     ))); //이동전화 (DSM_USER)
        userInfo.put("MBL_PHON_NUM1"   , PsnmStringUtil.isNullToString(user.get("MBL_PHON_NUM1"    ))); //이동전화1 (DSM_USER)
        userInfo.put("MBL_PHON_NUM2"   , PsnmStringUtil.isNullToString(user.get("MBL_PHON_NUM2"    ))); //이동전화2 (DSM_USER)
        userInfo.put("MBL_PHON_NUM3"   , PsnmStringUtil.isNullToString(user.get("MBL_PHON_NUM3"    ))); //이동전화3 (DSM_USER)
        userInfo.put("EMAIL_ID"        , PsnmStringUtil.isNullToString(user.get("EMAIL_ID"         ))); //이메일ID (DSM_USER)
        userInfo.put("EMAIL_DMN_CD"    , PsnmStringUtil.isNullToString(user.get("EMAIL_DMN_CD"     ))); //이메일도메인코드 (DSM_USER)
        userInfo.put("EMAIL_DMN_NM"    , PsnmStringUtil.isNullToString(user.get("EMAIL_DMN_NM"     ))); //이메일도메인명 (DSM_USER)
        userInfo.put("REAL_BIZ_DT"     , PsnmStringUtil.isNullToString(user.get("REAL_BIZ_DT"      ))); //실명인증일자
        userInfo.put("DAYS_REAL_BIZ_DT", PsnmStringUtil.isNullToString(user.get("DAYS_REAL_BIZ_DT" ))); //실명인증후 흐른 일수 

        userInfo.put("CURR_YMD"        , PsnmStringUtil.isNullToString(user.get("CURR_YMD"         ))); //현재일자(yyyyMMdd)
        userInfo.put("CURR_HMS"        , PsnmStringUtil.isNullToString(user.get("CURR_HMS"         ))); //현재시각(HHmmss)
        userInfo.put("RCV_PAPER_CNT"   , PsnmStringUtil.isNullToString(user.get("RCV_PAPER_CNT"    ))); //받은쪽지개수

        userInfo.put("USE_RSTRCT_APLY_STA_HM", PsnmStringUtil.isNullToString(user.get("USE_RSTRCT_APLY_STA_HM"))); //사용제한모드 오늘 시작시각
        userInfo.put("USE_RSTRCT_APLY_END_HM", PsnmStringUtil.isNullToString(user.get("USE_RSTRCT_APLY_END_HM"))); //사용제한모드 오늘 종료시각

        return userInfo;
	}

	/**
	 * 로그아웃 처리
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-21 16:32:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fLogout(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

		IUserInfo iUserInfo = onlineCtx.getUserInfo();

		requestData.putField("USER_ID", iUserInfo.getLoginId());
		requestData.putField("IP", iUserInfo.getIp());

	    //DLOGIN001 du = null;

		try {
			//로그인로그를 등록
			DLINLOG001 duLINLOG = (DLINLOG001) lookupDataUnit(DLINLOG001.class);

			duLINLOG.dUpdateLog(requestData, onlineCtx);
		}
		catch (BizRuntimeException be) {
			log.error("<로그아웃처리> <오류> " + be.getMessage());
			//du.dUpdateFailCnt(requestData, onlineCtx);
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 지정된 메뉴의 하위 메뉴 TREE 목록을 조회함
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-19 15:09:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMenuTree(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    //Log log = getLog(onlineCtx);

	    DMENU001 du = null;

		try {
			du = (DMENU001) lookupDataUnit(DMENU001.class);

			IRecordSet rs = du.dSearchMenuTree(requestData, onlineCtx).getRecordSet("ds");

			responseData.putRecordSet("ds", rs);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
		responseData.setOkResultMessage("PSNM-I000", null);

	    return responseData;
	}

	/**
	 * 비밀번호변경
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-19 11:37:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdatePwd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
	    Log log = getLog(onlineCtx);

		IUserInfo iUserInfo = onlineCtx.getUserInfo();
		requestData.putField("USER_ID", iUserInfo.getLoginId());

		if ( log.isDebugEnabled() ) {
	    	//log.debug("<<비밀번호변경>> 파라미터 : " + requestData.getFieldMap());
		}

		String userId = iUserInfo.getLoginId();
		String oldPwdPlain = requestData.getField("OLD_PWD");
		String newPwdPlain = requestData.getField("NEW_PWD");

		try {
			DLOGIN001 du = (DLOGIN001) lookupDataUnit(DLOGIN001.class);

			String oldPwdEnc = SHA256SaltHash.encode(oldPwdPlain, userId); //해쉬 //CryptoUtils.digestSHA256( oldPwdPlain );
			String newPwdEnc = SHA256SaltHash.encode(newPwdPlain, userId); //해쉬 //CryptoUtils.digestSHA256( newPwdPlain );

			//1. 사용자정보 조회
			Map<String, Object> user = du.dSearchLogin(requestData, onlineCtx).getFieldMap();

	        String oldPwdDb = PsnmStringUtil.isNullToString(user.get("PWD")); //비밀번호
	        if ( !StringUtils.equals(oldPwdEnc, oldPwdDb) ) {
	        	throw new BizRuntimeException("PSNM-E003", new String[]{"(원인) 비밀번호 다름!"}); //비밀번호를 변경할 수 없습니다. {0}
	        }

	        //2. 비밀번호 변경
	        requestData.putField("OLD_PWD", oldPwdEnc);
	        requestData.putField("NEW_PWD", newPwdEnc);

	        //최근비밀번호 중복 체크	        
		    responseData = du.dSearchIsRecentPwd(requestData, onlineCtx);
		    if( responseData.getIntField("CNT") > 0 ){
		    	throw new BizRuntimeException("PSNM-E024");
		    }
	        
			responseData = du.dUpdatePwd(requestData, onlineCtx);
			int result = responseData.getIntField("result");
			if ( log.isDebugEnabled() ) {
		    	log.debug("<<비밀번호변경>> 결과 : " + result);
			}
			
			//비밀번호 이력
			du.dInsertPwdChgHst(requestData, onlineCtx);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}
}

package com.psnm.common.util;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.util.DateUtils;

import org.apache.commons.lang.StringUtils;

/**
 * PS&Marketing 일반 도구 클래스
 * 
 * @author PSNM
 * 
 */
public final class PsnmUtils {

	/**
	 * 넥스코어 레코드셋을  List<Map<String, Object>>으로 변환.(레코드셋은 jstl에서 사용불가)
	 * 
	 * @param  recordSet	변환할 넥스코어 레코드셋
	 * @return 맵의 배열로 반환
	 */
	public static List<Map<String, Object>> toMapList(IRecordSet recordSet) {
		int size = null==recordSet ? -1 : recordSet.getRecordCount();

		if (size<1) {
			return null;
		}

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>(size);

		for(int i=0; i<size; i++) {
			Map<String, Object> amap = new HashMap<String, Object>();

			IRecord record = recordSet.getRecord(i);

			@SuppressWarnings("unchecked")
			Set<String> keys = record.keySet();
			Iterator<String> keyIter = keys.iterator();

			while(keyIter.hasNext()) {
				String key = keyIter.next();
				amap.put(key, record.get(key));
			}
			list.add( amap );
		}
		return list;
	}

	/**
	 * 현재 정상적인 로그인 상태이면 true를 반환
	 * 
	 * @param  onlineCtx	넥스코어컨텍스트객체
	 * @return 로그인 상태이면 true
	 */
	public static boolean isValidSession(IOnlineContext onlineCtx) {
		boolean isValid = false;
		try {
			UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
			if (null!=userInfo && !StringUtils.equals("Anonymous", userInfo.getLoginId())) {
				isValid = true;
			}
		}
		catch(Exception e) {
			isValid = false;
		}
		return isValid;
	}

	/**
	 * '임직원여부'를 판단하여 반환
	 * 
	 * @param  userInfo	세션사용자정보객체
	 * @return 임직원이면 true
	 */
	public static boolean isEmployee(UserInfo userInfo) {
		if (null==userInfo || StringUtils.equalsIgnoreCase("Anonymous", userInfo.getLoginId())) {
			return false;
		}

		String attcCat = userInfo.getString("ATTC_CAT"); //소속구분[공통코드:ZBAS_C_00380]
		//userInfo.put("ATTC_CAT", PsnmStringUtil.isNullToString(user.get("ATTC_CAT"))); 
		return isEmployee(attcCat);
	}
	public static boolean isEmployee(String attcCat) {
		if ( StringUtils.equals("1", attcCat) || StringUtils.equals("2", attcCat) || StringUtils.equals("3", attcCat) ) {
			//소속구분이 1, 2, 3 이면 '임직원'
			return true;
		}
		return false;
	}
	public static boolean isEmployee(IOnlineContext onlineCtx) {
		if ( !isValidSession(onlineCtx) ) {
			return false;
		}
		return isEmployee( (UserInfo)onlineCtx.getUserInfo() );
	}

	/**
	 * 세션값을 문자열로 반환
	 * @param onlineCtx	컨텍스트객체
	 * @param key		조회할 키(문자열) (예, USER_ID, USER_NM)
	 * @return 해당 키의 세션값(문자열)
	 */
	public static String getSessionValue(IOnlineContext onlineCtx, String key) {
		String val = null;
		try {
			UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
			if (null!=userInfo) {
				val = (String)userInfo.getString(key);
			}
		}
		catch(Exception e) {
			val = null;
		}
		return val;
	}

	/**
	 * 세션사용자정보를 문자열로 반환
	 * 
	 * @param 	userInfo	세션사용자객체
	 * @return	세션사용자정보 문자열(주요정보만)
	 */
	public static String toString(UserInfo userInfo) {
		if (null==userInfo) {
			return "UserInfo is NULL!";
		}

		StringBuffer sb = new StringBuffer();
		sb.append("UserInfo {\n");
		sb.append("    loginId : '").append( userInfo.getLoginId() ).append("'\n");
		sb.append("    ip : '").append( userInfo.getIp() ).append("'\n");

		if ( StringUtils.equalsIgnoreCase("Anonymous", userInfo.getLoginId()) ) {
			sb.append("}");
			return sb.toString();
		}

        sb.append("    USER_ID = '").append( userInfo.get("USER_ID") ).append("'\n"); //USER_ID
        sb.append("    USER_NM = '").append( userInfo.get("USER_NM") ).append("'\n"); //사용자이름(마스킹)
        sb.append("    USER_NAME = '").append( userInfo.get("USER_NAME") ).append("'\n"); //사용자이름(원본)
        sb.append("    PWD_END_DT = '").append( userInfo.get("PWD_END_DT") ).append("'\n"); //비밀번호종료일(비밀번호사용종료일)
        sb.append("    LOGIN_FAIL_CNT = '").append( userInfo.get("LOGIN_FAIL_CNT") ).append("'\n"); //로그인실패횟수
        sb.append("    LAST_LOGIN_DT = '").append( userInfo.get("LAST_LOGIN_DT") ).append("'\n"); //최종로그인일자
        sb.append("    REAL_BIZ_YN = '").append( userInfo.get("REAL_BIZ_YN") ).append("'\n"); //실명인증여부
        sb.append("    P_FLAG = '").append( userInfo.get("P_FLAG") ).append("'\n"); //비밀번호구분(Y신규N기존)

        sb.append("    DUTY = '").append( userInfo.get("DUTY") ).append("'\n"); //직무
        sb.append("    DUTY_NM = '").append( userInfo.get("DUTY_NM") ).append("'\n"); //직무명
        sb.append("    ATTC_CAT = '").append( userInfo.get("ATTC_CAT") ).append("'\n"); //소속구분[공통코드:ZBAS_C_00380]
        sb.append("    DUTY_USER_TYP = '").append( userInfo.get("DUTY_USER_TYP") ).append("'\n"); //USER_TYP in (TBAS_DUTY_MGMT)
        sb.append("    USER_TYP = '").append( userInfo.get("USER_TYP") ).append("'\n"); //사용자유형
        sb.append("    ORG_ID = '").append( userInfo.get("ORG_ID") ).append("'\n"); //소속
        sb.append("    OUT_USER_TYP = '").append( userInfo.get("OUT_USER_TYP") ).append("'\n"); //외부사용자구분[공통코드:OUT_USER_TYP]
        sb.append("    NEW_ORG_ID = '").append( userInfo.get("NEW_ORG_ID") ).append("'\n"); //신소속조직
        sb.append("    OUT_ORG_ID = '").append( userInfo.get("OUT_ORG_ID") ).append("'\n"); //외부조직 ID
        sb.append("    CPLAZA_ORG_CD = '").append( userInfo.get("CPLAZA_ORG_CD") ).append("'\n"); //CLOVERPLAZA조직코드(=거래처코드 / MA코드)

        sb.append("    SALE_AGNT_ORG_ID = '").append( userInfo.get("SALE_AGNT_ORG_ID") ).append("'\n"); //에이전트ID=CLOVERPLAZA조직코드(=거래처코드 / MA코드)
        sb.append("    SALE_TEAM_ORG_ID = '").append( userInfo.get("SALE_TEAM_ORG_ID") ).append("'\n"); //영업팀 조직ID
        sb.append("    SALE_DEPT_ORG_ID = '").append( userInfo.get("SALE_DEPT_ORG_ID") ).append("'\n"); //영업국 조직ID
        sb.append("    HDQT_PART_ORG_ID = '").append( userInfo.get("HDQT_PART_ORG_ID") ).append("'\n"); //본사파트 조직ID
        sb.append("    HDQT_TEAM_ORG_ID = '").append( userInfo.get("HDQT_TEAM_ORG_ID") ).append("'\n"); //본사팀 조직ID
        sb.append("    SALE_AGNT_ORG_NM = '").append( userInfo.get("SALE_AGNT_ORG_NM") ).append("'\n"); //에이전트명
        sb.append("    SALE_TEAM_ORG_NM = '").append( userInfo.get("SALE_TEAM_ORG_NM") ).append("'\n"); //영업팀 조직명
        sb.append("    SALE_DEPT_ORG_NM = '").append( userInfo.get("SALE_DEPT_ORG_NM") ).append("'\n"); //영업국 조직명
        sb.append("    HDQT_PART_ORG_NM = '").append( userInfo.get("HDQT_PART_ORG_NM") ).append("'\n"); //본사파트 조직명
        sb.append("    HDQT_TEAM_ORG_NM = '").append( userInfo.get("HDQT_TEAM_ORG_NM") ).append("'\n"); //본사팀 조직명
        sb.append("    NICK_NM  = '").append( userInfo.get("NICK_NM") ).append("'\n"); //닉네임 in (DSM_USER)
        sb.append("    PIC_FILE_ID = '").append( userInfo.get("PIC_FILE_ID") ).append("'\n"); //사진파일ID (DSM_USER)
        sb.append("    CERT_YN = '").append( userInfo.get("CERT_YN") ).append("'\n"); //이동통신사코드(DSM_USER.TEL_CO_CD)에따라
        sb.append("    CURR_YMD = '").append( userInfo.get("CURR_YMD") ).append("'\n"); //현재일자(yyyyMMdd)

		sb.append("}");
		return sb.toString();
	}

	/**
	 * 세션사용자정보에서 '권한그룹' 목록을 반환
	 * @param 	userInfo	세션사용자객체
	 * @return  권한그룹 목록
	 */
	public static List<Map<String, Object>> getUserAuthGrp(UserInfo userInfo) {
		if (null==userInfo || StringUtils.equalsIgnoreCase("Anonymous", userInfo.getLoginId())) {
			return null;
		}
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> listAuthGrp = (List<Map<String, Object>>)userInfo.get("authgrp");
		return listAuthGrp;
	}

	/**
	 * 세션사용자정보에서 '데이터권한조직' 목록을 반환
	 * @param 	userInfo	세션사용자객체
	 * @return  데이터권한조직' 목록
	 */
	public static List<Map<String, Object>> getUserDataAuthOrg(UserInfo userInfo) {
		if (null==userInfo || StringUtils.equalsIgnoreCase("Anonymous", userInfo.getLoginId())) {
			return null;
		}
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> listDataAuthOrg = (List<Map<String, Object>>)userInfo.get("dataauthorg");
		return listDataAuthOrg;
	}

	/**
	 * 세션사용자정보에서 데이터권한의 지정된 조직ID를 문자열배열로 반환
	 * 
	 * @param 	userInfo	세션사용자객체
	 * @param 	keyName		추출할 조직ID(HDQT_TEAM_ORG_ID 또는 HDQT_PART_ORG_ID)
	 * @return	데이터권한의 지정된 조직ID 문자열배열
	 */
	public static String[] extractUserDataAuthOrg(UserInfo userInfo, String keyName) {
		if ( StringUtils.isBlank(keyName) ) {
			keyName = "HDQT_TEAM_ORG_ID"; //디폴트 '본사팀조직ID' 조회
		}

		List<Map<String, Object>> listDataAuth = getUserDataAuthOrg(userInfo);
    	int sizeDataAuth = null==listDataAuth ? 0 : listDataAuth.size();
    	//log.info("<본사팀조회> 권한이 있는 본사파트 조직 개수: " + sizeDataAuth);

    	String[] saOrgId = null;

    	if (sizeDataAuth>0) {
    		saOrgId = new String[sizeDataAuth];
    		for(int i=0; i<sizeDataAuth; i++) {
    			Map<String, Object> daOrg = listDataAuth.get(i);
    			saOrgId[i] = (String)daOrg.get(keyName); //"HDQT_TEAM_ORG_ID" or "HDQT_PART_ORG_ID"
    			System.out.println("- 권한이 있는 [" + keyName + "] : " + saOrgId[i]);
    		}
    	}
    	return saOrgId;
	}

	/**
	 * 음력날짜를 구하여 반환('yyyyMMdd' 형식)
	 * 
	 * @param  solarDate	양력날짜 'yyyyMMdd' 형식
	 * @return 음력날짜 'yyyyMMdd' 형식
	 */
	public static String getLunarDate(String solarDate) {
    	java.util.Calendar cal = DateUtils.parseCalendar(solarDate, "yyyyMMdd"); //Calendar.getInstance();
    	com.ibm.icu.util.ChineseCalendar chCal = new com.ibm.icu.util.ChineseCalendar();
    	chCal.setTimeInMillis(cal.getTimeInMillis());

    	int chYear  = chCal.get(com.ibm.icu.util.ChineseCalendar.EXTENDED_YEAR)-2637;
    	int chMonth = 1 + chCal.get(com.ibm.icu.util.ChineseCalendar.MONTH);
    	int chDate  = chCal.get(com.ibm.icu.util.ChineseCalendar.DAY_OF_MONTH);

    	StringBuffer chMd = new StringBuffer();
    	chMd.append(chYear).append(chMonth<10? "0" : "").append(chMonth).append(chDate<10? "0" : "").append(chDate);

    	return chMd.toString();
	}

	/**
	 * 지정된 날짜를 포함하는 일주일간의 날짜(월요일 ~ 일요일)를 배열로 반환 (날짜형식은 'yyyyMMdd')
	 * 
	 * @param 	theSolarDay		날짜지정(날짜형식은 'yyyyMMdd')
	 * @param 	returnFormat	반환되는 날짜형식(디폴트 'yyyyMMdd'이며 현재 'MMdd'만 가능)
	 * @return  지정된 날짜를 포함하는 일주일간의 날짜(월요일 ~ 일요일)를 배열
	 */
	public static String[] getWeekDateList(String theSolarDay, String returnFormat) {
		if ( StringUtils.isBlank(theSolarDay) ) {
			theSolarDay = DateUtils.getCurrentDate();
		}

		String[] weekDateList = new String[7];

		int dayOfWeek = DateUtils.getDayOfWeek(theSolarDay);
		int dayOffset = 0;
		
		if ( Calendar.MONDAY == dayOfWeek ) {
			dayOffset = 0;
		}
		else if ( Calendar.TUESDAY == dayOfWeek ) {
			dayOffset = 1;
		}
		else if ( Calendar.WEDNESDAY == dayOfWeek ) {
			dayOffset = 2;
		}
		else if ( Calendar.THURSDAY == dayOfWeek ) {
			dayOffset = 3;
		}
		else if ( Calendar.FRIDAY == dayOfWeek ) {
			dayOffset = 4;
		}
		else if ( Calendar.SATURDAY == dayOfWeek ) {
			dayOffset = 5;
		}
		else if ( Calendar.SUNDAY == dayOfWeek ) {
			dayOffset = 6;
		}

		weekDateList[0] = DateUtils.addDay(theSolarDay, 0-dayOffset);
		weekDateList[1] = DateUtils.addDay(theSolarDay, 1-dayOffset);
		weekDateList[2] = DateUtils.addDay(theSolarDay, 2-dayOffset);
		weekDateList[3] = DateUtils.addDay(theSolarDay, 3-dayOffset);
		weekDateList[4] = DateUtils.addDay(theSolarDay, 4-dayOffset);
		weekDateList[5] = DateUtils.addDay(theSolarDay, 5-dayOffset);
		weekDateList[6] = DateUtils.addDay(theSolarDay, 6-dayOffset);

		if ( StringUtils.isNotBlank(returnFormat) && StringUtils.equals("MMdd", returnFormat) ) {
			for (int i=0; i<weekDateList.length; i++) {
				weekDateList[i] = weekDateList[i].substring(4);
			}
		}
		return weekDateList;
	}
	public static String[] getWeekDateList(String theSolarDay) {
		return PsnmUtils.getWeekDateList(theSolarDay, "yyyyMMdd");
	}

	/**
	 * 지정된 (양력)날짜를 포함하는 일주일간의 '음력' 날짜(월요일 ~ 일요일)를 배열로 반환 (날짜형식은 'yyyyMMdd')
	 * 
	 * @param 	theDay			(양력)날짜지정(날짜형식은 'yyyyMMdd')
	 * @param 	returnFormat	반환되는 날짜형식(디폴트 'yyyyMMdd'이며 현재 'MMdd'만 가능)
	 * @return  지정된 날짜를 포함하는 일주일간의 '음력' 날짜(월요일 ~ 일요일) 배열
	 */
	public static String[] getLunarWeekDateList(String theSolarDay, String returnFormat) {
		if ( StringUtils.isBlank(theSolarDay) ) {
			theSolarDay = DateUtils.getCurrentDate();
		}

		String[] weekSolarDateList = PsnmUtils.getWeekDateList(theSolarDay, "yyyyMMdd");

		if (null==weekSolarDateList) {
			return null;
		}

		String[] weekLunarDateList = new String[weekSolarDateList.length];

		for (int i=0; i<weekSolarDateList.length; i++) {
			String ymd = PsnmUtils.getLunarDate(weekSolarDateList[i]);

			if ( StringUtils.isNotBlank(returnFormat) && StringUtils.equals("MMdd", returnFormat) ) {
				weekLunarDateList[i] = ymd.substring(4);
			}
			else {
				weekLunarDateList[i] = ymd;
			}
		}
		return weekLunarDateList;
	}
	public static String[] getLunarWeekDateList(String theSolarDay) {
		return PsnmUtils.getLunarWeekDateList(theSolarDay, "yyyyMMdd");
	}

	public static void main( String[] args ) throws Exception {
    	String[] thedays = {
    			"20150316",
    			"20150325",
    			"20150331",
    			"20150515",
    	};

    	String returnFormat = "MMdd";

    	for (int i=0; i<thedays.length; i++) {
    		String[] weekdays = PsnmUtils.getWeekDateList(thedays[i], returnFormat);
    		String[] lunarWeekdays = PsnmUtils.getLunarWeekDateList(thedays[i], returnFormat);

    		System.out.print("- the DAY = [" + thedays[i] + "] ::: (solar) week-days = [");
    		for(int j=0; j<weekdays.length; j++) {
    			System.out.print("" + weekdays[j] + ",");
    		}
    		System.out.println("]");

    		System.out.print("- the DAY = [" + thedays[i] + "] ::: (lunar) week-days = [");
    		for(int j=0; j<lunarWeekdays.length; j++) {
    			System.out.print("" + lunarWeekdays[j] + ",");
    		}
    		System.out.println("]");
    		System.out.println("");
    	}
    }
}


package com.psnm.dtok.com.mainlogin.biz;

import org.apache.commons.lang.StringUtils;

import com.psnm.common.util.PsnmUtils;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.util.DateUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DMAIN001</li>
 * <li>설  명 : 로그인후 메인화면 각종 정보 조회</li>
 * <li>작성일 : 2014-12-17 14:00:25</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DMAIN001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMAIN001(){
		super();
	}

	/**
	 * 주요일정목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-18 16:12:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMAIN001.dSearchSchList", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 받은쪽지개수조회 (참고) 필드맵 'RCV_PAPER_CNT' 로 저장하여 반환
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:00:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchRcvPaperCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		//IRecordSet rs = dbSelect("DMAIN001.dSearchRcvPaperCount", requestData.getFieldMap(), onlineCtx);
		//responseData.putRecordSet("ds", rs);
		IRecord map = this.dbSelectSingle("DMAIN001.dSearchRcvPaperCount", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
		return responseData;
	}

	/**
	 * 월별 명언조회(1건) (참고) 필드맵에 반환됨(PHRS, ATHR)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:00:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchPhrs(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		//IRecordSet rs = dbSelect("DMAIN001.dSearchPhrs", requestData.getFieldMap(), onlineCtx);
		//responseData.putRecordSet("ds", rs);
		IRecord map = this.dbSelectSingle("DMAIN001.dSearchPhrs", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
		return responseData;
	}

	/**
	 * 사용자별 각종여부 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-23 13:03:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserYn(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMAIN001.dSearchUserYn", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]생일자목록조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:00:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchWhoBorn(IDataSet requestData, IOnlineContext onlineCtx) {
	    UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

        String isBoundedByDept = "N"; //영업국제한
        String isBoundedByTeam = "N"; //영업팀제한
        
        if ( ! PsnmUtils.isEmployee(onlineCtx) ) { //임직원이 아니면 '소속영업국'으로 제한
        	requestData.putField("SALE_DEPT_ORG_ID", userInfo.getString("SALE_DEPT_ORG_ID")); //현재세션의 영업국ID
            isBoundedByDept = "Y";
        }
        if ( StringUtils.equals("16", userInfo.getString("DUTY")) || StringUtils.equals("18", userInfo.getString("DUTY")) ) { //16=DSM팀장, 18=DSM_MA
            requestData.putField("SALE_TEAM_ORG_ID", userInfo.getString("SALE_TEAM_ORG_ID")); //현재세션의 영업국ID
            isBoundedByTeam = "Y";
        }
        requestData.putField("IS_BOUNDED_BY_DEPT", isBoundedByDept);
        requestData.putField("IS_BOUNDED_BY_TEAM", isBoundedByTeam);

		//금주 생일자 조회(월~일) : 기본 검색조건
    	String[] solarweekdays = new String[2]; //PsnmUtils.getWeekDateList(null, "MMdd");
    	String[] lunarweekdays = new String[2]; //PsnmUtils.getLunarWeekDateList(null, "MMdd");

    	solarweekdays[0] = DateUtils.getCurrentDate();
    	solarweekdays[1] = DateUtils.addDay(solarweekdays[0], 1);

    	lunarweekdays[0] = PsnmUtils.getLunarDate(solarweekdays[0]);
    	lunarweekdays[1] = PsnmUtils.getLunarDate(solarweekdays[1]);

    	solarweekdays[0] = solarweekdays[0].substring(4);
    	solarweekdays[1] = solarweekdays[1].substring(4);

    	lunarweekdays[0] = lunarweekdays[0].substring(4);
    	lunarweekdays[1] = lunarweekdays[1].substring(4);

    	requestData.putField("SOLAR_DAYS", solarweekdays);
    	requestData.putField("LUNAR_DAYS", lunarweekdays);

		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMAIN001.dSearchWhoBorn", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]담보만료정보조회 - 에이전트인경우
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-30 11:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMrtgExpir(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMAIN001.dSearchMrtgExpir", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]담보만료정보등록|수정
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-09 10:50:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dMergeMrtgExpir(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DMAIN001.dMergeMrtgExpir", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]본인확인결과갱신
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-10 13:19:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateNameCheck(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DMAIN001.dUpdateNameCheck", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]회원가입요청건수조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-23 11:42:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchUserScrbReqCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord map = this.dbSelectSingle("DMAIN001.dSearchUserScrbReqCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
		return responseData;
	}

	/**
	 * [DM]에이전트계약건수조회(요청|접수)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:00:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchAgentCntrtCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		String duty = PsnmUtils.getSessionValue(onlineCtx, "DUTY"); //직무코드(01~20)
		int iDuty = 0; //직무코드(정수형)
		try {
			iDuty = Integer.parseInt(duty);
		}
		catch (Exception e) {
			iDuty = 0;
		}

		if ( 14<=iDuty ) { //DSM 국장 이하 ...
			requestData.putField("HDQT_PART_ORG_ID", PsnmUtils.getSessionValue(onlineCtx, "HDQT_PART_ORG_ID"));
			requestData.putField("SALE_DEPT_ORG_ID", PsnmUtils.getSessionValue(onlineCtx, "SALE_DEPT_ORG_ID"));
			if ( 16<=iDuty ) { //DSM 팀장 ..
				requestData.putField("SALE_TEAM_ORG_ID", PsnmUtils.getSessionValue(onlineCtx, "SALE_TEAM_ORG_ID"));
			}
		}
		
		IRecord map = this.dbSelectSingle("DMAIN001.dSearchAgentCntrtCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
		return responseData;
	}

	/**
	 * [DM]쪽지수+사진정보+명언
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-24 15:11:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchPaperPhrsPicFile(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord map = this.dbSelectSingle("DMAIN001.dSearchPaperPhrsPicFile", requestData.getFieldMap(), onlineCtx);
		if (null==map) {
			map = this.dbSelectSingle("DMAIN001.dSearchPhrs", requestData.getFieldMap(), onlineCtx);
			map.put("RCV_PAPER_CNT", 0);
		}
		responseData.putFieldMap(map);
		return responseData;
	}

	/**
	 * [DM]DFAX건수
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-10 18:18:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchDfaxCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord map = this.dbSelectSingle("DMAIN001.dSearchDfaxCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
		return responseData;
	}

}

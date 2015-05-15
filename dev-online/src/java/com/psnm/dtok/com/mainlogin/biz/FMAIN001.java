package com.psnm.dtok.com.mainlogin.biz;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmUtils;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.IUserInfo;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.DateUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FMAIN001</li>
 * <li>설  명 : 메인조회</li>
 * <li>작성일 : 2014-12-17 14:04:32</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FMAIN001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMAIN001(){
		super();
	}

	/**
	 * 메인용 공지목록 등 각종 정보 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:04:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMain1(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		//Log log = getLog(onlineCtx);
		IUserInfo iUserInfo = onlineCtx.getUserInfo();

	    try {
	    	DMAIN001 du = (DMAIN001) lookupDataUnit(DMAIN001.class);
	    	DMAIN002 duAnnce = (DMAIN002) lookupDataUnit(DMAIN002.class);

		    //#1. 메인AD
	    	IRecordSet gridmainad = duAnnce.dSearchMainad(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridmainad", gridmainad);

	    	//#2. 공지목록 
		    IRecordSet gridannce = duAnnce.dSearchAnnceList(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridannce", gridannce);

		    //#3. 주요일정
		    IRecordSet gridsch = du.dSearchSchList(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridsch", gridsch);
		    
		    //#4. 받은쪽지개수, 이미지파일정보, 명언정보 : (참고) 기존 3개의 쿼리를 하나로 합침
		    IDataSet dsPapPhrsPicFile = du.dSearchPaperPhrsPicFile(requestData, onlineCtx);
		    responseData.putFieldMap( dsPapPhrsPicFile.getFieldMap() );

		    //#6. 사용자별 각종 여부 조회: CPLAZA_YN, DSMUSER_YN, CERT_YN, PWDUPD_YN, ANNCE_POP_YN
		    IRecordSet rsUserYn = du.dSearchUserYn(requestData, onlineCtx).getRecordSet("ds");
		    if ( null!=rsUserYn && rsUserYn.getRecordCount()>0 ) {
		    	String cplazaOrgCd = (String)iUserInfo.get("CPLAZA_ORG_CD");
		    	String cplazaYn = rsUserYn.get(0, "CPLAZA_YN");

		    	responseData.putField("CPLAZA_YN",  cplazaYn);
		    	responseData.putField("DSMUSER_YN", rsUserYn.get(0, "DSMUSER_YN"));
		    	responseData.putField("CERT_YN",    rsUserYn.get(0, "CERT_YN"));
		    	responseData.putField("ANNCE_POP_YN",   rsUserYn.get(0, "ANNCE_POP_YN"));   //팝업공지(우선)
		    	responseData.putField("ANNCE_MNDT_CNT", rsUserYn.get(0, "ANNCE_MNDT_CNT")); //필수확인공지개수(차우선) : (참고) 조회시 팝업기간 조건없음
		    	responseData.putField("NEED_TO_CHANGE_PWD", rsUserYn.get(0, "NEED_TO_CHANGE_PWD")); //비밀번호필수변경여부

		    	//담보만료정보 조회
		    	if ( StringUtils.equals("Y", cplazaYn) && StringUtils.isNotBlank(cplazaOrgCd) ) {
		    		IRecordSet gridmrtgexpir = du.dSearchMrtgExpir(requestData, onlineCtx).getRecordSet("ds");
		    		responseData.putRecordSet("gridmrtgexpir", gridmrtgexpir);
		    		responseData.putField("MRTG_CHECK_YN", "Y"); //담보만료정보 체크 필요(화면에서 체크하여 팝업을 표시할지 여부 판단하여 처리)
		    	}
		    	else {
		    		responseData.putField("MRTG_CHECK_YN", "N");
		    	}
		    }

		    //#7. 이미지공지사항
		    IRecordSet gridanncepic = duAnnce.dSearchAnncePic(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridanncepic", gridanncepic); //(차차우선)

		    //#8. 생일자 조회
		    //@since 2015-03-17 ::: 생일자 조직제한, 음력생일등의 설정값 조회는 DM에서 추가로직구현함(FM 분산으로 로직 일원화 위해)
		    IRecordSet gridbirth = du.dSearchWhoBorn(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridbirth", gridbirth);

			//#9. 전체 메뉴목록을 조회하여 반환
		    //@since 2015-03-17 ::: DSM 국장 접속시 부산, 대구 등 지방 조직 메뉴명 안보이게 처리 @see DMENU001#dSearchMenuTree()
		    DMENU001 duMENU = (DMENU001) lookupDataUnit(DMENU001.class);

		    requestData.putField("USER_ID", iUserInfo.getLoginId());
			IRecordSet menulist = duMENU.dSearchMenuTree(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("menulist", menulist);

			String duty = PsnmUtils.getSessionValue(onlineCtx, "DUTY"); //직무코드(01~20)
			int iDuty = 0; //직무코드(정수형)
			try {
				iDuty = Integer.parseInt(duty);
			}
			catch (Exception e) {
				iDuty = 0;
			}

			//10. 회원가입요청건수(임직원인 경우만 조회)
			if ( PsnmUtils.isEmployee(onlineCtx) ) {
				IDataSet dsCnt1 = du.dSearchUserScrbReqCnt(requestData, onlineCtx); //회원가입요청건수
			    responseData.putField("USER_SCRB_REQ_CNT", dsCnt1.getIntField("USER_SCRB_REQ_CNT"));
			}
			else {
				responseData.putField("USER_SCRB_REQ_CNT", "-");
			}

			//11. 에이전트계약요청건수 조회(임직원인 경우만 조회)
			{
			    String cntrtStCd = "1"; //계약상태코드[DSM_CNTRT_ST_CD], 1=요청, 2=접수
			    //if ( StringUtils.equals("14", duty) || StringUtils.equals("16", duty) ) { //14=영엽국장, 16=영엽팀장,
			    if ( iDuty>=14 ) { //14=DSM국장, 15=DSM관리총무, 16=DSM팀장, 17=DSM총무, 18=DSM_MA, 19=DSM팀장(CS), 20=DSM총무(CS)
			    	cntrtStCd = "2";
			    }
			    requestData.putField("CNTRT_ST_CD", cntrtStCd); //조회조건
			    responseData.putField("CNTRT_ST_CD", cntrtStCd); //응답데이터에도 반환

			    IDataSet dsCnt2 = du.dSearchAgentCntrtCnt(requestData, onlineCtx); //에이전트계약요청건수
			    responseData.putField("AGENT_CNTRT_CNT", dsCnt2.getIntField("AGENT_CNTRT_CNT"));
			}

			//12. DFAX건수 조회(임직원||국장인 경우만 조회)
			if ( PsnmUtils.isEmployee(onlineCtx) || StringUtils.equals("14", duty) ) {
				//@see FFAXRCV001#fSearchFaxRcvMobile() : D-FAX접수결과 컴포넌트 참조
				if ( StringUtils.equals("14", duty)) {
					requestData.putField("BIZ_APRV_OP_ST_CD", "01");
				}
				else {
					requestData.putField("BIZ_APRV_OP_ST_CD", "03");
				}
			    IDataSet dsCnt3 = du.dSearchDfaxCnt(requestData, onlineCtx); //에이전트계약요청건수
			    responseData.putField("DFAX_CNT", dsCnt3.getIntField("DFAX_CNT"));
			}
			else {
				responseData.putField("DFAX_CNT", "-");
			}
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 공지사항, 첨부파일, 댓글목록을 조회하여 반환
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 16:34:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		requestData.putField("FILE_GRP_ID", "ANN");
		//requestData.putField("DSM_CONT_ID", requestData.getField("ANNCE_ID"));
		Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<<공지사항>> 입력파라미터 : " + requestData.getFieldMap());
		}

		try {
	    	DMAIN002 du = (DMAIN002) lookupDataUnit(DMAIN002.class);

	    	//#1. 공지사항 조회(1건) : fieldmap
	    	responseData = du.dSearchAnnce(requestData, onlineCtx);

	    	//#2. 첨부파일
	    	IDataSet afileData = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
	    	IRecordSet gridfile = afileData.getRecordSet("ds");
	    	responseData.putRecordSet("gridfile", gridfile);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 받은쪽지개수조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-19 15:04:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchRcvPaperCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	DMAIN001 du = (DMAIN001) lookupDataUnit(DMAIN001.class);
		    //받은쪽지개수조회 (참고) 필드맵 'RCV_PAPER_CNT' 로 저장하여 반환
	    	responseData =  du.dSearchRcvPaperCount(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]팝업공지목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:04:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnncePopList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	//DMAIN001 du = (DMAIN001) lookupDataUnit(DMAIN001.class);
	    	DMAIN002 du2 = (DMAIN002) lookupDataUnit(DMAIN002.class);

	    	//1. 팝업 공지 목록
	    	IRecordSet gridanncepop = du2.dSearchAnncePopList(requestData, onlineCtx).getRecordSet("ds");

	    	responseData.putRecordSet("gridanncepop", gridanncepop);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]필수확인공지목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-27 10:59:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnceMndtList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	//DMAIN001 du = (DMAIN001) lookupDataUnit(DMAIN001.class);
	    	DMAIN002 du2 = (DMAIN002) lookupDataUnit(DMAIN002.class);

	    	//2. 필수확인 공지목록
	    	IRecordSet gridanncemndt = du2.dSearchAnnceMndtList(requestData, onlineCtx).getRecordSet("ds");

	    	responseData.putRecordSet("gridanncemndt", gridanncemndt);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]담보만료정보등록|수정 - 재계약여부
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-09 10:52:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fMergeMrtgExpir(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<담보만료정보등록|수정>> 입력파라미터 : " + requestData.getFieldMap());
		}
		try {
	    	DMAIN001 du1 = (DMAIN001) lookupDataUnit(DMAIN001.class);

	    	responseData = du1.dMergeMrtgExpir(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]본인확인결과갱신
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-10 13:19:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateNameCheck(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<본인확인결과갱신>> 입력파라미터 : " + requestData.getFieldMap());
		}
		try {
	    	DMAIN001 du1 = (DMAIN001) lookupDataUnit(DMAIN001.class);

	    	responseData = du1.dUpdateNameCheck(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]금주의생일자목록(팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-12 10:21:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchWhoBorn(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

	    try {
	    	DMAIN001 du1 = (DMAIN001) lookupDataUnit(DMAIN001.class);

	    	if ( ! requestData.containsField("LIST_COUNT") ) {
	    		requestData.putField("LIST_COUNT", 50); //최대50건 조회
	    	}
	    	if ( requestData.containsField("DAY_OFFSET") ) {
	    		int dayOffset = requestData.getIntField("DAY_OFFSET");
	    		String todayYmd = DateUtils.getCurrentDate();
	    		String solarDate = DateUtils.addDay(todayYmd, dayOffset);
	    		String lunarDate = PsnmUtils.getLunarDate(solarDate);

	    		requestData.putField("THE_SOLAR_MD", solarDate.substring(4));
	    		requestData.putField("THE_LUNAR_MD", lunarDate.substring(4));
	    	}
			if ( log.isDebugEnabled() ) {
				log.debug("<<생일자목록>> 입력파라미터 : " + requestData.getFieldMap());
			}

	    	//금주의생일자 목록
	    	IRecordSet gridborn = du1.dSearchWhoBorn(requestData, onlineCtx).getRecordSet("ds");

	    	responseData.putRecordSet("gridborn", gridborn);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

}

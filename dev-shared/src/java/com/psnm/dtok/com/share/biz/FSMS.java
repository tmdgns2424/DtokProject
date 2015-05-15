package com.psnm.dtok.com.share.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.DateUtils;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FSMS</li>
 * <li>설  명 : [FU]SMS전송관리</li>
 * <li>작성일 : 2015-01-12 20:13:34</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FSMS extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSMS(){
		super();
	}

	private boolean canSendTkeySms(IOnlineContext onlineCtx, Map<String,Object> smsmap, String sndMsg) {
		UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
		String userId = null==userInfo ? null : userInfo.getLoginId();
		String telCoCd = (String)smsmap.get("TEL_CO_CD");
		String tranSys = (String)smsmap.get("TRAN_SYS");

		//0. 전송시스템을 명시적으로 지정하였으면 해당 시스템으로 전송함(@since 2015-04-13)
		if ( StringUtils.isNotBlank(tranSys) ) {
			if ( StringUtils.equalsIgnoreCase("TKEY", tranSys) ) {
				return true;
			}
			else if ( StringUtils.equalsIgnoreCase("BO", tranSys) ) {
				return false;
			}
		}

		//1. 미로그인 상태면, TKEY SMS 전송불가
		if (null==userId || StringUtils.equalsIgnoreCase("Anonymous", userId)) {
			return false;
		}

		//2. 이동통신사코드가 'SKT'가 아니면, TKEY SMS 전송불가
		if ( !StringUtils.equals("SKT", telCoCd) ) {
			return false;
		}

		//3. SMS 발송메시지가 80바이트 초과이면, TKEY SMS 전송불가
		if ( StringUtils.isBlank(sndMsg) || sndMsg.getBytes().length > 80 ) {
			return false;
		}
		
		//4. BO 시스템으로 명시적우로 발송하고 싶을때
		if ( StringUtils.equalsIgnoreCase("BO", tranSys) ) {
			return false;
		}

		return true;
	}

	private IDataSet _send_sms_BO1(Map<String, Object> smsmap, int idxBO, Log log, DSMS002 du2, IOnlineContext onlineCtx) {
		IDataSet responseData = null;

		if ( log.isDebugEnabled() ) {
			log.debug("<<SMS전송(백오피스)>> SMS전송데이터 : " + smsmap);
		}

		//smsmap :: USER_ID, SMS_RCV_YN, TEL_CO_CD, SNS_PHN_ID, RCV_PHN_ID, SND_MSG, SND_DT(=YYYYMMDD), SND_TM(=HHMMSS)

	    try {
	    	IDataSet dsParam = new DataSet();

		    String CONTENT_MIME_TYPE = "";
		    String CONTENT_CNT = "0"; //SMS
		    String USED_CD     = "00"; //SMS
		    String SND_MSG     = (String)smsmap.get("SND_MSG");
		    String USR_ID      = "psm3"; //운영일때는 'psm3', 개발일때는 'psm3_test'로 설정해야 실제로 전송됨

		    if ( SND_MSG.getBytes().length > 79 ) {
		    	USED_CD = "10"; //LMS
		    	CONTENT_CNT = "1";
		    	CONTENT_MIME_TYPE = "text/plain";
		    }
		    if ( ! "R".equals(nexcore.framework.core.util.BaseUtils.getRuntimeMode()) ) {
		    	USR_ID      = "psm3_test";
		    }

		    smsmap.put("CONTENT_MIME_TYPE", CONTENT_MIME_TYPE);
		    smsmap.put("CONTENT_CNT", CONTENT_CNT);
		    smsmap.put("USED_CD", USED_CD);
		    smsmap.put("USR_ID", USR_ID);

    		dsParam.putFieldMap( smsmap );
    		dsParam.putField("SND_SEQ", idxBO); //(참조) SMS발송이력.발송순번

    		//2. SMS큐 등록
    		responseData = du2.dInsertPsnmsmsQueue(dsParam, onlineCtx);

    		/* OLD
    		//3. SMS발송정보 등록(1회)
    		if (1==idxBO) {
    			du2.dInsertSysMsgSnd(dsParam, onlineCtx);
    		}

    		//4. SMS발송이력정보 등록(이력)
    		du2.dInsertSysMsgSndHst(dsParam, onlineCtx);
    		*/ 
	    }
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
	    	log.error("<<SMS전송(백오피스)>> SMS전송데이터 : " + smsmap);
	    	log.error("<<SMS전송(백오피스)>> 원인 : " + e.getMessage());
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	private IDataSet _send_sms_TK1(Map<String, Object> smsmap, int idxTK, Log log, DSMS001 du1, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		if ( log.isDebugEnabled() ) {
			log.debug("<<SMS전송(TKEY)>> SMS전송데이터 : " + smsmap);
		}

		//smsmap :: USER_ID, SMS_RCV_YN, TEL_CO_CD, SNS_PHN_ID, RCV_PHN_ID, SND_MSG, SND_DT(=YYYYMMDD), SND_TM(=HHMMSS), TRAN_CNT

	    try {
	    	IDataSet dsParam = new DataSet();

	    	//1. SMS전송차수 시퀀스(TRAN_CNT)는 이 함수룰 호출하는 측에서 조회하여  smsmap 에 넣어둠

	    	//
    		dsParam.putFieldMap( smsmap );
    		dsParam.putField("SEQ", 1+idxTK); //(참조) SMS거래정보 등록(상세)

    		//2. SMS거래정보 등록(1회)
    		if (0==idxTK) {
    			du1.dInsertSmsTran(dsParam, onlineCtx); 
    		}

    		//3. SMS거래정보 등록(상세)
    		du1.dInsertSmsTranDtl(dsParam, onlineCtx); 

    		//4. 메시지고유ID 시퀀스 채번
    		IDataSet dsMsgSeq = du1.dSearchNextCmpMsgSeq(new DataSet(), onlineCtx); //CMP_MSG_ID
    		dsParam.putField("CMP_MSG_ID", dsMsgSeq.getField("CMP_MSG_ID"));

    		//5. 메시지 전송정보 등록
    		du1.dInsertTelinkSms(dsParam, onlineCtx);
	    }
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
	    	log.error("<<SMS전송(TKEY)>> SMS전송데이터 : " + smsmap);
	    	log.error("<<SMS전송(TKEY)>> 원인 : " + e.getMessage());
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	

	/**
	 * [FM]SMS전송 : 필드맵 { TRAN_MENU_ID, TRAN_TYP_CD } 필수, 'ds' 레코드셋 [ USER_ID, RCV_PHN_ID, {0}, {1}, {2} ]
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 20:13:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSendSms(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("<<SMS전송>> 입력파라미터 : " + requestData.getFieldMap());
		}

		//사용자ID
		UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
		String userId = null==userInfo ? null : userInfo.getLoginId();
		if (null==userId || StringUtils.equalsIgnoreCase("Anonymous", userId)) {
			userId = requestData.getField("USER_ID");
		}

		String tranMenuId = requestData.getField("TRAN_MENU_ID");
		String tranTypCd  = requestData.getField("TRAN_TYP_CD");
		String tranSys    = requestData.getField("TRAN_SYS");

		IRecordSet rsSMS = requestData.getRecordSet("ds"); //(화면에서 전달된) 발송할 SMS 정보 목록
    	int len = null==rsSMS ? 0 : rsSMS.getRecordCount();
    	if ( log.isDebugEnabled() ) {
			log.debug("<<SMS전송>> 입력레코드셋(ds) 개수 : " + len);
		}

	    try {
	    	DSMS001 du1 = (DSMS001) lookupDataUnit(DSMS001.class);
	    	DSMS002 du2 = (DSMS002) lookupDataUnit(DSMS002.class);

	    	IDataSet _param = new DataSet();

	    	int idxTK = 0; //TKEY 전송시 index
	    	int idxBO = 0; //BO 전송시 index
	    	Object tkTranCnt = null;

	    	String sndDt = DateUtils.getCurrentDate("yyyyMMdd");
	    	String sndTm = DateUtils.getCurrentDate("HHmmss");

	    	for(int i=0; i<len; i++) {
	    		//USER_ID[, RCV_PHN_ID, ARG0, ARG1, ARG2]
	    		Map<String,Object> smsmap = rsSMS.getRecordMap(i);

	    		smsmap.put("TRAN_MENU_ID", tranMenuId);
	    		smsmap.put("TRAN_TYP_CD", tranTypCd);
	    		if ( !smsmap.containsKey("TRAN_SYS") ) { //레코드셋에 'TRAN_SYS'가 없을때에만 필드셋의 'TRAN_SYS'값을 적용
	    			smsmap.put("TRAN_SYS", StringUtils.isBlank(tranSys) ? "" : tranSys); //'BO' 설정만 허용 : BO시스템으로 명시적으로 SMS발송
	    		}

	    		_param.putFieldMap( smsmap );

	    		if ( log.isDebugEnabled() ) {
					log.debug("<<SMS전송>> 입력레코드[" + i + "] :: " + smsmap);
				}

	    		String absn = (String)smsmap.get("ABSN_CHECK_YN"); //담당자부재중체크여부

	    		if ( StringUtils.equalsIgnoreCase("1", absn) || StringUtils.equalsIgnoreCase("Y", absn) || StringUtils.equalsIgnoreCase("true", absn) ) {
	    			String isAbsn = du1.dSearchChrgrOpAbsn(_param, onlineCtx).getField("IS_ABSN");
	    			if ( !StringUtils.equals("0", isAbsn) ) {
	    				log.info("<<SMS전송>> 담당자 [" + smsmap.get("USER_ID") + "]는 현재 부재중입니다. SMS를 발송하지 않습니다.");
	    				continue;
	    			}
	    		}

	    		//1. SMS기본정보 조회 :: USER_ID, SMS_RCV_YN, TEL_CO_CD, SND_PHN_ID, RCV_PHN_ID, SND_MSG, SND_DT(=YYYYMMDD), SND_TM(=HHMMSS)
		    	IDataSet _smsinfo = du1.dSearchSmsInfoByUser(_param, onlineCtx);
		    	if ( null==_smsinfo ) {
		    		continue;
		    	}

		    	String sndMsgProto = _smsinfo.getField("SND_MSG");
		    	if ( null==sndMsgProto || StringUtils.isBlank(sndMsgProto) ) {
		    		continue;
		    	}

		    	String sndMsg = PsnmStringUtil.replaceArgs(sndMsgProto, smsmap);

		    	if ( StringUtils.isBlank(sndMsg) ) {
		    		log.warn("<<SMS전송>> SMS메시지 없음! blank SND_MSG");
		    		log.warn("<<SMS전송>> SMS메시지 없음! 입력레코드[" + i + "] :: " + smsmap + "\n조회된SMS정보[" + i + "] :: " + _smsinfo.getFieldMap());
		    		continue;
				}

		    	//USER_ID, SMS_RCV_YN, TEL_CO_CD, SND_PHN_ID, RCV_PHN_ID, SND_MSG, SND_DT(=YYYYMMDD), SND_TM(=HHMMSS)
		    	smsmap.putAll( _smsinfo.getFieldMap() );
		    	smsmap.put("SND_MSG", sndMsg);
		    	smsmap.put("SND_DT", sndDt); //=YYYYMMDD 
		    	smsmap.put("SND_TM", sndTm); //=HHMMSS

		    	if ( this.canSendTkeySms(onlineCtx, smsmap, sndMsg) ) {
		    		//TKEY 테이블에 등록
		    		if (0==idxTK) {
		    	    	//1. TKEY의 SMS전송차수 시퀀스조회
		    	    	IDataSet dsTran = du1.dSearchNextTranSeq(new DataSet(), onlineCtx); //TRAN_CNT
		    	    	tkTranCnt = dsTran.getField("TRAN_CNT");
		    		}
		    		smsmap.put("TRAN_CNT", tkTranCnt);
		    		this._send_sms_TK1(smsmap, idxTK++, log, du1, onlineCtx);
		    	}
		    	else {
		    		//백오피스(LMS) 테이블에 등록
		    		this._send_sms_BO1(smsmap, ++idxBO, log, du2, onlineCtx);
		    	}
	    	}

	    	//XA롤백테스트
	    	String testMsg = requestData.getField("XA_ROLEBACK_TEST_MSG");
	    	if ( StringUtils.isNotBlank(testMsg) && testMsg.indexOf("에러메시지")>=0 ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{testMsg});
	    	}
	    }
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
	    	log.error("<<SMS전송>> 입력파라미터 : " + requestData.getFieldMap());
	    	log.error("<<SMS전송>> 입력파라미터(ds) : " + rsSMS);
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]SMS발송(직접) - 발송할 문자(SND_MSG), 발송대상번호로 SMS를 바로 발송함.
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-03 11:16:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSendSmsDirectly(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		Map<String,Object> reqmap = requestData.getFieldMap();
		
        if ( log.isDebugEnabled() ) {
            log.debug("<<SMS직접발송>> 입력파라미터(필드맵) : " + reqmap);
        }

        //사용자ID
        UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
        String userId = null==userInfo ? null : userInfo.getLoginId();
        if (null==userId || StringUtils.equalsIgnoreCase("Anonymous", userId)) {
            userId = requestData.getField("USER_ID");
        }

        String sndMsg   = requestData.getField("SND_MSG");    //발소메시지
        String sndPhnId = requestData.getField("SND_PHN_ID"); //발송전화번호
        String sndDt    = requestData.getField("SND_DT");     //발송일자(=YYYYMMDD)
        String sndTm    = requestData.getField("SND_TM");     //발송시각(=HHMMSS)
        String tranSys  = requestData.getField("TRAN_SYS");   //발송시스템(BO이면 무조건 백오피스 시스템이용하여 전송)

        if ( StringUtils.isBlank(sndDt) ) {
        	sndDt = DateUtils.getCurrentDate("yyyyMMdd");
        }
        if ( StringUtils.isBlank(sndTm) ) {
        	sndTm = DateUtils.getCurrentDate("HHmmss");
        }

        if ( StringUtils.isBlank(tranSys) || ! StringUtils.equalsIgnoreCase(tranSys, "BO")  ) {
        	//BO 시스템으로 명시적으로 발송하는 경우가 아니면, 메시지의 길이에 따라 발송할 시스템 결정함.
    		//SMS 발송메시지가 80바이트 초과이면, TKEY SMS 전송불가
    		if ( StringUtils.isBlank(sndMsg) || sndMsg.getBytes().length > 80 ) {
    			tranSys = "BO";
    		}
    		else {
    			tranSys = "TK";
    		}
        }

        IRecordSet rsPhnList = requestData.getRecordSet("ds"); //(화면에서 전달된) 발송할 SMS 정보 목록
        int lenPhnList = null==rsPhnList ? 0 : rsPhnList.getRecordCount();
        if ( log.isDebugEnabled() ) {
            log.debug("<<SMS직접발송>> 입력레코드셋(ds) 개수 : " + lenPhnList);
        }

        try {
            DSMS001 du1 = (DSMS001) lookupDataUnit(DSMS001.class);
            DSMS002 du2 = (DSMS002) lookupDataUnit(DSMS002.class);

            int idxTK = 0; //TKEY 전송시 index
            int idxBO = 0; //BO 전송시 index
            Object tkTranCnt = null; //TKEY 전송시 SMS직접발송차수

            for(int i=0; i<lenPhnList; i++) {
                Map<String,Object> smsmap = rsPhnList.getRecordMap(i); //RCV_PHN_ID[, USER_ID, USER_NM]

                smsmap.put("SND_MSG",    sndMsg);
                smsmap.put("SND_PHN_ID", sndPhnId);
                smsmap.put("SND_DT",     sndDt);
                smsmap.put("SND_TM",     sndTm);

                if ( log.isDebugEnabled() ) {
                    log.debug("<<SMS직접발송>> SMS발송정보[" + i + "] : " + smsmap);
                    //SND_PHN_ID, RCV_PHN_ID, SND_MSG, SND_DT, SND_TM[, USER_ID, USER_NM]
                }

                if ( StringUtils.equalsIgnoreCase(tranSys, "TK") ) { //TKEY 테이블에 등록
                    if (0==idxTK) {
                        //1. TKEY의 SMS직접발송차수 시퀀스조회
                        IDataSet dsTran = du1.dSearchNextTranSeq(new DataSet(), onlineCtx); //TRAN_CNT
                        tkTranCnt = dsTran.getField("TRAN_CNT");
                    }
                    smsmap.put("TRAN_CNT", tkTranCnt);
                    this._send_sms_TK1(smsmap, idxTK++, log, du1, onlineCtx);
                }
                else {
                    //백오피스(LMS) 테이블에 등록
                    this._send_sms_BO1(smsmap, idxBO++, log, du2, onlineCtx);
                }
            }
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            log.error("<<SMS직접발송>> 입력파라미터 : " + requestData.getFieldMap());
            log.error("<<SMS직접발송>> 입력파라미터(ds) : " + rsPhnList);
            throw new BizRuntimeException("PSNM-E000", e);
        }
        responseData.setOkResultMessage("PSNM-I000", null);
        return responseData;
	}

	/**
	 * [FM]SMS발송건수조회 : 발신년월(디폴트 이번달), 발신번호 조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-04 10:51:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSmsCount(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        Log log = getLog(onlineCtx);

        Map<String,Object> reqmap = requestData.getFieldMap();

        if ( log.isDebugEnabled() ) {
            log.debug("<<SMS발송건수>> 입력파라미터(필드맵) : " + reqmap);
        }

        //사용자ID
        UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
        String userId = null==userInfo ? null : userInfo.getLoginId();
        if (null==userId || StringUtils.equalsIgnoreCase("Anonymous", userId)) {
            userId = requestData.getField("USER_ID");
        }

        String sndPhnId = requestData.getField("SND_PHN_ID"); //발송전화번호 조건
        String sndDt    = requestData.getField("SND_DT");     //발송일자 조건 (LIKE) : YYYY, YYYYMM, YYYYMMDD 모두 가능

        if ( StringUtils.isBlank(sndPhnId) ) {
        	sndPhnId = userInfo.getString("MBL_PHON"); //디폴트 현재 사용자의 전화번호(TBAS_USER_MGMT.MBL_PHON)
        }
        if ( StringUtils.isBlank(sndDt) ) {
            sndDt = DateUtils.getCurrentDate("yyyyMM"); //디폴트 이번달
        }

        IDataSet dsParam = new DataSet();

		dsParam.putField("SND_PHN_ID",  sndPhnId);
		dsParam.putField("SND_DT",      sndDt);
		dsParam.putField("SND_USER_ID", userId);

        int tkeyCount = 0;
		int boCount   = 0;

		//1. T-KEY 전송건수 조회
        try {
            DSMS001 du1 = (DSMS001) lookupDataUnit(DSMS001.class);

    		IDataSet ds1 = du1.dSearchSmsCount(dsParam, onlineCtx);
    		tkeyCount = ds1.getIntField("CNT");
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            log.error("<<SMS발송건수>> 입력파라미터(실제입력) : " + reqmap);
            log.error("<<SMS발송건수>> 입력파라미터(조회입력) : " + dsParam.getFieldMap());
            //throw new BizRuntimeException("PSNM-E000", e);
        }
        //2. BO(백오피스) 전송건수 조회
        try {
            DSMS002 du2 = (DSMS002) lookupDataUnit(DSMS002.class);
    		IDataSet ds2 = du2.dSearchBoSmsCount(dsParam, onlineCtx);
    		boCount = ds2.getIntField("CNT");
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            log.error("<<SMS발송건수>> 입력파라미터 : " + reqmap);
            log.error("<<SMS발송건수>> 입력파라미터(조회입력) : " + dsParam.getFieldMap());
            //throw new BizRuntimeException("PSNM-E000", e);
        }
        responseData.putField("CNT_TK", tkeyCount); //TKEY로 발송한 건수
        responseData.putField("CNT_BO", boCount); //BO로 발송한 건수
        responseData.putField("CNT",    (tkeyCount+boCount)); //SMS전체발송건수
        responseData.setOkResultMessage("PSNM-I000", null);
        return responseData;
	}

}

package com.psnm.dtok.com.mainlogin.biz;

import java.util.HashMap;
import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.data.RecordHeader;
import nexcore.framework.core.data.RecordSet;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.DataSetUtils;

import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmNumberUtil;
import com.psnm.common.util.PsnmStringUtil;
import com.psnm.common.util.PsnmUtils;
import com.psnm.common.util.SHA256SaltHash;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FUSER001</li>
 * <li>설  명 : [FU]공통회원관리</li>
 * <li>작성일 : 2015-01-09 15:07:19</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FUSER001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FUSER001(){
		super();
	}

	/**
	 * [FM]회원ID조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-09 15:20:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserId(IDataSet requestData, IOnlineContext onlineCtx) {
		DataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<회원ID조회>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DUSER001 du = (DUSER001) lookupDataUnit(DUSER001.class);

		    IRecordSet list = du.dSearchUserId(requestData, onlineCtx).getRecordSet("ds"); //목록 조회
		    int cnt = null==list ? 0 : list.getRecordCount();

		    if (0==cnt) {
		    	log.error("<<회원임시비밀번호>> 조회된 회원정보 건수 : " + cnt);
		    	throw new BizRuntimeException("PSNM-E011", new String[]{"검색된 회원정보 "}); //"{0} 데이터가 없습니다!"
		    }
		    if (1<cnt) {
		    	log.error("<<회원임시비밀번호>> 조회된 회원정보 건수 : " + cnt);
		    	throw new BizRuntimeException("PSNM-E019", new String[]{"중복된 ", "회원ID를 확인"}); //"{0} 데이터가 있습니다. {1} 할 수 없습니다!"
		    }

		    responseData.putField("USER_ID",   list.get(0, "USER_ID"));
		    responseData.putField("USER_ID_M", list.get(0, "USER_ID_M")); //마스킹된 회원ID
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
	 * [PM]회원임시비밀번호
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-09 15:07:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateTempPwd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<회원임시비밀번호>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DUSER001 du = (DUSER001) lookupDataUnit(DUSER001.class);

	    	//1. 회원정보 확인
		    IRecordSet list = du.dSearchUserId(requestData, onlineCtx).getRecordSet("ds"); //목록 조회
		    int cnt = null==list ? 0 : list.getRecordCount();

		    if (0==cnt) {
		    	log.error("<<회원임시비밀번호>> 조회된 회원정보 건수 : " + cnt);
		    	throw new BizRuntimeException("PSNM-E011", new String[]{"검색된 회원정보 "}); //"{0} 데이터가 없습니다!"
		    }
		    if (1<cnt) {
		    	log.error("<<회원임시비밀번호>> 조회된 회원정보 건수 : " + cnt);
		    	throw new BizRuntimeException("PSNM-E019", new String[]{"중복된 ", "회원ID를 확인"}); //"{0} 데이터가 있습니다. {1} 할 수 없습니다!"
		    }

		    String attcCat = list.get(0, "ATTC_CAT");
		    if ( PsnmUtils.isEmployee(attcCat) ) {
		    	log.error("<<회원임시비밀번호>> 임직원 변경 불가 : ATTC_CAT = " + attcCat);
		    	throw new BizRuntimeException("PSNM-E003", new String[]{"(안내) 임직원 변경 불가"}); //비밀번호를 변경할 수 없습니다. {0}
		    }

		    //2. 임시비밀번호 생성
	    	StringBuffer _pwd = new StringBuffer();
	    	for (int i=1; i<=6; i++) {
	    		if ( 0==i%3 ) {
	    			_pwd.append( PsnmNumberUtil.getRandomNum(0, 9) ); //숫자
	    		}
	    		else {
	    			_pwd.append( PsnmStringUtil.getRandomStr('a', 'z') ); //소문자
	    		}
	    	}
	    	String pwd = SHA256SaltHash.encode( _pwd.toString(), requestData.getField("USER_ID") );

	    	requestData.putField("PWD", pwd); 

	    	du.dUpdateTempPwd(requestData, onlineCtx);

	    	//3. SMS 발송
	    	requestData.putField("PWD", _pwd.toString());

	    	//[FM]SMS전송 : 필드맵 { TRAN_MENU_ID, TRAN_TYP_CD } 필수, 'ds' 레코드셋 { USER_ID, RCV_PHN_ID, {0}, {1}, {2}, ... }
	    	IDataSet _ds_sms = du.dSearchSmsRecordSet(requestData, onlineCtx);
	    	_ds_sms.putField("TRAN_MENU_ID", "0000");
	    	_ds_sms.putField("TRAN_TYP_CD", "01");
	    	_ds_sms.putField("TRAN_SYS", "BO");

	    	log.debug("<<회원임시비밀번호>> ++++++++\n" + _ds_sms);

	    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
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

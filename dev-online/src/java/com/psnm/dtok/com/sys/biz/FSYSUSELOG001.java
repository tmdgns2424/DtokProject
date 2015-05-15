package com.psnm.dtok.com.sys.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FSYSUSELOG001</li>
 * <li>설  명 : [FU]시스템사용로그</li>
 * <li>작성일 : 2015-02-24 16:42:04</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FSYSUSELOG001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSYSUSELOG001(){
		super();
	}

	/**
	 * [FM]시스템사용로그등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-24 16:42:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSysUseLog(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    Log log = getLog(onlineCtx);
	    if (log.isDebugEnabled()) {
			log.debug("<<시스템사용로그등록>> 입력파라미터정보 : " + requestData.getFieldMap());
		}

	    try {
	    	DSYSUSELOG001 du = (DSYSUSELOG001)lookupDataUnit(DSYSUSELOG001.class);

	    	responseData = du.dInsertSysUseLog(requestData, onlineCtx);
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

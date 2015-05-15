package com.psnm.dtok.com.sys.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PSYSUSELOG001</li>
 * <li>설  명 : [PU]시스템사용로그</li>
 * <li>작성일 : 2015-02-24 16:46:13</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PSYSUSELOG001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSYSUSELOG001(){
		super();
	}

	/**
	 * [PM]시스템사용로그등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-24 16:46:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertSysUseLog(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FSYSUSELOG001 fu = (FSYSUSELOG001) lookupFunctionUnit(FSYSUSELOG001.class);
			fu.fInsertSysUseLog(requestData, onlineCtx);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000",e);
		}
	    return responseData;
	}
  
}

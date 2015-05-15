package com.psnm.dtok.com.phrs.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PPHRS001</li>
 * <li>설  명 : 명언관리PU</li>
 * <li>작성일 : 2015-01-05 15:18:05</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class PPHRS001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PPHRS001(){
		super();
	}

	/**
	 * 명언 정보를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-05 16:09:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchPhrs(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    try{
	    	FPHRS001 fu = (FPHRS001) lookupFunctionUnit(FPHRS001.class);
	    	responseData = fu.fSearchPhrs(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);
			
	    } catch (BizRuntimeException be) {
			throw be;
	    } catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
	    }
	    return responseData;
	}
	

	/**
	 * 명언정보를 관리하는 메소드( Update만 )
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-05 16:09:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSavePhrs(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
	    	FPHRS001 fu = (FPHRS001) lookupFunctionUnit(FPHRS001.class);
	    	responseData = fu.fSavePhrs(requestData, onlineCtx);
	    	responseData.setOkResultMessage("PSNM-I000", null);
			
	    } catch (BizRuntimeException be) {
			throw be;
	    } catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}
  
}

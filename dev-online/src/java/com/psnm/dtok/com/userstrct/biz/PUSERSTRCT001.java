package com.psnm.dtok.com.userstrct.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [PU]모드관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-27 09:52:03</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class PUSERSTRCT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PUSERSTRCT001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet pSearchUseRstrctMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
			 IDataSet responseData = new DataSet();
	
			    try{
			    	FUSERSTRCT001 fu = (FUSERSTRCT001) lookupFunctionUnit(FUSERSTRCT001.class);
			    	responseData = fu.fSearchUseRstrctMgmt(requestData, onlineCtx);
					responseData.setOkResultMessage("PSNM-I000", null);
					
			    } catch (BizRuntimeException be) {
					throw be;
			    } catch (Exception e) {
					throw new BizRuntimeException("PSNM-E000", e);
			    }
			    return responseData;
			}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet pSearchDay(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		
			
			try {
				FUSERSTRCT001 fu = (FUSERSTRCT001) lookupFunctionUnit(FUSERSTRCT001.class);
			
				responseData = fu.fSearchDay(requestData, onlineCtx);
				
				IRecordSet rs = responseData.getRecordSet("ds");
				
				responseData.putRecordSet("resultList", rs);
				responseData.setOkResultMessage("PSNM-I000", null);
				
			} catch (BizRuntimeException be) {
				throw be;
			} catch (Exception e) {
				throw new BizRuntimeException("PSNM-E000", e);
			} 
		
		
		    return responseData;
		}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet pSearchToDay(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		    
		    DUSERSTRCT001 du = (DUSERSTRCT001) lookupDataUnit(DUSERSTRCT001.class);
		    String DOW_CL = du.dSearchToDay(requestData, onlineCtx).getField("DOW_CL");
		    responseData.putField("DOW_CL", DOW_CL);
		    
		    return responseData;
		}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet pSaveUseRstrctMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		
			 try {
		    	FUSERSTRCT001 fu = (FUSERSTRCT001) lookupFunctionUnit(FUSERSTRCT001.class);
		    	responseData = fu.fSaveUseRstrctMgmt(requestData, onlineCtx);
		    	responseData.setOkResultMessage("PSNM-I000", null);
				
		    } catch (BizRuntimeException be) {
				throw be;
		    } catch (Exception e) {
				throw new BizRuntimeException("PSNM-E000", e);
			}
		
		    return responseData;
		}
  
}

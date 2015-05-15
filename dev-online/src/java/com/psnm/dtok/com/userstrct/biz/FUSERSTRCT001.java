package com.psnm.dtok.com.userstrct.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [FU]모드관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-27 09:52:17</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class FUSERSTRCT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FUSERSTRCT001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet fSearchUseRstrctMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		    try{
				
		    	DUSERSTRCT001 du = (DUSERSTRCT001)lookupDataUnit(DUSERSTRCT001.class);
		    	responseData = du.dSearchUseRstrctMgmt(requestData, onlineCtx);
		    	responseData.setOkResultMessage("PSNM-I000", null);
			} catch (BizRuntimeException be) {
				throw be;
			} catch (Exception e) {
				throw new BizRuntimeException("PSNM-E000", e);
			}
		    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		    return responseData;
		}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet fSearchDay(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		    try{
				
		    	DUSERSTRCT001 du = (DUSERSTRCT001)lookupDataUnit(DUSERSTRCT001.class);
		    	responseData = du.dSearchDay(requestData, onlineCtx);
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
	 * @since 2015-01-27 09:52:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet fSaveUseRstrctMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
	
			IDataSet responseData = new DataSet();
			try {
				DUSERSTRCT001 du = (DUSERSTRCT001) lookupDataUnit(DUSERSTRCT001.class);
				IRecordSet list = requestData.getRecordSet("grid");
				int listCount = null == list ? 0 : list.getRecordCount();
				for (int i = 0; i < listCount; i++) {
					Map<String, Object> record = list.getRecordMap(i);
					IDataSet dsParam = new DataSet();
					dsParam.putFieldMap(record);
	
					String flag = (String) record.get("FLAG");
	
					if (StringUtils.equals(flag, "U")) { // 갱신
						du.dSaveUseRstrctMgmt(dsParam, onlineCtx);
					}
				}
	
				responseData.setOkResultMessage("PSNM-I000", null);
			} catch (BizRuntimeException be) {
				throw be;
			} catch (Exception e) {
				throw new BizRuntimeException("PSNM-E000", e);
			}
			return responseData;
			
		}
}

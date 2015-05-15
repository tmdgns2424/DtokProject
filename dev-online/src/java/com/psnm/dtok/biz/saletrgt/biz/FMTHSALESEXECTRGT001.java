package com.psnm.dtok.biz.saletrgt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FMTHSALESEXECTRGT001</li>
 * <li>설  명 : 영업목표관리 FU</li>
 * <li>작성일 : 2015-02-09 16:49:14</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FMTHSALESEXECTRGT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMTHSALESEXECTRGT001(){
		super();
	}

	/**
	 * 영업목표관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 17:31:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESEXECTRGT001 du = (DMTHSALESEXECTRGT001) lookupDataUnit(DMTHSALESEXECTRGT001.class);
	    	
			responseData = du.dSearchSalesExecTrgt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
	
	/**
	 * 영업목표관리합계 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 17:33:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesExecTrgtTotal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESEXECTRGT001 du = (DMTHSALESEXECTRGT001) lookupDataUnit(DMTHSALESEXECTRGT001.class);
	    	
			responseData = du.dSearchSalesExecTrgtTotal(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업목표관리 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 17:32:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSalesExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DMTHSALESEXECTRGT001 du = (DMTHSALESEXECTRGT001) lookupDataUnit(DMTHSALESEXECTRGT001.class);
			
	    	IRecordSet rs =  requestData.getRecordSet("grid");
			if(rs != null && rs.getRecordCount()!=0) {
				for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		listData.putField("SALES_YM", requestData.getField("SALES_YM"));
		    		
		    		du.dInsertSalesExecTrgt(listData, onlineCtx);
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

	/**
	 * 영업목표정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-10 13:41:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesExecTrgtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESEXECTRGT001 du = (DMTHSALESEXECTRGT001) lookupDataUnit(DMTHSALESEXECTRGT001.class);
	    	
			responseData = du.dSearchSalesExecTrgtBrws(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

}

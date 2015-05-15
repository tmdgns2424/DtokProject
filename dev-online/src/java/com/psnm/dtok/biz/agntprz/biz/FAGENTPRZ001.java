package com.psnm.dtok.biz.agntprz.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordHeader;
import nexcore.framework.core.data.RecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FAGENTPRZ001</li>
 * <li>설  명 : 포상관리 FU</li>
 * <li>작성일 : 2014-11-26 18:19:11</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class FAGENTPRZ001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTPRZ001(){
		super();
	}

	/**
	 * 포상관리 정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:19:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{
	    	
			DAGENTPRZ001 du = (DAGENTPRZ001)lookupDataUnit(DAGENTPRZ001.class);
			
			responseData = du.dSearchAgentPrz(requestData, onlineCtx);
			
			responseData.putField("count", du.dSearchAgentPrzCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    
	    return responseData;
	}

	/**
	 * 포상관리상세 정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:19:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try{
	    	
	    	DAGENTPRZ001 du = (DAGENTPRZ001)lookupDataUnit(DAGENTPRZ001.class);
	    	
	    	responseData = du.dDetailAgentPrz(requestData, onlineCtx);
	    			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 포상관리 정보를 저장하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:19:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	DAGENTPRZ001 du = (DAGENTPRZ001)lookupDataUnit(DAGENTPRZ001.class);
	    	
	    	du.dInsertAgentPrz(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 포상관리 정보를 수정하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:19:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTPRZ001 du = (DAGENTPRZ001)lookupDataUnit(DAGENTPRZ001.class);
	    	
	    	du.dUpdateAgentPrz(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

	    return responseData;
	}

	/**
	 * 포상관리 정보를 삭제하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:19:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	DAGENTPRZ001 du = (DAGENTPRZ001)lookupDataUnit(DAGENTPRZ001.class);
	    	
	    	du.dDeleteAgentPrz(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 포상관리 엑셀업로드 하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:19:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet fInsertExlAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData 	= new DataSet();
	    IDataSet tempData 		= new DataSet();
	    
		IRecordSet resultList = new RecordSet("resultList");
		resultList.addHeader(new RecordHeader("AGNT_ID"));
		resultList.addHeader(new RecordHeader("PRZ_DT"));
		resultList.addHeader(new RecordHeader("PRZ_CL_NM"));
		resultList.addHeader(new RecordHeader("PRZ_NM"));
		resultList.addHeader(new RecordHeader("PRZ_CTT"));
		resultList.addHeader(new RecordHeader("PRZ_RSN_NM"));
		resultList.addHeader(new RecordHeader("RPSTY"));
		resultList.addHeader(new RecordHeader("AGNT_NM"));
		resultList.addHeader(new RecordHeader("HDQT_PART_ORG_ID"));
		resultList.addHeader(new RecordHeader("HDQT_PART_ORG_NM"));
		resultList.addHeader(new RecordHeader("SALE_DEPT_ORG_ID"));
		resultList.addHeader(new RecordHeader("SALE_DEPT_ORG_NM"));
		resultList.addHeader(new RecordHeader("SALE_TEAM_ORG_ID"));
		resultList.addHeader(new RecordHeader("SALE_TEAM_ORG_NM"));
		
		try {
			
			DAGENTPRZ001 du = (DAGENTPRZ001) lookupDataUnit(DAGENTPRZ001.class);
			IRecordSet rs =  requestData.getRecordSet("gridexcelimported");
			
			if(rs.getRecordCount() != 0){
				
				for(int i=0 ; i<rs.getRecordCount() ; i++){
					
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		tempData = du.dSearchExlAgentPrz(listData, onlineCtx);
		    		
		    		if(tempData.getRecordSet("ds").getRecordCount()!=0){
		    			
		    			IRecord record = tempData.getRecordSet("ds").newRecord();
		    			
		    			record.set("AGNT_ID", 			tempData.getRecordSet("ds").get(0, "AGNT_ID"));
		    			record.set("PRZ_DT", 			tempData.getRecordSet("ds").get(0, "PRZ_DT"));
		    			record.set("PRZ_CL_NM", 		tempData.getRecordSet("ds").get(0, "PRZ_CL_NM"));
		    			record.set("PRZ_NM", 			tempData.getRecordSet("ds").get(0, "PRZ_NM"));
		    			record.set("PRZ_CTT", 			tempData.getRecordSet("ds").get(0, "PRZ_CTT"));
		    			record.set("PRZ_RSN_NM", 		tempData.getRecordSet("ds").get(0, "PRZ_RSN_NM"));
		    			record.set("RPSTY", 			tempData.getRecordSet("ds").get(0, "RPSTY"));
		    			record.set("AGNT_NM", 			tempData.getRecordSet("ds").get(0, "AGNT_NM"));
		    			record.set("HDQT_PART_ORG_ID", 	tempData.getRecordSet("ds").get(0, "HDQT_PART_ORG_ID"));
		    			record.set("HDQT_PART_ORG_NM", 	tempData.getRecordSet("ds").get(0, "HDQT_PART_ORG_NM"));
		    			record.set("SALE_DEPT_ORG_ID", 	tempData.getRecordSet("ds").get(0, "SALE_DEPT_ORG_ID"));
		    			record.set("SALE_DEPT_ORG_NM", 	tempData.getRecordSet("ds").get(0, "SALE_DEPT_ORG_NM"));
		    			record.set("SALE_TEAM_ORG_ID", 	tempData.getRecordSet("ds").get(0, "SALE_TEAM_ORG_ID"));
		    			record.set("SALE_TEAM_ORG_NM", 	tempData.getRecordSet("ds").get(0, "SALE_TEAM_ORG_NM"));
			    		
			    		if("5".equals(tempData.getRecordSet("ds").get(0, "USE_YN"))){
			    			
			    			IDataSet reqData = new DataSet();
			    			reqData.putFieldMap(tempData.getRecordSet("ds").getRecord(0));
							du.dInsertAgentPrz(reqData, onlineCtx);
							
		    			}else{
		    				record.remove("USE_YN");
		    				resultList.addRecord(record);
		    			}
		    		}else{
		    			
		    			IRecord record = tempData.getRecordSet("ds").newRecord();
		    	
		    			record.set("AGNT_ID", 			listData.getField("AGNT_ID"));
		    			record.set("PRZ_DT", 			listData.getField("PRZ_DT"));
		    			record.set("PRZ_CL_NM", 		listData.getField("PRZ_CL_NM"));
		    			record.set("PRZ_NM", 			listData.getField("PRZ_NM"));
		    			record.set("PRZ_CTT", 			listData.getField("PRZ_CTT"));
		    			record.set("PRZ_RSN_NM", 		listData.getField("PRZ_RSN_NM"));
		    			record.set("RPSTY", 			"");
		    			record.set("AGNT_NM", 			"");
		    			record.set("HDQT_PART_ORG_ID", 	"");
		    			record.set("HDQT_PART_ORG_NM", 	"");
		    			record.set("SALE_DEPT_ORG_ID", 	"");
		    			record.set("SALE_DEPT_ORG_NM", 	"");
		    			record.set("SALE_TEAM_ORG_ID", 	"");
		    			record.set("SALE_TEAM_ORG_NM", 	"");
		    			record.remove("USE_YN");
			    		
		    			resultList.addRecord(record);
			    	}
				}
			}
			
			responseData.putRecordSet("gridexcelimported", resultList);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
		
		return responseData;
	}
  
}

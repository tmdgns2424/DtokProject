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
 * <li>단위업무명: FAGENTDSCPL001</li>
 * <li>설  명 : 징계관리 FU</li>
 * <li>작성일 : 2015-01-20 13:21:34</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FAGENTDSCPL001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTDSCPL001(){
		super();
	}

	/**
	 * 징계관리정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 13:55:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{
	    	
	    	DAGENTDSCPL001 du = (DAGENTDSCPL001)lookupDataUnit(DAGENTDSCPL001.class);
			
			responseData = du.dSearchAgentDscpl(requestData, onlineCtx);
			
			responseData.putField("count", du.dSearchAgentDscplCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 징계관리상세정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 13:55:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{
	    	
	    	DAGENTDSCPL001 du = (DAGENTDSCPL001)lookupDataUnit(DAGENTDSCPL001.class);
	    	
	    	responseData = du.dDetailAgentDscpl(requestData, onlineCtx);
	    			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 13:56:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTDSCPL001 du = (DAGENTDSCPL001)lookupDataUnit(DAGENTDSCPL001.class);
	    	
	    	du.dInsertAgentDscpl(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 징계관리정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 13:56:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTDSCPL001 du = (DAGENTDSCPL001)lookupDataUnit(DAGENTDSCPL001.class);
	    	
	    	du.dUpdateAgentDscpl(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 13:57:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTDSCPL001 du = (DAGENTDSCPL001)lookupDataUnit(DAGENTDSCPL001.class);
	    	
	    	du.dDeleteAgentDscpl(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리 엑셀업로드 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 13:57:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet fInsertExlAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    IDataSet tempData 		= new DataSet();
	    
		IRecordSet resultList = new RecordSet("resultList");
		resultList.addHeader(new RecordHeader("AGNT_ID"));
		resultList.addHeader(new RecordHeader("DISPL_DT"));
		resultList.addHeader(new RecordHeader("DISPL_CTT"));
		resultList.addHeader(new RecordHeader("DISPL_RSN_NM"));
		resultList.addHeader(new RecordHeader("RPSTY"));
		resultList.addHeader(new RecordHeader("AGNT_NM"));
		resultList.addHeader(new RecordHeader("HDQT_PART_ORG_ID"));
		resultList.addHeader(new RecordHeader("HDQT_PART_ORG_NM"));
		resultList.addHeader(new RecordHeader("SALE_DEPT_ORG_ID"));
		resultList.addHeader(new RecordHeader("SALE_DEPT_ORG_NM"));
		resultList.addHeader(new RecordHeader("SALE_TEAM_ORG_ID"));
		resultList.addHeader(new RecordHeader("SALE_TEAM_ORG_NM"));
		
		try {
			
			DAGENTDSCPL001 du = (DAGENTDSCPL001) lookupDataUnit(DAGENTDSCPL001.class);
			IRecordSet rs =  requestData.getRecordSet("gridexcelimported");
			
			if(rs.getRecordCount() != 0){
				
				for(int i=0 ; i<rs.getRecordCount() ; i++){
					
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		tempData = du.dSearchExlAgentDscpl(listData, onlineCtx);
		    		
		    		if(tempData.getRecordSet("ds").getRecordCount()!=0){
		    			
		    			IRecord record = tempData.getRecordSet("ds").newRecord();
		    			
		    			record.set("AGNT_ID", 			tempData.getRecordSet("ds").get(0, "AGNT_ID"));
		    			record.set("DISPL_DT", 			tempData.getRecordSet("ds").get(0, "DISPL_DT"));
		    			record.set("DISPL_CTT", 		tempData.getRecordSet("ds").get(0, "DISPL_CTT"));
		    			record.set("DISPL_RSN_NM", 		tempData.getRecordSet("ds").get(0, "DISPL_RSN_NM"));
		    			record.set("RPSTY", 			tempData.getRecordSet("ds").get(0, "RPSTY"));
		    			record.set("AGNT_NM", 			tempData.getRecordSet("ds").get(0, "AGNT_NM"));
		    			record.set("HDQT_PART_ORG_ID", 	tempData.getRecordSet("ds").get(0, "HDQT_PART_ORG_ID"));
		    			record.set("HDQT_PART_ORG_NM", 	tempData.getRecordSet("ds").get(0, "HDQT_PART_ORG_NM"));
		    			record.set("SALE_DEPT_ORG_ID", 	tempData.getRecordSet("ds").get(0, "SALE_DEPT_ORG_ID"));
		    			record.set("SALE_DEPT_ORG_NM", 	tempData.getRecordSet("ds").get(0, "SALE_DEPT_ORG_NM"));
		    			record.set("SALE_TEAM_ORG_ID", 	tempData.getRecordSet("ds").get(0, "SALE_TEAM_ORG_ID"));
		    			record.set("SALE_TEAM_ORG_NM", 	tempData.getRecordSet("ds").get(0, "SALE_TEAM_ORG_NM"));
			    		
			    		if("3".equals(tempData.getRecordSet("ds").get(0, "USE_YN"))){
			    			
			    			IDataSet reqData = new DataSet();
			    			reqData.putFieldMap(tempData.getRecordSet("ds").getRecord(0));
							du.dInsertAgentDscpl(reqData, onlineCtx);
							
		    			}else{
		    				record.remove("USE_YN");
		    				resultList.addRecord(record);
		    			}
		    		}else{
		    			
		    			IRecord record = tempData.getRecordSet("ds").newRecord();
		    	
		    			record.set("AGNT_ID", 			listData.getField("AGNT_ID"));
		    			record.set("DISPL_DT", 			listData.getField("DISPL_DT"));
		    			record.set("DISPL_CTT", 		listData.getField("DISPL_CTT"));
		    			record.set("DISPL_RSN_NM", 		listData.getField("DISPL_RSN_NM"));
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

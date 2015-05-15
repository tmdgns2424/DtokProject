package com.psnm.dtok.biz.agntedu.biz;

import com.psnm.common.util.PsnmStringUtil;

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
 * <li>단위업무명: FAGENTEDU001</li>
 * <li>설  명 : 교육관리[FU]</li>
 * <li>작성일 : 2014-11-24 17:35:02</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FAGENTEDU001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTEDU001(){
		super();
	}

	/**
	 * 교육 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:36:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
	    	
			responseData = du.dSearchAgentEdu(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAgentEduCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육관리 상세를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 11:02:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
	    	
			responseData = du.dDetailAgentEdu(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육관리 참석자 결과를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 11:37:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
	    	
			responseData = du.dDetailAgentEduAtndr(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육관리참석자 엑셀 업로드 정보를 조회한다.
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-16 15:31:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData 	= new DataSet();
	    IDataSet tempData 		= new DataSet();
	
	    IRecordSet succesData = new RecordSet("succesData");		
	    succesData.addHeader(new RecordHeader("USER_ID"));
	    succesData.addHeader(new RecordHeader("HDQT_TEAM_ORG_ID"));
	    succesData.addHeader(new RecordHeader("HDQT_TEAM_ORG_NM"));
	    succesData.addHeader(new RecordHeader("HDQT_PART_ORG_ID"));
	    succesData.addHeader(new RecordHeader("HDQT_PART_ORG_NM"));
	    succesData.addHeader(new RecordHeader("SALE_DEPT_ORG_ID"));
	    succesData.addHeader(new RecordHeader("SALE_DEPT_ORG_NM"));
	    succesData.addHeader(new RecordHeader("SALE_TEAM_ORG_ID"));
	    succesData.addHeader(new RecordHeader("SALE_TEAM_ORG_NM"));
	    succesData.addHeader(new RecordHeader("AGNT_ID"));
	    succesData.addHeader(new RecordHeader("RPSTY"));
	    succesData.addHeader(new RecordHeader("RPSTY_NM"));
	    succesData.addHeader(new RecordHeader("AGNT_NM"));
	    succesData.addHeader(new RecordHeader("EDU_MANN_CD"));
	    succesData.addHeader(new RecordHeader("EVAL_RSLT_CD"));
	    succesData.addHeader(new RecordHeader("MEMO"));
	    succesData.addHeader(new RecordHeader("USE_YN"));
	    succesData.addHeader(new RecordHeader("MESSAGE"));
	    
	    IRecordSet failData = new RecordSet("failData");		
	    failData.addHeader(new RecordHeader("USER_ID"));
	    failData.addHeader(new RecordHeader("HDQT_TEAM_ORG_ID"));
	    failData.addHeader(new RecordHeader("HDQT_TEAM_ORG_NM"));
	    failData.addHeader(new RecordHeader("HDQT_PART_ORG_ID"));
	    failData.addHeader(new RecordHeader("HDQT_PART_ORG_NM"));
	    failData.addHeader(new RecordHeader("SALE_DEPT_ORG_ID"));
	    failData.addHeader(new RecordHeader("SALE_DEPT_ORG_NM"));
	    failData.addHeader(new RecordHeader("SALE_TEAM_ORG_ID"));
	    failData.addHeader(new RecordHeader("SALE_TEAM_ORG_NM"));
	    failData.addHeader(new RecordHeader("AGNT_ID"));
	    failData.addHeader(new RecordHeader("RPSTY"));
	    failData.addHeader(new RecordHeader("RPSTY_NM"));
	    failData.addHeader(new RecordHeader("AGNT_NM"));
	    failData.addHeader(new RecordHeader("EDU_MANN_CD"));
	    failData.addHeader(new RecordHeader("EVAL_RSLT_CD"));
	    failData.addHeader(new RecordHeader("MEMO"));
	    failData.addHeader(new RecordHeader("USE_YN"));
	    failData.addHeader(new RecordHeader("MESSAGE"));
	    
	    try {
	    	
	    	IRecordSet rs =  requestData.getRecordSet("gridexcelimported");
	    	
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
	    	
	    	if(rs.getRecordCount()!= 0) {
	    		for(int i = 0 ; i < rs.getRecordCount() ; i++){
	    			
	    			IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		listData.putField("AGENT_EDUT_MGMT_NUM", requestData.getField("AGENT_EDUT_MGMT_NUM"));
	    			
		    		tempData = du.dSearchAgentEduAtndr(listData, onlineCtx);
					
					if(tempData.getRecordSet("ds").getRecordCount() != 0) {
						
						IRecord record = tempData.getRecordSet("ds").newRecord();
						record.set("USER_ID", 			tempData.getRecordSet("ds").get(0, "USER_ID"));
						record.set("HDQT_TEAM_ORG_ID", 	tempData.getRecordSet("ds").get(0, "HDQT_TEAM_ORG_ID"));
						record.set("HDQT_TEAM_ORG_NM", 	tempData.getRecordSet("ds").get(0, "HDQT_TEAM_ORG_NM"));
						record.set("HDQT_PART_ORG_ID", 	tempData.getRecordSet("ds").get(0, "HDQT_PART_ORG_ID"));
						record.set("HDQT_PART_ORG_NM", 	tempData.getRecordSet("ds").get(0, "HDQT_PART_ORG_NM"));
						record.set("SALE_DEPT_ORG_ID", 	tempData.getRecordSet("ds").get(0, "SALE_DEPT_ORG_ID"));
						record.set("SALE_DEPT_ORG_NM", 	tempData.getRecordSet("ds").get(0, "SALE_DEPT_ORG_NM"));
						record.set("SALE_TEAM_ORG_ID", 	tempData.getRecordSet("ds").get(0, "SALE_TEAM_ORG_ID"));
						record.set("SALE_TEAM_ORG_NM", 	tempData.getRecordSet("ds").get(0, "SALE_TEAM_ORG_NM"));
						record.set("AGNT_ID", 			tempData.getRecordSet("ds").get(0, "AGNT_ID"));
						record.set("RPSTY", 			tempData.getRecordSet("ds").get(0, "RPSTY"));
						record.set("RPSTY_NM", 			tempData.getRecordSet("ds").get(0, "RPSTY_NM"));
						record.set("AGNT_NM", 			tempData.getRecordSet("ds").get(0, "AGNT_NM"));
						record.set("EDU_MANN_CD", 		tempData.getRecordSet("ds").get(0, "EDU_MANN_CD"));
						record.set("EVAL_RSLT_CD", 		tempData.getRecordSet("ds").get(0, "EVAL_RSLT_CD"));
						record.set("MEMO", 				tempData.getRecordSet("ds").get(0, "MEMO"));
						record.set("USE_YN", 			tempData.getRecordSet("ds").get(0, "USE_YN"));
						record.set("MESSAGE", 			tempData.getRecordSet("ds").get(0, "MESSAGE"));
			    		
		    			if("4".equals(tempData.getRecordSet("ds").get(0, "USE_YN"))) {
		    				succesData.addRecord(record);
		    			}else{
		    				failData.addRecord(record);
		    			}
						
		    		} else {
		    			IRecord record = tempData.getRecordSet("ds").newRecord();
		    			record.set("USER_ID", 			"");
						record.set("HDQT_TEAM_ORG_ID", 	"");
						record.set("HDQT_TEAM_ORG_NM", 	"");
						record.set("HDQT_PART_ORG_ID", 	"");
						record.set("HDQT_PART_ORG_NM", 	"");
						record.set("SALE_DEPT_ORG_ID", 	"");
						record.set("SALE_DEPT_ORG_NM", 	"");
						record.set("SALE_TEAM_ORG_ID", 	"");
						record.set("SALE_TEAM_ORG_NM", 	"");
						record.set("AGNT_ID", 			listData.getField("AGNT_ID"));
						record.set("RPSTY", 			"");
						record.set("RPSTY_NM", 			"");
						record.set("AGNT_NM", 			"");
						record.set("EDU_MANN_CD", 		listData.getField("EDU_MANN_CD"));
						record.set("EVAL_RSLT_CD", 		listData.getField("EVAL_RSLT_CD"));
						record.set("MEMO", 				listData.getField("MEMO"));
						record.set("USE_YN", 			"0");
						record.set("MESSAGE", 			"존재하지 않는 ID 이거나 중복 ID");
		    			
		    			failData.addRecord(record);
		    		}
	    		}
			}
			
	    	responseData.putRecordSet("succesData", succesData);
			responseData.putRecordSet("failData", failData);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육관리 정보를 등록 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:35:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
	    	
	    	if( PsnmStringUtil.isEmpty(requestData.getField("AGENT_EDUT_MGMT_NUM")) ) {
	    		requestData.putField("AGENT_EDUT_MGMT_NUM", du.dSearchAgentEduIdSeq(requestData, onlineCtx).getField("AGENT_EDUT_MGMT_NUM"));
	    	}
	    	
	    	String EDU_STA_HM = requestData.getField("EDU_STA_H") + requestData.getField("EDU_STA_M");
	    	String EDU_END_HM = requestData.getField("EDU_END_H") + requestData.getField("EDU_END_M");
	    	requestData.putField("EDU_STA_HM", EDU_STA_HM);
	    	requestData.putField("EDU_END_HM", EDU_END_HM);
			
	    	//교육관리 저장|수정
			du.dInsertAgentEdu(requestData, onlineCtx);
			
			//교육참가자 저장|수정
			IRecordSet rs =  requestData.getRecordSet("grid1");
			if(rs != null && rs.getRecordCount()!=0) {
		    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
		    		IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		listData.putField("AGENT_EDUT_MGMT_NUM", requestData.getField("AGENT_EDUT_MGMT_NUM"));
		    		
		    		du.dInsertAgentEduAtndr(listData, onlineCtx);
		    	}
			}
			
			//교육참가자 삭제
			IRecordSet rs2 =  requestData.getRecordSet("grid3");
			if(rs2 != null && rs2.getRecordCount()!=0) {
		    	for(int i = 0 ; i < rs2.getRecordCount() ; i++){
		    		IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs2.getRecordMap(i));
		    		listData.putField("AGENT_EDUT_MGMT_NUM", requestData.getField("AGENT_EDUT_MGMT_NUM"));
		    		
		    		du.dDeleteAgentEduAtndr(listData, onlineCtx);
		    	}
			}
			
			//첨부파일 저장
			if(requestData.getRecordSet("gridfile") != null){
				//첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
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
	 * 교육관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-17 11:40:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
			
			du.dDeleteAgentEdu(requestData, onlineCtx);
			du.dDeleteAgentEduAtndrAll(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 교육현황 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-26 10:34:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentEduPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTEDUT001 du = (DAGENTEDUT001) lookupDataUnit(DAGENTEDUT001.class);
	    	
			responseData = du.dSearchAgentEduPrst(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAgentEduPrstCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}

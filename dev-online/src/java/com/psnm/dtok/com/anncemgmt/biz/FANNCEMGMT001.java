package com.psnm.dtok.com.anncemgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FANNCEMGMT001</li>
 * <li>설  명 : 공지사항 FU</li>
 * <li>작성일 : 2015-01-08 09:31:20</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FANNCEMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FANNCEMGMT001(){
		super();
	}

	/**
	 * 공지사항관리정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 09:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	
			responseData = du.dSearchAnnce(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAnnceCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 공지사항관리상세정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 09:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DANNCEMGMT001   du1 = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	DANNCERCVGRP001 du2 = (DANNCERCVGRP001) lookupDataUnit(DANNCERCVGRP001.class);
	    	DANNCERCVORG001 du3 = (DANNCERCVORG001) lookupDataUnit(DANNCERCVORG001.class);
		    
	    	responseData.putRecordSet("gridauthgrp", du2.dSearchAnnceRcvGrpObject(requestData, onlineCtx).getRecordSet("ds"));
	    	
	    	if(!PsnmStringUtil.isEmpty(requestData.getField("ANNCE_ID"))){

	    		responseData.putFieldMap(du1.dDetailAnnce(requestData, onlineCtx).getFieldMap());
	    		responseData.putRecordSet("gridauthorg", du3.dSearchAnnceRcvOrgObject(requestData, onlineCtx).getRecordSet("ds"));

	    		//첨부파일 조회
	    		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
	    		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
			    
	    		//열람자 등록
			    callSharedBizComponentByDirect("com.SHARE", "fMergeReadrMgmt", requestData, onlineCtx);
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
	 * 공지사항관리정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 09:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
			
			du.dInsertAnnce(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 공지사항관리정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 09:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DANNCEMGMT001   du1 = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	DANNCERCVGRP001 du2 = (DANNCERCVGRP001) lookupDataUnit(DANNCERCVGRP001.class);
	    	DANNCERCVORG001 du3 = (DANNCERCVORG001) lookupDataUnit(DANNCERCVORG001.class);
	    	
	    	du1.dUpdateAnnce(requestData, onlineCtx);
			du2.dDeleteAnnceRcvGrp(requestData, onlineCtx);
			du3.dDeleteAnnceRcvOrg(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 공지사항관리정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 09:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	DANNCERCVGRP001 du1 = (DANNCERCVGRP001) lookupDataUnit(DANNCERCVGRP001.class);
	    	DANNCERCVORG001 du2 = (DANNCERCVORG001) lookupDataUnit(DANNCERCVORG001.class);
			
			du.dDeleteAnnce(requestData, onlineCtx);
			du1.dDeleteAnnceRcvGrp(requestData, onlineCtx);
			du2.dDeleteAnnceRcvOrg(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 공지조직정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 16:53:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAnnceRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DANNCERCVORG001 du = (DANNCERCVORG001) lookupDataUnit(DANNCERCVORG001.class);
		
	    	IRecordSet rs =  requestData.getRecordSet("gridauthorg");
		    String id = requestData.getField("ANNCE_ID");
		    
		    if(rs != null){
		    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
					listData.putFieldMap(rs.getRecordMap(i));
					requestData = listData;
					requestData.putField("ANNCE_ID", id);
					du.dInsertAnnceRcvOrg(requestData, onlineCtx);
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
	 * 공지그룹정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 16:54:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAnnceRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DANNCERCVGRP001 du = (DANNCERCVGRP001) lookupDataUnit(DANNCERCVGRP001.class);
		
		    IRecordSet rs =  requestData.getRecordSet("gridauthgrp");
		    String id = requestData.getField("ANNCE_ID");
		    
		    if(rs != null){
		    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
					listData.putFieldMap(rs.getRecordMap(i));
					requestData = listData;
					requestData.putField("ANNCE_ID", id);
					du.dInsertAnnceRcvGrp(requestData, onlineCtx);
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
	 * 공지사항관리권한그룹 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 09:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnceAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	
			responseData = du.dSearchAnnceAuthGrp(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 공지사항정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-15 14:50:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnceBrws(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	
			responseData = du.dSearchAnnceBrws(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAnnceBrwsCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 공지사항필수확인여부정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-23 09:38:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAnnceMndtChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
			
			du.dInsertAnnceMndtChk(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 공지사항필수확인여부정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-23 10:56:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnceMndtChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	
			responseData = du.dSearchAnnceMndtChk(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 공지사항필수확인영업국명 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-04-01 15:53:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnceMndtDept(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	
			responseData = du.dSearchAnnceMndtDept(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 공지사항필수확인현황 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-04-01 15:53:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAnnceMndt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DANNCEMGMT001 du = (DANNCEMGMT001) lookupDataUnit(DANNCEMGMT001.class);
	    	
			responseData = du.dSearchAnnceMndt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}

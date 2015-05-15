package com.psnm.dtok.biz.mainschd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmStringUtil;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [FU]주요일정관리</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-01-13 11:37:43</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class FSCHMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSCHMGMT001() {
		super();
	}

	/**
	 * 주요일정 정보를 조회하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		
		try {

			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			int count = du.dSearchSchMgmtCnt(requestData, onlineCtx).getRecordSet("COUNT").getRecord(0).getInt("SCH_CNT");
			log.debug("<주요일정조회> 전체건수= " + count);
			
			responseData = du.dSearchSchMgmt(requestData, onlineCtx);			
			responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
			responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
			responseData.getRecordSet("grid").setTotalRecordCount(count);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}

	/**
	 * 주요일정 정보를 상세 조회하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		
		try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			DSCHRCVGRP001 du2 = (DSCHRCVGRP001) lookupDataUnit(DSCHRCVGRP001.class);
			DSCHRCVORG001 du3 = (DSCHRCVORG001) lookupDataUnit(DSCHRCVORG001.class);
			
			responseData.putRecordSet( "gridauthgrp", du2.dSearchSchRcvGrp(requestData, onlineCtx).getRecordSet("ds"));
			
			if (PsnmStringUtil.isEmpty(requestData.getField("SCH_ID")) == false) {
				
				responseData.putFieldMap(du.dDetailSchMgmt(requestData, onlineCtx).getFieldMap());
				responseData.putRecordSet("gridauthorg", du3.dSearchSchRcvOrg(requestData, onlineCtx).getRecordSet("ds"));
				
				// 첨부파일 조회
				IDataSet fileDataset = callSharedBizComponentByDirect( "com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
				responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
				
				// 열람자 등록
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
	 * 주요일정 정보를 추가하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			du.dInsertSchMgmt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}

	/**
	 * 주요일정 정보를 수정하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {

			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			DSCHRCVGRP001 du2 = (DSCHRCVGRP001) lookupDataUnit(DSCHRCVGRP001.class);
			DSCHRCVORG001 du3 = (DSCHRCVORG001) lookupDataUnit(DSCHRCVORG001.class);
			
			du.dUpdateSchMgmt(requestData, onlineCtx);
			du2.dDeleteSchRcvGrp(requestData, onlineCtx);
			du3.dDeleteSchRcvOrg(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}

	/**
	 * 주요일정 그룹을 저장하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSchMgmtRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		try {
			
			DSCHRCVGRP001 du = (DSCHRCVGRP001) lookupDataUnit(DSCHRCVGRP001.class);
			
			IRecordSet rs = requestData.getRecordSet("gridauthgrp");
			
			String id = requestData.getField("SCH_ID");
			if (rs != null) {
				
				for (int i = 0; i < rs.getRecordCount(); i++) {
					IDataSet listData = new DataSet();
					listData.putFieldMap(rs.getRecordMap(i));
					requestData = listData;
					requestData.putField("SCH_ID", id);
					du.dInsertSchRcvGrp(requestData, onlineCtx);
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
	 * 주요일정 조직을 저장하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 19:15:08
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSchMgmtRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			DSCHRCVORG001 du = (DSCHRCVORG001) lookupDataUnit(DSCHRCVORG001.class);
			
			IRecordSet rs = requestData.getRecordSet("gridauthorg");
			
			String id = requestData.getField("SCH_ID");
			if (rs != null) {
				
				for (int i = 0; i < rs.getRecordCount(); i++) {
					IDataSet listData = new DataSet();
					listData.putFieldMap(rs.getRecordMap(i));
					requestData = listData;
					requestData.putField("SCH_ID", id);
					du.dInsertSchRcvOrg(requestData, onlineCtx);
					
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
	 * 주요일정 정보를 삭제하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-16 10:17:52
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			DSCHRCVGRP001 du2 = (DSCHRCVGRP001) lookupDataUnit(DSCHRCVGRP001.class);
			DSCHRCVORG001 du3 = (DSCHRCVORG001) lookupDataUnit(DSCHRCVORG001.class);
			
			du.dDeleteSchMgmt(requestData, onlineCtx);
			du2.dDeleteSchRcvGrp(requestData, onlineCtx);
			du3.dDeleteSchRcvOrg(requestData, onlineCtx);
			
			// 첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
			callSharedBizComponentByDirect("com.SHARE", "fDeleteFileMapping", requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}

	/**
	 * 주요일정 정보를 조회 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSchMgmtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			responseData = du.dSearchSchMgmtBrws(requestData, onlineCtx);
			responseData.putField("count", du.dSearchSchMgmtBrwsCnt(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}
	
	/**
	 * 주요일정달력 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-12 10:17:06
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSchMgmtBrwsCal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			responseData = du.dSearchSchMgmtBrwsCal(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 주요일정달력휴일 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-12 10:19:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSchMgmtBrwsCalHDay(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			responseData = du.dSearchSchMgmtBrwsCalHDay(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 주요일정을 팝업에 상세 조회를 하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchPopSchMgmtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		Log log = getLog(onlineCtx);
		
		try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			int count = du.dSearchPopSchMgmtBrwsCnt(requestData, onlineCtx).getRecordSet("COUNT").getRecord(0).getInt("SCH_CNT");
			log.debug("<주요일정조회> 전체건수= " + count);
			
			responseData = du.dSearchPopSchMgmtBrws(requestData, onlineCtx);
			responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
			responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
			responseData.getRecordSet("grid").setTotalRecordCount(count);
			
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
	 * @since 2015-03-12 14:04:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSchMgmtBrwsCalData(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		try {
			
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
			
			responseData = du.dSearchSchMgmtBrwsCalData(requestData, onlineCtx);
			
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
	 * @since 2015-04-17 10:40:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSchMgmtAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);
	    	
			responseData = du.dSearchSchMgmtAuthGrp(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

}

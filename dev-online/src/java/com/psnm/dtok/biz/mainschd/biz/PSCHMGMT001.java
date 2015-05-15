package com.psnm.dtok.biz.mainschd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [PU]주요일정관리</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-01-13 11:37:26</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class PSCHMGMT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSCHMGMT001() {
		super();
	}

	/**
	 * 주요일정 정보를 조회하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:26
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
			
			responseData = fu.fSearchSchMgmt(requestData, onlineCtx);
			
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
	 * @since 2015-01-13 11:37:26
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		try {
			
			FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
			
			responseData = fu.fDetailSchMgmt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 주요일정 정보를 입력, 수정, 삭제하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 17:40:23
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
			DSCHMGMT001 du = (DSCHMGMT001) lookupDataUnit(DSCHMGMT001.class);

			String SCH_ID = "";

			if (PsnmStringUtil.isEmpty(requestData.getField("SCH_ID"))) {
				
				SCH_ID = du.dSearchSchMgmtSeq(requestData, onlineCtx).getField("SCH_ID");
				
				requestData.putField("SCH_ID", SCH_ID);
				
				fu.fInsertSchMgmt(requestData, onlineCtx);
				
			} else {
				
				fu.fUpdateSchMgmt(requestData, onlineCtx);
				
			}
			
			fu.fInsertSchMgmtRcvGrp(requestData, onlineCtx);
			fu.fInsertSchMgmtRcvOrg(requestData, onlineCtx);
			
			// 첨부파일 저장
			if (requestData.getRecordSet("gridfile") != null) {
				
				// 첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
				
			}
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 주요일정 정보를 삭제 하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-16 10:17:08
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		try {
			FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
			
			fu.fDeleteSchMgmt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}

	/**
	 * 주요일정 정보를 조회하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:37:26
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSchMgmtBrws(IDataSet requestData,IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
			
			responseData = fu.fSearchSchMgmtBrws(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			IRecordSet rs1 = fu.fSearchSchMgmtBrwsCal(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs2 = fu.fSearchSchMgmtBrwsCalHDay(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs3 = fu.fSearchSchMgmtBrwsCalData(requestData, onlineCtx).getRecordSet("gridCal");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("grid", rs);
			responseData.putRecordSet("calendarList", rs1);
			responseData.putRecordSet("calendarHdayList", rs2);
			responseData.putRecordSet("gridCal", rs3);
			
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
	 * @since 2015-01-21 09:21:29
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchPopSchMgmtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			
			FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
			
			responseData = fu.fSearchPopSchMgmtBrws(requestData, onlineCtx);
			
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
	 * @since 2015-04-17 10:41:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSchMgmtAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FSCHMGMT001 fu = (FSCHMGMT001) lookupFunctionUnit(FSCHMGMT001.class);
		
			responseData = fu.fSearchSchMgmtAuthGrp(requestData, onlineCtx);
			
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

}

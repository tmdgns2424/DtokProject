package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PBLTNBRD001</li>
 * <li>설  명 : 커뮤니티 게시판 관련 PU</li>
 * <li>작성일 : 2015-01-30 17:02:44</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class PBLTNBRD001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PBLTNBRD001(){
		super();
	}

	/**
	 *
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:09:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdTree(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();	
	   
		try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			responseData = fu.fSearchBltnBrdTree(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;	
	}

	/**
	 * 해당 게시판 관련 PM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:02:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			responseData = fu.fSearchBltnBrdList(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 해당 게시판 상세조회 PM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-03 16:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fDetailBltnBrd(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-04 17:58:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fSaveBltnBrdInfo(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 해당 게시글 삭제 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 09:43:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fDeleteBltnBrd(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 게시판 답글 저장하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 15:36:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsetBltnBrdReply(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fInsertBltnBrdReply(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 게시판비밀번호가능여부 체크하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:02:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pCheckBltnBrdScrtNum(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fCheckBltnBrdScrtNum(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 게시글 이동과 관련된 게시판 그룹조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:02:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdMoveInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fSearchBltnBrdMoveInfo(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}   
	
	    return responseData;
	}

	/**
	 * 게시글이동 시키는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 17:11:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pUpdateBltnBrdMove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fUpdateBltnBrdMove(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}   
	
	    return responseData;
	}

	/**
	 * 주간/월간 추천하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:02:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pRcmndBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fRcmndBtlnBrd(requestData, onlineCtx) ;

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}   
	
	    return responseData;
	}

	/**
	 * 글이동 관련 게시판 그룹조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-10 11:37:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fSearchBltnBrdGrp(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}    
	
	    return responseData;
	}

	/**
	 * 해당 게시판 정보 조회 하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-10 16:27:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fSearchBltnBrdInfo(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}    
	
	    return responseData;
	}

	/**
	 * 게시판삭제가능여부확인 PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-10 15:12:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pCheckBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fCheckBltnBrd(requestData, onlineCtx);
			
			responseData.putField("AUTH_TYP_CD", responseData.getField("AUTH_TYP_CD"));
			responseData.putField("RGSTR_YN", responseData.getField("RGSTR_YN"));

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}   
	
	    return responseData;
	}

	/**
	 * 게시판삭제(기간조회) PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-18 11:02:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteBltnBrdSrchAll(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FBLTNBRD001 fu = (FBLTNBRD001) lookupFunctionUnit(FBLTNBRD001.class);
			
			responseData = fu.fDeleteBltnBrdSrchAll(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 

	    return responseData;
	}
  
}

package com.psnm.dtok.com.mainlogin.biz;

import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PMAIN001</li>
 * <li>설  명 : 메인조회</li>
 * <li>작성일 : 2014-12-17 14:05:19</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PMAIN001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PMAIN001(){
		super();
	}

	/**
	 * 메인용 공지목록등 각종 정보 조회1
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:05:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMain1(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fSearchMain1(requestData, onlineCtx);
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
	 * 공지사항(필드맵), 첨부파일, 댓글목록 조회하여 반환
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 17:12:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fSearchAnnce(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 받은쪽지개수조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-19 15:04:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchRcvPaperCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fSearchRcvPaperCnt(requestData, onlineCtx);
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
	 * [PM]팝업공지사항목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:05:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAnncePopList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fSearchAnncePopList(requestData, onlineCtx);
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
	 * [PM]필수확인공지목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-27 11:00:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAnnceMndtList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fSearchAnnceMndtList(requestData, onlineCtx);
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
	 * [PM]담보만료정보등록|수정 - 재계약여부
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-09 10:55:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pMergeMrtgExpir(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fMergeMrtgExpir(requestData, onlineCtx);
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
	 * [PM]본인확인결과갱신
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-10 13:21:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pUpdateNameCheck(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fUpdateNameCheck(requestData, onlineCtx);
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
	 * [PM]생일자조회(팝업)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-17 14:05:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchWhoBorn(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMAIN001 fu = (FMAIN001) lookupFunctionUnit(FMAIN001.class);
			responseData = fu.fSearchWhoBorn(requestData, onlineCtx);

			IDataSet dset = callSharedBizComponentByDirect("com.SHARE", "fSearchWeekDayInfo", requestData, onlineCtx);
			responseData.putFieldMap( dset.getFieldMap() );
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

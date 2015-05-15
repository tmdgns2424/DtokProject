package com.psnm.dtok.com.code.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PBASE</li>
 * <li>설  명 : 기준정보조회 클래스</li>
 * <li>작성일 : 2014-12-03 16:25:49</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PBASE extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PBASE(){
		super();
	}

	/**
	 * 에이전트 목록 조회(NO페이징, 팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-03 16:27:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgent(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    try {
	    	IDataSet resultData = callSharedBizComponentByDirect("com.SHARE", "fSearchAgent", requestData, onlineCtx);

			IRecordSet rs = resultData.getRecordSet("ds");
			
			responseData.putRecordSet("gridagent", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 회원 팝업 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 17:37:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	IDataSet resultData = callSharedBizComponentByDirect("com.SHARE", "fSearchUserPop", requestData, onlineCtx);

			IRecordSet rs = resultData.getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 본사직원조회(팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-29 16:19:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchEmpPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSearchEmpPop", requestData, onlineCtx);
	    	/*IDataSet resultData = callSharedBizComponentByDirect("com.SHARE", "fSearchEmpPop", requestData, onlineCtx);
			IRecordSet rs = resultData.getRecordSet("ds");
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);*/
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * [PM]권한그룹목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-03 16:25:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSearchAuthGrp", requestData, onlineCtx);//com.SHARE@FBASE_fSearchAuthGrp
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * [PM]에이전트조회(회원가입시) - 사용자정보 참조안함
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-05 17:31:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentNoMember(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
	    try {
			responseData = callSharedBizComponentByDirect("com.SHARE", "fSearchAgentNoMember", requestData, onlineCtx); //"gridagent"
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
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-13 16:13:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAllUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	IDataSet resultData = callSharedBizComponentByDirect("com.SHARE", "fSearchAllUserPop", requestData, onlineCtx);

			IRecordSet rs = resultData.getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

}

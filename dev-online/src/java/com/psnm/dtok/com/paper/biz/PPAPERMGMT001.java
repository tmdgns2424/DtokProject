package com.psnm.dtok.com.paper.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PPAPERMGMT001</li>
 * <li>설 명 : 쪽지함 PU</li>
 * <li>작성일 : 2015-01-07 13:51:11</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class PPAPERMGMT001 extends
		nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PPAPERMGMT001() {
		super();
	}

	/**
	 * 받은쪽지 리스트 조회(전체, 조건 조회)
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fSearchRcvPaper(requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 보낸쪽지 리스트 조회(전체, 조건 조회)
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSndPaper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fSearchSndPaper(requestData, onlineCtx);

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
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteSndPaper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			fu.fDeleteSndPaper(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}


   
	/**
	 * 받은쪽지 상세조회
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchRvcPaperDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fSearchRcvPaperDtl(requestData, onlineCtx);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * 보낸쪽지 상세 조회
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 14:01:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSndPaperDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
	    	FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
	    	responseData = fu.fSearchSndPaperDtl(requestData, onlineCtx);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	   
	    return responseData;
	}

	/**
	 * 쪽지쓰기
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 17:09:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertPaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fInsertPaper(requestData, onlineCtx);
			
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
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			fu.fDeleteRcvPaper(requestData, onlineCtx);
			
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
	 * @since 2015-01-15 13:44:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSaleTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fSearchSaleTeam(requestData, onlineCtx);

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
	 * @since 2015-01-16 15:22:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pAgntList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fAgntList(requestData, onlineCtx);

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
	 * @since 2015-01-20 09:49:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeletePaper(IDataSet requestData, IOnlineContext onlineCtx) {
		 IDataSet responseData = new DataSet();
		 try {
		 	
		 	FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
		 	responseData = fu.fDeletePaper(requestData, onlineCtx);
         
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
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fSearchUserPop(requestData, onlineCtx);

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
	 * @since 2015-01-07 13:51:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertRePaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	
			FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
			responseData = fu.fInsertRePaper(requestData, onlineCtx);
			
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
	 * @since 2015-04-17 09:21:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchOpend(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
        try {
            FPAPERMGMT001 fu = (FPAPERMGMT001) lookupFunctionUnit(FPAPERMGMT001.class);
            responseData = fu.fSearchOpend(requestData, onlineCtx);  
        } catch (BizRuntimeException be) {
            throw be;
        } catch (Exception e) {
            throw new BizRuntimeException("PSNM-E000", e);
        }
	    return responseData;
	}

}

package com.psnm.dtok.com.paper.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FPAPERMGMT001</li>
 * <li>설 명 : 쪽지함 FU</li>
 * <li>작성일 : 2015-01-07 13:51:42</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class FPAPERMGMT001 extends
		nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FPAPERMGMT001() {
		super();
	}

	/**
	 * 받은쪽지 정보조회
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:42
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchRcvPaper(IDataSet requestData,
			IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			DRCVPAPER001 du = (DRCVPAPER001) lookupDataUnit(DRCVPAPER001.class);
			
			int count = du.dSearchRcvCount(requestData, onlineCtx).getRecordSet("COUNT").getRecord(0).getInt("COUNT");
			responseData = du.dSearchRcvPaper(requestData, onlineCtx); 

			responseData.getRecordSet("gridpaper").setPageNo(requestData.getIntField("page"));
			responseData.getRecordSet("gridpaper").setRecordCountPerPage(requestData.getIntField("page_size"));
			responseData.getRecordSet("gridpaper").setTotalRecordCount(count);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 보낸쪽지 정보조회
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:42
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSndPaper(IDataSet requestData,
			IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			DSNDPAPER001 du = (DSNDPAPER001) lookupDataUnit(DSNDPAPER001.class);
			
			int count = du.dSearchSndCount(requestData, onlineCtx).getRecordSet("COUNT").getRecord(0).getInt("COUNT");
			responseData = du.dSearchSndPaper(requestData, onlineCtx);
			
			responseData.getRecordSet("gridpaper").setPageNo(requestData.getIntField("page")); 
			responseData.getRecordSet("gridpaper").setRecordCountPerPage(requestData.getIntField("page_size"));
			responseData.getRecordSet("gridpaper").setTotalRecordCount(count);
			
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
	 * @since 2015-01-07 13:51:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteSndPaper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
	    	
			IRecordSet rs =  requestData.getRecordSet("gridpaper");
	    	DSNDPAPER001 du = (DSNDPAPER001) lookupDataUnit(DSNDPAPER001.class);
	    	
	    	IDataSet listData = new DataSet();

	    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
	    		listData.putFieldMap(rs.getRecordMap(i));

	    		if("D".equals(listData.getField("FLAG"))){
		    		requestData.putField("PAPER_ID", listData.getField("PAPER_ID"));
		    		du.dDeleteSndPaper(requestData, onlineCtx);
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
	 * 받은쪽지 상세조회
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:42
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchRcvPaperDtl(IDataSet requestData,
			IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			DRCVPAPER001 du = (DRCVPAPER001) lookupDataUnit(DRCVPAPER001.class);

			//상세조회 데이터 가져오기
	    	responseData.putFieldMap(du.dSearchRcvPaperDtl(requestData, onlineCtx).getFieldMap());
			

			// 첨부파일 조회
			if (requestData.getField("ATCH_FILE_YN").equals("첨부")) {
				IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
				responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
			}
			
			//받은 쪽지가 미열람인경우 - 받은쪽지를 클릭해서 상세로 보면 
			if (requestData.getField("IS_OPEND").equals("N")) {	
				du.dUpdateRcvPaper(requestData, onlineCtx);
			}
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 14:04:36
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSndPaperDtl(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			DSNDPAPER001 du = (DSNDPAPER001) lookupDataUnit(DSNDPAPER001.class);
			//상세조회 데이터 가져오기
	    	responseData.putFieldMap(du.dSearchSndPaperDtl(requestData, onlineCtx).getFieldMap());
			
			//파일 출력
			if (requestData.getField("ATCH_FILE_YN").equals("첨부")) {
				IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
				responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
			}
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);

		return responseData;
	}

	/**
	 * 쪽지쓰기
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 17:09:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertPaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	DRGSTPAPER001 du = (DRGSTPAPER001) lookupDataUnit(DRGSTPAPER001.class);
	    	DSNDPAPER001 du1 = (DSNDPAPER001)  lookupDataUnit(DSNDPAPER001.class);
	    	DRCVPAPER001 du2 = (DRCVPAPER001)  lookupDataUnit(DRCVPAPER001.class);
	    	
			IRecordSet rsSeq = du.dSeqSelect(requestData, onlineCtx).getRecordSet("ds");
			
			Map<String, Object> map = rsSeq.getRecordMap(0);
			String PAPER_ID = String.valueOf(map.get("PAPER_ID"));

			requestData.putField("PAPER_ID", PAPER_ID);
			
			//보낸쪽지등록
			du1.dInsertSndPaper(requestData, onlineCtx); // 보낸쪽지 등록

			//받은 쪽지 등록
			int count = requestData.getRecordSet("grid").getRecordCount();
			
			for(int a=0; a<count; a++){
				IDataSet listData = new DataSet();
				
				listData.putField("PAPER_ID",PAPER_ID);
				listData.putField("S_USER_ID", onlineCtx.getUserInfo().get("USER_ID").toString());
				listData.putField("RCV_USER_ID",requestData.getRecordSet("grid").get(a,"USER_ID"));

				du2.dInsertRcvPaper(listData, onlineCtx);

			}
			//파일 등록
			if(requestData.getRecordSet("gridfile") != null){				
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
			}
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);

	    return responseData;
	}
	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:51:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	//클라이언트 단에서 가져온정보를  IRecordSet 으로 저장한다. 
	    	IRecordSet rs =  requestData.getRecordSet("gridpaper");
	    	DRCVPAPER001 du = (DRCVPAPER001) lookupDataUnit(DRCVPAPER001.class);
	    	
			//저장한 IRecordSet에 크기만큼 포문을 돌린다. -> 그페이지에 보이는 데이터의 갯수 
	    	
	    	IDataSet listData = new DataSet();
	    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
	    		listData.putFieldMap(rs.getRecordMap(i));
	    		
	    		if("D".equals(listData.getField("FLAG"))){
		    		requestData.putField("PAPER_ID", listData.getField("PAPER_ID"));
		    		requestData.putField("RCV_USER_ID", listData.getField("RCV_USER_ID"));
			    		
		    		du.dDeleteRcvPaper(requestData, onlineCtx);
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
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 13:45:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSaleTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    try {

	    	DRGSTPAPER001 du = (DRGSTPAPER001) lookupDataUnit(DRGSTPAPER001.class);

			responseData = du.dSearchSaleTeam(requestData, onlineCtx);
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);

		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-16 15:18:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fAgntList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {

	    	DRGSTPAPER001 du = (DRGSTPAPER001) lookupDataUnit(DRGSTPAPER001.class);

			responseData = du.dAgntList(requestData, onlineCtx);
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-20 09:52:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeletePaper(IDataSet requestData, IOnlineContext onlineCtx) {
		 IDataSet responseData = new DataSet();
			
		    try {
		    	DRCVPAPER001 du =(DRCVPAPER001) lookupDataUnit(DRCVPAPER001.class);
		    	DSNDPAPER001 du1 =(DSNDPAPER001) lookupDataUnit(DSNDPAPER001.class);
				
				if (requestData.getFieldCount()==1){
					du1.dDeleteSndPaper(requestData, onlineCtx);
					
				}else{
					du.dDeleteRcvPaper(requestData, onlineCtx);
				}
					
		    } catch (BizRuntimeException be) {
				throw be;
			} catch (Exception e) {
				throw new BizRuntimeException("PSNM-E000", e);
			}
			responseData.setOkResultMessage("PSNM-I000", null);
		
		    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 17:28:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {

	    	DRGSTPAPER001 du = (DRGSTPAPER001) lookupDataUnit(DRGSTPAPER001.class);

			responseData = du.dSearchUserPop(requestData, onlineCtx);
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-04-06 15:25:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertRePaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	DRGSTPAPER001 du = (DRGSTPAPER001) lookupDataUnit(DRGSTPAPER001.class);
	    	DSNDPAPER001 du1 = (DSNDPAPER001)  lookupDataUnit(DSNDPAPER001.class);
	    	DRCVPAPER001 du2 = (DRCVPAPER001)  lookupDataUnit(DRCVPAPER001.class);
	    	
			IRecordSet rsSeq = du.dSeqSelect(requestData, onlineCtx).getRecordSet("ds");
			
			Map<String, Object> map = rsSeq.getRecordMap(0);
			String PAPER_ID = String.valueOf(map.get("PAPER_ID"));

			requestData.putField("PAPER_ID", PAPER_ID);
			
			//보낸쪽지등록
			du1.dInsertSndPaper(requestData, onlineCtx); // 보낸쪽지 등록

			//받은 쪽지 등록
			du2.dInsertRcvPaper(requestData, onlineCtx);

			//파일 등록
			if(requestData.getRecordSet("gridfile") != null){				
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
			}
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);

	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-04-17 09:22:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchOpend(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    DRGSTPAPER001 du = (DRGSTPAPER001) lookupDataUnit(DRGSTPAPER001.class);
	    System.out.println("###");

	    responseData = du.dSearchRead(requestData, onlineCtx);      
	    System.out.println("111");
		IRecordSet rs = responseData.getRecordSet("ds");
	    System.out.println("222");
		if("Y".equals(requestData.getField("IS_OPEND"))){
			responseData.putRecordSet("grid1", rs);
		}else{
			responseData.putRecordSet("grid2", rs);
		}
	    
	    return responseData;
	}

}

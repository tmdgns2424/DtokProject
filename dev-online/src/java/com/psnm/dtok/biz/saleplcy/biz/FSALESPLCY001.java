package com.psnm.dtok.biz.saleplcy.biz;

import com.psnm.common.util.PsnmStringUtil;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.BaseUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FSALESPLCY001</li>
 * <li>설  명 : 영업정책관리FU</li>
 * <li>작성일 : 2014-11-19 16:28:20</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FSALESPLCY001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSALESPLCY001(){
		super();
	}

	/**
	 * 영업정책관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
	    try {
	    	
			requestData.putField("NEW_PRD", BaseUtils.getConfiguration("brd.new.prd"));
	    	
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	
			responseData = du.dSearchSalesPlcy(requestData, onlineCtx);
			responseData.putField("count", du.dSearchSalesPlcyCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    
	    return responseData;
	}
	
	/**
	 * 영업정책관리 상세정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DSALESPLCY001  du1 = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	DPLCYRCVGRP001 du2 = (DPLCYRCVGRP001) lookupDataUnit(DPLCYRCVGRP001.class);
	    	DPLCYRCVORG001 du3 = (DPLCYRCVORG001) lookupDataUnit(DPLCYRCVORG001.class);
	    	
	    	responseData.putRecordSet("gridauthgrp", du2.dSearchPlcyRcvGrpAuthObjet(requestData, onlineCtx).getRecordSet("ds"));

	    	if(!PsnmStringUtil.isEmpty(requestData.getField("DSM_SALES_PLCY_ID"))){
	    		
	    		responseData.putFieldMap(du1.dDetailSalesPlcy(requestData, onlineCtx).getFieldMap());
	    		responseData.putRecordSet("gridauthorg", du3.dSearchPlcyRcvOrgDeptObject(requestData, onlineCtx).getRecordSet("ds"));
			    
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
	 * 영업정책관리 정보를 추가하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
			
			du.dInsertSalesPlcy(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DSALESPLCY001  du1 = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	DPLCYRCVGRP001 du2 = (DPLCYRCVGRP001) lookupDataUnit(DPLCYRCVGRP001.class);
	    	DPLCYRCVORG001 du3 = (DPLCYRCVORG001) lookupDataUnit(DPLCYRCVORG001.class);
	    	
	    	du1.dUpdateSalesPlcy(requestData, onlineCtx);
			du2.dDeletePlcyRcvGrp(requestData, onlineCtx);
			du3.dDeletePlcyRcvOrg(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리공지그룹을 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSalesPlcyGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	DPLCYRCVGRP001 du = (DPLCYRCVGRP001) lookupDataUnit(DPLCYRCVGRP001.class);
		
		    IRecordSet rs =  requestData.getRecordSet("gridauthgrp");
		    String tmpPlcyId = requestData.getField("DSM_SALES_PLCY_ID");
		    
		    if(rs != null){
		    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
					listData.putFieldMap(rs.getRecordMap(i));
					requestData = listData;
					requestData.putField("SALES_PLCY_ID", tmpPlcyId);
					du.dInsertPlcyRcvGrp(requestData, onlineCtx);
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
	 * 영업정책을 공지할 영업국을 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSalesPlcyOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DPLCYRCVORG001 du = (DPLCYRCVORG001) lookupDataUnit(DPLCYRCVORG001.class);
		
	    	IRecordSet rs =  requestData.getRecordSet("gridauthorg");
		    String tmpPlcyId = requestData.getField("DSM_SALES_PLCY_ID");
		    
		    if(rs != null){
		    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
					listData.putFieldMap(rs.getRecordMap(i));
					requestData = listData;
					requestData.putField("SALES_PLCY_ID", tmpPlcyId);
					du.dInsertPlcyRcvOrg(requestData, onlineCtx);
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
	 * 영업정책관리통계를 조회 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesPlcyStc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	
	    	responseData = du.dSearchSalesPlcyStc(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
			
			du.dDeleteSalesPlcy(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리 접속현황을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesPlcyContact(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	
	    	responseData = du.dSearchSalesPlcyContact(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책수신조직공지대상영업국 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-12 11:05:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchPlcyRcvOrgDeptTarget(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DPLCYRCVORG001 du = (DPLCYRCVORG001) lookupDataUnit(DPLCYRCVORG001.class);
	    	
	    	IRecordSet dataList = requestData.getRecordSet("N_OUT_ORG_DTL_ID");
	    	int cntDataList = null==dataList ? 0 : dataList.getRecordCount();

	    	if (cntDataList > 0) {
	    		String[] deptId = new String[cntDataList];
	    		for(int i=0; i < cntDataList; i++) {
	    			deptId[i] = dataList.get(i, "SALE_DEPT_ORG_ID");
	    		}
	    		requestData.putField("N_OUT_ORG_DTL_ID", deptId);
	    	}
	    	
	    	responseData = du.dSearchPlcyRcvOrgDeptTarget(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 10:15:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesPlcyBrws(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	
	    	requestData.putField("DUTY_CD_YN", "N");
			
			String DUTY = onlineCtx.getUserInfo().get("DUTY").toString();
			String ATTC_CAT = onlineCtx.getUserInfo().get("ATTC_CAT").toString();
			
		    if( ( ATTC_CAT.startsWith("1") || ATTC_CAT.startsWith("2") ) || (ATTC_CAT.equals("3") && !DUTY.equals("14")) ){
		    	requestData.putField("DUTY_CD_YN", "Y");
			} else {
		    	requestData.putField("DUTY_CD_YN", "N");
			}
	    	
			responseData = du.dSearchSalesPlcyBrws(requestData, onlineCtx);
			responseData.putField("count", du.dSearchSalesPlcyBrwsCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리통계영업국명 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 15:46:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalesPlcyStcDept(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
	    	
			responseData = du.dSearchSalesPlcyStcDept(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}

package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IRecordSet;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : MRTGSMSBAT</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-04-13 16:12:23</li>
 * <li>작성자 : 허용 (06476)</li>
 * </ul>
 */
public class MRTGSMSBAT extends AbsBatchComponent {
    private Log log;
    private BigDecimal batchJobSeq;    
    
    public MRTGSMSBAT() {
        super();
    }

    /**
     * 배치 전처리 메소드. 
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    public void beforeExecute(IBatchContext context) {
		log = getLog(context);
		
    }

    /**
     * 배치 메인 메소드
     */
    public void execute(final IBatchContext context) {
    	Map<String, String> param = context.getInParameters();
    	String msg = "";
    	
    	try {
        	txBegin();

        	//##################################################################################
    		// 
    		//##################################################################################
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "담보만료안내");
    		int insJob = dbInsert("dInsertBatchJobLog", param, context);
    		
    		txCommit();
    		txBegin();    		
    		
    	    IDataSet requestData = new DataSet();    		
    	    IDataSet responseData = new DataSet();    		

    		//IRecordSet rs = dbSelect("dSelectMrtgList", requestData.getFieldMap(), context);
    		IRecordSet rs = dbSelectMulti("dSelectMrtgList", requestData.getFieldMap(), context);    		
    		
    		Map<String, Object> paramMap  = null;
    		int sndCnt = 0;
    		
    		if(rs != null && rs.getRecordCount() >0 ){
	    		for(int i = 0 ; i < rs.getRecordCount() ; i++) {
	
	    			paramMap = rs.getRecordMap(i);
		    		
		    		BigDecimal smsTranSeq = dbSelectSingle("dSelectSmsTranSeq", param, context).getBigDecimal("TRAN_CNT");
		    		BigDecimal telnkCmpMsgId = dbSelectSingle("dSelectSmsCmpMsgSeq", param, context).getBigDecimal("CMP_MSG_ID");
		    			    			    		
		    		paramMap.put("TRAN_CNT", smsTranSeq);
		    		paramMap.put("CMP_MSG_ID", telnkCmpMsgId);
		    		paramMap.put("ERR_YN", "N");	   	    		  		
		    		
		    		
		    		int msgCnt = dbInsert("dInsertSmsTran", paramMap, context);
		    		msgCnt = dbInsert("dInsertSmsTranDtl", paramMap, context);			
		    		msgCnt = dbInsert("dInsertTelinkSms", paramMap, context);	    		
		    			    
		    		sndCnt++;
		    	}
    		}    		    	    			
    		msg +="담보만료안내 : " + sndCnt + "건";	    		
    		
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		int updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
    		
			txCommit();
    		
    	}
    	catch (Exception e) {
    		txRollback();
    		
    		try {
    			txBegin();
    			
	    		param.put("JOB_SUSS_YN", "N"); //작업성공여부(Y:성공, N:실패)
	    		param.put("ERR_MSG", e.getMessage()); //에러메세지
	    		int updJob = dbUpdate("dUpdateBatchJobLog", param, context);

				txCommit();
				txBegin();

	    		BigDecimal smsTranSeq = dbSelectSingle("dSelectSmsTranSeq", param, context).getBigDecimal("TRAN_CNT");
	    		BigDecimal telnkCmpMsgId = dbSelectSingle("dSelectSmsCmpMsgSeq", param, context).getBigDecimal("CMP_MSG_ID");
	    		if (log.isDebugEnabled()) log.debug("####################### TRAN_CNT = " + smsTranSeq + ", CMP_MSG_ID = "+ telnkCmpMsgId);
	    		
	    		param.put("TRAN_CNT", String.valueOf(smsTranSeq));
	    		param.put("CMP_MSG_ID", String.valueOf(telnkCmpMsgId));
	    		param.put("CONTEXT", "담보만료안내 오류");
	    		param.put("ERR_YN", "Y");	    		
	    		
	    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
	    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
	    		
	    		param.put("SND_MSG", "담보만료안내 오류");
	    		msgCnt = dbInsert("dInsertTelinkSms", param, context);
	    		
	    		txCommit();
	    	}
	    	catch (Exception se) {
	    		txRollback();
	    	}
    	}
    }
    
    /**
     * 배치 후처리 메소드. 
     * beforeExecute(), execute() 의 Exception 발생 여부와 관계없이 이 메소드는 실행됨
     */
    public void afterExecute(IBatchContext context) {
        if (super.exceptionInExecute == null) {
            // execute() 정상인 경우
            
        }else {
            // execute() 에서 에러 발생할 경우
            
        }
    }

}

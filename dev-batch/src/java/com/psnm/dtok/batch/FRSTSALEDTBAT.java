package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : FRSTSALEDTBAT</li>
 * <li>설  명 : 에이전트별 최초매출일자 갱신</li>
 * <li>작성일 : 2015-04-08 19:59:40</li>
 * <li>작성자 : 채수윤 (chesuyun)</li>
 * </ul>
 */
public class FRSTSALEDTBAT extends AbsBatchComponent {
    private Log log;
    private BigDecimal batchJobSeq;
    
    public FRSTSALEDTBAT() {
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

    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "최초매출일자갱신");
    		int insJob = dbInsert("dInsertBatchJobLog", param, context);
    		
    		txCommit();
    		txBegin();
    		
    		msg ="";
    		int atchFileCnt = dbUpdate("dUpdateFrstSaltDt", param, context);
    		msg +="최초매출일 수정 : " + atchFileCnt + "건";
    		
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
		    		param.put("CONTEXT", "최초매출일자 갱신 작업 오류");
		    		
		    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
		    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
		    		
		    		param.put("SND_MSG", "최초매출일자 갱신 작업 오류");
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

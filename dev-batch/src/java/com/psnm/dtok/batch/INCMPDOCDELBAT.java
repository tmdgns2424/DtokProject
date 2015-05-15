package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : INCMPDOCDELBAT</li>
 * <li>설  명 : 3개월 전 미비서류접수건(매월10일) 삭제</li>
 * <li>작성일 : 2015-04-08 18:13:03</li>
 * <li>작성자 : 채수윤 (chesuyun)</li>
 * </ul>
 */
public class INCMPDOCDELBAT extends AbsBatchComponent {
    private Log log;
    private BigDecimal batchJobSeq;
    
    public INCMPDOCDELBAT() {
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
    		param.put("JOB_BATCH_NM", "미비서류접수 삭제");
    		int insJob = dbInsert("dInsertBatchJobLog", param, context);

    		txCommit();
    		txBegin();

    		msg ="";
    		// 1. 첨부파일 삭제
    		int atchFileCnt = dbDelete("dDeleteIncmpDocAtchFile", param, context);
    		msg +="미비서류접수 첨부파일 삭제 : " + atchFileCnt + "건";
    		// 2. 첨부파일관리 삭제 
    		int atchFileMgmtCnt = dbDelete("dDeleteIncmpDocAtchFileMgmt", param, context);
    		msg +=", 미비서류접수 첨부파일관리 삭제 : " + atchFileMgmtCnt + "건";
    		// 3. 미비서류접수 첨부유형이력 삭제
    		int incmpDocHstCnt = dbDelete("dDeleteIncmpDocTypHst", param, context);
    		msg +=", 미비서류접수 첨부유형이력 삭제 : " + incmpDocHstCnt + "건";
    		// 4. 미비서류접수 삭제
    		int incmpDocCnt = dbDelete("dDeleteIncmpDoc", param, context);
    		msg +=", 미비서류접수 삭제 : " + incmpDocCnt + "건";
    		
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
	    		param.put("CONTEXT", "미비서류접수 삭제 작업 오류");
	    		
	    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
	    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
	    		
	    		param.put("SND_MSG", "미비서류접수 삭제 작업 오류");
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

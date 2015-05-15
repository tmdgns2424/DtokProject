package com.psnm.dtok.com.paper.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>설 명 : </li>
 * <li>작성일 : 2015-01-07 13:50:23</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class PAPERBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "com.PAPER";
    }

}

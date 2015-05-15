package com.psnm.dtok.com.sys.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>설 명 : [BC]공통-시스템 공통처리</li>
 * <li>작성일 : 2015-02-24 16:35:07</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class SYSBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "com.SYS";
    }

}

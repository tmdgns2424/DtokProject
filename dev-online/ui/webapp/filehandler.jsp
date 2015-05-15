<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%><%@page import="java.io.InputStream"%><%@page import="java.util.List"%><%@page import="nexcore.framework.core.util.BaseUtils"%><%@page import="nexcore.framework.online.channel.web.helper.MultipartRequestWrapper"%><%@page import="com.psnm.common.file.FileResource"%><%@page import="com.psnm.common.file.FileResourceManager"%><%@page import="org.apache.commons.fileupload.FileItem"%><%@page import="org.apache.commons.fileupload.util.Streams"%><%
    MultipartRequestWrapper wrapper = new MultipartRequestWrapper(request, FileResourceManager.getFileUploadTempPath(), FileResourceManager.getFileUploadMaxSize(), "UTF-8"); //{"KSC5601","8859_1", "ascii", "UTF-8", "EUC-KR", "MS949"}; //FileResourceManager.getFileUploadEncoding()
    String cmd = wrapper.getParameter("cmd");
    String biz = wrapper.getParameter("biz");

    //System.out.println("<filehandler> <download> biz = [" + biz + "], dir = [" + wrapper.getParameter("dir") + "]");

    if ("download".equals(cmd)) {
        String id   = wrapper.getParameter("id"); 
        String name = wrapper.getParameter("name");
        String filename = java.net.URLEncoder.encode(name, "UTF-8");
        //System.out.println("<filehandler> <download> 파일명 = [" + name + "], 파일명2 = [" + filename + "]");

        String sIeClient=request.getHeader("User-Agent"); 
        //System.out.println("<filehandler> <download> User-Agent = [" + sIeClient + "]"); 

        if (sIeClient.indexOf("MSIE 5.5")>-1) { 
            response.setContentType("application/octet-stream;"); 
            response.setHeader("Content-Disposition", "filename=" + filename);
            response.setHeader("Pragma", "no-cache;");
            response.setHeader("Expires", "-1;");
        }
        else {
            response.setContentType("application/octet-stream;"); 
            response.setHeader("Content-Disposition", "attachment;filename=" + filename + ";");
            response.setHeader("Pragma", "no-cache;");
            response.setHeader("Expires", "-1;");
        }

        String sdir = wrapper.getParameter("dir"); //(예) &group=annce&dir=psnm/annce/2014/11/13
        //System.out.println("<filehandler> <download> biz = [" + biz + "], dir = [" + sdir + "]");

        InputStream is = FileResourceManager.getUploadFileInputStream(id, biz, sdir);
        Streams.copy(is, response.getOutputStream(), false, new byte[FileResourceManager.getFileDownloadBufferSize()]);
        is.close();
    }
    else if ("delete".equals(cmd)) {
        String id = wrapper.getParameter("id");

        FileResourceManager.removeUploadFile(id);
    }
    else {
        //String dirPrefix = "psnm";
        String env = BaseUtils.getRuntimeMode(); // 런타임환경구분
        String app = biz; //(ASIS=dsma) //wrapper.getParameter("app"); // 어플리케이션코드
        if (null==app || "".equals(app)) {
            app = "DEFAULT";
        }

        List<FileItem> files = wrapper.getFiles();

        //확장자 검사
        for(int i=0;i<files.size();i++){
            FileItem item = (FileItem)files.get(i);

            //System.out.println(">>"+item.getName());
            String fileName = item.getName();
            String fileType = fileName.substring(fileName.lastIndexOf(".")+1,fileName.length());

            //System.out.println("fileType"+fileType);
            if ("jsp".equals(fileType) || "exe".equals(fileType)){
                files.remove(i);
            }
        }
        
        List<FileResource> resources = FileResourceManager.storeUploadFile(files, env, app);

        StringBuffer result = new StringBuffer();

        result.append("[");

        int i = 0;

        if (resources != null) {
            for (FileResource fr : resources) {
                //System.out.println("\t- 업로드파일정보[" + i + "] " + resources.get(i));
                if (i > 0)
                    result.append(",");

                result.append("{");
                result.append("\"id\":\"" + fr.getStoredName() + "\"");
                result.append(",\"name\":\"" + fr.getOriginalName() + "\"");
                result.append(",\"type\":\"" + fr.getContentType() + "\"");
                result.append(",\"dir\":\"" + fr.getStoredDir() + "\""); //@@= FILE_PATH
                result.append(",\"group\":\"" + fr.getGroupId() + "\""); //@@= FILE_GRP_ID(=업무구분)
                result.append(",\"size\":" + fr.getSize());
                // fr.getContentType()
                // app
                result.append("}");
    
                i++;
            }
        }

        result.append("]");

        out.print(result.toString());
        //System.out.println("<filehandler> result   :   "+result.toString());
    }
%>
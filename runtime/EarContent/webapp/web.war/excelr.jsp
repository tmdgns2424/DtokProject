<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import="nexcore.framework.core.util.DateUtils"%>
<%@page import="java.io.*"%>
<%@page import="org.apache.poi.hssf.extractor.ExcelExtractor"%>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%
//[Parameter]
	String EXCEL_FILE_NAME = "/"+request.getParameter("upFile"); 
%>
<%
	try {
		//1.엑셀 파일로부터 POI workbook 생성
		POIFSFileSystem fs = new POIFSFileSystem(new BufferedInputStream(new FileInputStream(EXCEL_FILE_NAME)));
		//2.워크북을 생성!               
	    HSSFWorkbook wb = new HSSFWorkbook(fs);
	    //3.Text 추출
	    ExcelExtractor extractor = new ExcelExtractor(fs);
        extractor.setFormulasNotResults(true);
        extractor.setIncludeSheetNames(false);
        String data = extractor.getText();
        out.print(data);
	} catch (Exception e) {
%>
Error occurred:
<%=e.getMessage()%>
<%
	e.printStackTrace();
	}
%>


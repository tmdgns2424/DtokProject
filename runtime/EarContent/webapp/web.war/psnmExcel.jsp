<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@page import="org.apache.poi.hssf.util.*"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="nexcore.framework.core.util.DateUtils"%>
<%@page language="java" contentType="application/vnd.ms-excel;charset=UTF-8"%><%
//
    ArrayList<Map<String, String>> metaInfoList = getParamData( request.getParameter("metaInfo") );
    int metaInfoListCount = null==metaInfoList ? 0 : metaInfoList.size();

    String filename = getFilename(metaInfoList); //엑셀파일을 결정
    File excelfile  = getFile(filename); //임시로 엑셀파일을 생성

    try {

        //1. 엑셀 워크북
        HSSFWorkbook wb = new HSSFWorkbook();

        //2. 엑셀 공통 변수
        HSSFFont titleFont = createTitleCellFont(wb);
        HSSFFont dataFont  = createDataCellFont(wb);
        HSSFCellStyle titleStyle = createTitleCellStyle(wb, titleFont); //제목 셀 스타일
        HSSFCellStyle dataStyleL = createDataCellStyle(wb, "left",   dataFont);
        HSSFCellStyle dataStyleC = createDataCellStyle(wb, "center", dataFont);
        HSSFCellStyle dataStyleR = createDataCellStyle(wb, "right",  dataFont);

        for(int x=0; x<metaInfoListCount; x++) {
            Map<String, String> metaInfo = metaInfoList.get(x); //(예) { sheetname : "공지사항목록", gridname  : "grid" }
            String sheetname = metaInfo.get("sheetname");
            String gridname  = metaInfo.get("gridname");

            System.out.println("-- 메타정보[" + x + "] : " + metaInfo + "");

            String strGridMeta = request.getParameter( gridname + "_cols" ); //칼럼 매핑 정보 (객체의 배열 --> list of map)
            String strGridData = request.getParameter( gridname + "_data" ); //그리드 데이터  (객체의 배열 --> list of map)

            ArrayList<Map<String, String>> colsList = getParamData( strGridMeta );
            ArrayList<Map<String, String>> dataList = getParamData( strGridData );
            int colsSize = null==colsList ? 0 : colsList.size();
            int dataSize = null==dataList ? 0 : dataList.size();
            System.out.println("-- colsSize = [" + colsSize + "] : dataSize = " + dataSize + "");
            
            //S#1. Sheet 생성
            HSSFSheet sheet = wb.createSheet(sheetname);
            HSSFRow row = null;
            HSSFCell cell = null;

            //S#2. 제목 row 생성
            row = sheet.createRow(0);

            //S#3. 타이틀 셀을 추가함
            for (int j = 0; j < colsSize; j++) {
                Map<String, String> keyMap = colsList.get(j);
                System.out.println("-- keyMap[" + j + "] : " + keyMap + "");
                //(예) columnKey[4] ::: {columnIndex=1, key=ANNCE_TITL_NM, title=제목, resizing=true, width=350px}

                cell = row.createCell(j);
                cell.setCellValue( new HSSFRichTextString(keyMap.get("title")) );
                cell.setCellStyle(titleStyle);

                String sWidth = keyMap.get("width");
                if ( null!=sWidth && !"".equals(sWidth) ) {
                    String tWidth = sWidth.replaceAll("px", "");
                           tWidth = tWidth.replaceAll("Px", "");
                           tWidth = tWidth.replaceAll("PX", "");
                           tWidth = tWidth.replaceAll("%", "");
                    int width = Integer.parseInt(tWidth);
                    sheet.setColumnWidth(j, 39*width); //셀의 너비를 조정
                }
            }

            //S#4. 데이터 셀을 추가
            for (int i = 0; i < dataSize; i++) {
                row = sheet.createRow(i + 1); //header 다음에 row 생성
                row.setHeightInPoints(15);

                Map<String, String> dataMap = dataList.get(i);

                //8. Field Data
                for (int j = 0; j < colsSize; j++) { //데이터의 칼럼은 '칼럼정보' 기준으로 추가함
                    Map<String, String> keyMap = colsList.get(j);
                    String _key   = keyMap.get("key");
                    String _align = keyMap.get("align");
                    //columnKey[5] ::: {columnIndex=4, key=ANNCE_TITL_NM, title=제목, align=center, resizing=true, width=350px}
        
                    cell = row.createCell(j);
                    cell.setCellValue( new HSSFRichTextString(dataMap.get(_key)) );

                    if ( null==_align ) {
                        cell.setCellStyle(dataStyleL);
                    }
                    else if ( "center".equals(_align) ) {
                        cell.setCellStyle(dataStyleC);
                    }
                    else if ( "right".equals(_align) ) {
                        cell.setCellStyle(dataStyleR);
                    }
                    else {
                        cell.setCellStyle(dataStyleL);
                    }
                }
            }
        }

        FileOutputStream fos = new FileOutputStream( excelfile );
        wb.write(fos);
        fos.close();
    }
    catch (Exception e) {
        e.printStackTrace();
    }

    String filename2 = java.net.URLEncoder.encode(filename, "UTF-8");
    
    response.setContentType("application/octet-stream");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Content-Disposition", "attachment;filename=" + filename2 + ";"); //filename
    response.setHeader("Pragma", "no-cache;");
    response.setHeader("Expires", "-1;");

    /*
        InputStream is = FileResourceManager.getUploadFileInputStream(id, biz, sdir);
        Streams.copy(is, response.getOutputStream(), false, new byte[FileResourceManager.getFileDownloadBufferSize()]);
        is.close();
    */
    // body에 전달
    byte b[] = new byte[(int) excelfile.length()];
    out.clear();
    out = pageContext.pushBody();

    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(excelfile));
    BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

    int read = 0;
    while ((read = bis.read(b)) != -1)
        bos.write(b, 0, read);
    bos.close();
    bis.close();
    
    
%><%!
public static File createTempDir() {
    //final String baseTempPath = "/home/itbsuser/workspace_dsma/runtime/EarContent/webapp/web.war/jsp/trms/exd/"; //System.getProperty("java.io.tmpdir");
    final String baseTempPath = nexcore.framework.core.util.BaseUtils.getConfiguration("file.upload.temp.folder");

    Random rand = new Random();
    int randomInt = 1 + rand.nextInt();

    File tempDir = new File(baseTempPath + File.separator + "tempDir" + randomInt);

    if (tempDir.exists() == false) {
        tempDir.mkdirs();
    }
    tempDir.deleteOnExit();

    return tempDir;
}
//
public static String getFilename(ArrayList<Map<String, String>> paramMetaInfoList) {
    String defaultFileName = "PSNM_EXCEL_" + DateUtils.getCurrentDate("yyyyMMddHHmmss") + ".xls"; //DateUtils.getCurrentDate()

    if (null==paramMetaInfoList || paramMetaInfoList.size()<1) {
        System.out.println("- 파일명(기본명칭) : [" + defaultFileName + "]");
        return defaultFileName;
    }

    int count = paramMetaInfoList.size();

    for(int i=0; i<count; i++) {
        Map<String, String> metaInfo = paramMetaInfoList.get(i);
        String filename = metaInfo.get("filename");

        if ( null!=filename && !"".equals(filename) ) {
            defaultFileName = filename;
            System.out.println("- 파일명(화면입력) : [" + defaultFileName + "]");
            break;
        }
    }
    return defaultFileName;
}
public static File getFile(String filename) throws IOException {
    //File FILEDOWNLOAD_FULL_PATH = createTempDir();
    final String baseTempPath = nexcore.framework.core.util.BaseUtils.getConfiguration("file.upload.temp.folder");

    Random rand = new Random();
    int randomInt = 1 + rand.nextInt();

    File tempDir = new File(baseTempPath + File.separator + "tempDir" + randomInt);

    if (tempDir.exists() == false) {
        tempDir.mkdirs();
    }
    tempDir.deleteOnExit();
    
    System.out.println("- 엑셀다운로드 임시디렉토리 : [" + tempDir.getAbsolutePath() + "]");

    String fullpath = tempDir.toString() + filename;

    File file = new File(tempDir, filename);
    System.out.println("- 엑셀다운로드 임시파일경로 : [" + file.getAbsolutePath() + "]");

    file.createNewFile();

    return file;
}
public static ArrayList<Map<String, String>> getParamData(String rawStrData) throws UnsupportedEncodingException {
    //System.out.println("<getParamData> rawStrData = [" + rawStrData + "]");
    if (null==rawStrData) {
        return new ArrayList<Map<String, String>>();
    }
    Gson gson = new Gson();

    //final Type mapType     = new TypeToken<Map<String, String>>(){}.getType();
    final Type mapListType = new TypeToken<List<Map<String, String>>>(){}.getType();

    String decodedStrData = URLDecoder.decode(rawStrData, "UTF-8");

    ArrayList<Map<String, String>> dataList = gson.fromJson(decodedStrData, mapListType);
    int dataListCount = null==dataList ? 0 : dataList.size();

    for(int i=0; i<dataListCount; i++) {
        Map<String, String> aRecord = dataList.get(i);
        System.out.println("- data[" + i + "] : " + aRecord + "");
    }
    return dataList;
}

public static HSSFCellStyle createTitleCellStyle(HSSFWorkbook wb, HSSFFont titleFont) {
    //4. style 생성
    HSSFCellStyle titleStyle = wb.createCellStyle();
    titleStyle.setWrapText(true);
    // Align
    titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); //중앙 정렬
    titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
    // Layout Line
    titleStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
    titleStyle.setBottomBorderColor(HSSFColor.BLACK.index);
    titleStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
    titleStyle.setLeftBorderColor(HSSFColor.BLACK.index);
    titleStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
    titleStyle.setRightBorderColor(HSSFColor.BLACK.index);
    titleStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
    titleStyle.setTopBorderColor(HSSFColor.BLACK.index);
    // Fill
    titleStyle.setFillForegroundColor(HSSFColor.GREY_80_PERCENT.index);
    titleStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

    if ( null!=titleFont ) {
        titleStyle.setFont(titleFont);
    }
    return titleStyle;
}
public static HSSFCellStyle createDataCellStyle(HSSFWorkbook wb, String align, HSSFFont cellFont) {
    //Field style 생성 - 앞서 style과 동일 적용시에는 추가 생성 필요 없음
    HSSFCellStyle style = wb.createCellStyle();
    style.setWrapText(true);
    // Align
    if ( null==align ) {
        style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
    }
    else if ( "center".equals(align) ) {
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    }
    else if ( "right".equals(align) ) {
        style.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
    }
    else {
        style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
    }
    style.setVerticalAlignment(HSSFCellStyle.VERTICAL_TOP);
    // Layout Line
    style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
    style.setBottomBorderColor(HSSFColor.BLACK.index);
    style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
    style.setLeftBorderColor(HSSFColor.BLACK.index);
    style.setBorderRight(HSSFCellStyle.BORDER_THIN);
    style.setRightBorderColor(HSSFColor.BLACK.index);
    style.setBorderTop(HSSFCellStyle.BORDER_THIN);
    style.setTopBorderColor(HSSFColor.BLACK.index);
    // Fill
    style.setFillForegroundColor(HSSFColor.WHITE.index);
    style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

    if ( null!=cellFont ) {
        style.setFont(cellFont);
    }
    else {
        // font
        cellFont = wb.createFont();
        cellFont.setFontName("맑은 고딕");
        cellFont.setFontHeightInPoints((short) 10);
        cellFont.setColor(HSSFColor.BLACK.index);
        style.setFont(cellFont);
    }
    return style;
}

public static HSSFFont createTitleCellFont(HSSFWorkbook wb) {
    HSSFFont titleFont = wb.createFont();
    titleFont = wb.createFont();
    titleFont.setFontName("맑은 고딕");
    titleFont.setFontHeightInPoints((short) 10);
    titleFont.setColor(HSSFColor.WHITE.index); //흰색
    return titleFont;
}
public static HSSFFont createDataCellFont(HSSFWorkbook wb) {
    HSSFFont cellFont = wb.createFont();
    cellFont.setFontName("맑은 고딕");
    cellFont.setFontHeightInPoints((short) 10);
    cellFont.setColor(HSSFColor.BLACK.index); //검은색
    return cellFont;
}
%>
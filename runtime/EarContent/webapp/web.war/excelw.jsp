<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="nexcore.framework.core.util.DateUtils"%>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@page import="org.apache.poi.hssf.util.*"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page language="java" contentType="application/vnd.ms-excel;charset=UTF-8"%>

<%!public static File createTempDir() {
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
	}%>
<%
	//[Parameter]
	int length = Integer.parseInt(request.getParameter("count"));
	//[Setting]
	File FILEDOWNLOAD_FULL_PATH = createTempDir();
	String fileName = "EP_" + DateUtils.getCurrentDate() + ".xls";
	String EXCEL_FILE_NAME = FILEDOWNLOAD_FULL_PATH.toString() + fileName;

	File file = new File(EXCEL_FILE_NAME);
	file.createNewFile();
	try {
		//1.엑셀 파일 생성
		HSSFWorkbook wb = new HSSFWorkbook();

		//3. 관련 변수 선언
		HSSFRow row = null;
		HSSFCell cell = null;
		HSSFCellStyle style = null;
		HSSFFont font = null;
		for (int c = 0; c < length; c++) {
			String[] groups = URLDecoder.decode(request.getParameter("group" + c), "UTF-8").split("\\|");
			String[] headers = URLDecoder.decode(request.getParameter("header" + c), "UTF-8").split("\\|");
			String[] datas = URLDecoder.decode(request.getParameter("data" + c), "UTF-8").split("\\$");
			
			//2. Sheet 생성
			HSSFSheet sheet = wb.createSheet("Sheet" + (c + 1));
			//4. row 생성
			row = sheet.createRow(0);
			// row.setHeightInPoints(140); //지정한 수치만큼 높이 지정 가능
			//5. style 생성
			style = wb.createCellStyle();
			style.setWrapText(true);
			// Align
			style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
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
			style.setFillForegroundColor(HSSFColor.GREY_80_PERCENT.index);
			style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			// font
			font = wb.createFont();
			font.setFontHeightInPoints((short) 10);
			font.setColor(HSSFColor.WHITE.index);
			style.setFont(font);

			boolean group = false;
			for (int i = 0; i < groups.length; i++) {
				if (!"".equals(groups[i])) {
					group = true;
					break;
				}
			}
			for (int j = 0; j < groups.length; j++) {
				cell = row.createCell(j);
				cell.setCellValue(new HSSFRichTextString(groups[j]));
				cell.setCellStyle(style);
			}

			if (group)
				row = sheet.createRow(1); //

			//6. Header Data Set
			for (int j = 0; j < headers.length; j++) {
				cell = row.createCell(j);
				cell.setCellValue(new HSSFRichTextString(headers[j]));
				cell.setCellStyle(style);
			}

			if (group) {
				for (int i = 0; i < headers.length; i++) {
					if (headers[i].equals(groups[i]))
						sheet.addMergedRegion(new CellRangeAddress(0, 1, i, i));
				}

				int pos = 0;
				int count = 0;
				String value = groups[0];

				for (int i = 1; i < headers.length; i++) {
					if (value.equals(groups[i])) {
						count++;
					} else {
						if (count > 0)
							sheet.addMergedRegion(new CellRangeAddress(0, 0, pos, pos + count));

						pos = i;
						count = 0;
						value = groups[i];
					}

					if (count > 0 && i == headers.length - 1)
						sheet.addMergedRegion(new CellRangeAddress(0, 0, pos, pos + count));
				}
			}
			//7. Field Data Set
			for (int i = 0; i < datas.length; i++) {
			
				String[] strDatas = null;
				strDatas = datas[i].split("\\|");
				String strData = null;
				//header 다음에 row 생성
				row = sheet.createRow(i + 1 + (group ? 1 : 0)); 
				//row.setHeightInPoints(20);
				//Field style 생성 - 앞서 style과 동일 적용시에는 추가 생성 필요 없음
				style = wb.createCellStyle();
				style.setWrapText(true);
				// Align
				style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
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
				//8. Field Data 
				for (int k = 0; k < headers.length; k++) {
					//adjust column width to fit the content  
					//sheet.autoSizeColumn((short) k);
					//sheet.setColumnWidth(k, (sheet.getColumnWidth(k)) + 512);
					cell = row.createCell(k);
					cell.setCellValue(new HSSFRichTextString(strDatas[k]));
					cell.setCellStyle(style);
				}
			}
		}
		FileOutputStream fos = new FileOutputStream(EXCEL_FILE_NAME);
		wb.write(fos);
		fos.close();
	} catch (Exception e) {
		e.printStackTrace();
	}

	response.setContentType("application/octet-stream");
	response.setCharacterEncoding("UTF-8");
	response.setHeader("Content-Disposition", "inline; fileName=\"" + fileName + "\";");

	// body에 전달
	byte b[] = new byte[(int) file.length()];
	out.clear();
	out = pageContext.pushBody();

	BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
	BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

	int read = 0;
	while ((read = bis.read(b)) != -1)
		bos.write(b, 0, read);
	bos.close();
	bis.close();
%>
package com.psnm.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import nexcore.framework.core.util.BaseUtils;
import nexcore.framework.core.util.DateUtils;
import nexcore.framework.core.util.StringUtils;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.lang.SystemUtils;
import org.apache.commons.lang.time.FastDateFormat;

public final class FileResourceManager {

	/**
	 * 업로드의 중간에 설정된 디렉토리명
	 * @since 2014-11-14
	 */
	private final static String MIDFIX_DIR = "psnm";

	private final static long DEFAULT_MAX_FILE_SIZE = 10 * 1024 * 1024; //10MB
	private final static int DEFAULT_DOWNLOAD_BUFFER_SIZE = 8192;

	private final static String DAILY_STORED_PATH_STR = "yyyy" + SystemUtils.FILE_SEPARATOR + "MM" + SystemUtils.FILE_SEPARATOR + "dd";
	private final static String DAILY_FILE_PREFIX_STR = "yyyyMMdd_";
	private final static FastDateFormat DAILY_STORED_PATH_FORMAT = FastDateFormat.getInstance(DAILY_STORED_PATH_STR);
	private final static FastDateFormat DAILY_FILE_PREFIX_FORMAT = FastDateFormat.getInstance(DAILY_FILE_PREFIX_STR);

	private static String fileUploadEncoding;
	private static String fileUploadRootPath;
	private static String fileUploadTempPath;
	private static long fileUploadMaxSize;
	//	private static long fileUploadMaxSizeEach;
	private static int fileDownloadBufferSize;

	private static String dataFileRootPath;
	private static String dataFileExtention;
	private static String dataCheckFileExtention;

	/**
	 * 업로드 파일 저장소
	 * 
	 * @return 업로드 파일 저장소
	 */
	public static String getFileUploadRootPath() {
		if (fileUploadRootPath == null) {
			fileUploadRootPath = BaseUtils.getConfiguration("file.upload.root.folder");
		}
		return fileUploadRootPath;
	}

	/**
	 * 업로드 파일 임시 저장소
	 * 
	 * @return 업로드 파일 임시 저장소
	 */
	public static String getFileUploadTempPath() {
		if (fileUploadTempPath == null) {
			fileUploadTempPath = BaseUtils.getConfiguration("file.upload.temp.folder");
		}
		return fileUploadTempPath;
	}

	/**
	 * 업로드 파일 최대 사이즈
	 */
	public static long getFileUploadMaxSize() {
		if (fileUploadMaxSize < 1) {
			long size = getLong(BaseUtils.getConfiguration("file.upload.max.size"));
			fileUploadMaxSize = size == -1 ? DEFAULT_MAX_FILE_SIZE : size;
		}
		return fileUploadMaxSize;
	}

	/**
	 * 파일 다운로드 버퍼 사이즈
	 */
	public static int getFileDownloadBufferSize() {
		if (fileDownloadBufferSize < 1) {
			int size = getInt(BaseUtils.getConfiguration("file.download.buffer.size"));
			fileDownloadBufferSize = size == -1 ? DEFAULT_DOWNLOAD_BUFFER_SIZE : size;
		}
		return fileDownloadBufferSize;
	}

	/**
	 * 파일 업로드 인코딩
	 */
	public static String getFileUploadEncoding() {
		if (fileUploadEncoding == null) {
			fileUploadEncoding = BaseUtils.getConfiguration("file.upload.encoding");
		}
		if (fileUploadEncoding == null) {
			fileUploadEncoding = BaseUtils.getDefaultEncoding();
		}
		return fileUploadEncoding;
	}

	/**
	 * 데이타 파일 저장소
	 * 
	 * @return 데이타 파일 저장소
	 */
	public static String getDataFileRootPath() {
		if (dataFileRootPath == null) {
			dataFileRootPath = BaseUtils.getConfiguration("file.data.root.folder");
		}
		return dataFileRootPath;
	}

	/**
	 * 데이타 파일 확장자
	 * 
	 * @return 데이타 파일 확장자
	 */
	public static String getDataFileExtention() {
		if (dataFileExtention == null) {
			dataFileExtention = BaseUtils.getConfiguration("file.data.extention");
		}
		return dataFileExtention;
	}

	/**
	 * 데이타 체크 파일 확장자
	 * 
	 * @return 데이타 체크 파일 확장자
	 */
	public static String getDataCheckFileExtention() {
		if (dataCheckFileExtention == null) {
			dataCheckFileExtention = BaseUtils.getConfiguration("file.data.check.extention");
		}
		return dataCheckFileExtention;
	}

	/**
	 * 업로드된 파일을 영구저장소에 저장한다.
	 * 
	 * @param files
	 *            업로드파일목록
	 * @param envDvcd
	 *            환경 구분 (로컬, 개발, 운영)
	 * @param applCd
	 *            어플리케이션 구분(CBM, CUS등) 어플리케이션 구분(CBM, CUS등)
	 * @return 저장된 파일정보
	 */
	public static List<FileResource> storeUploadFile(List<FileItem> files, String envDvcd, String applCd) {
		List<FileResource> resources = null;
		if (files != null) {
			resources = new ArrayList<FileResource>();
			Date currentDate = new Date();

			String dailyUploadFilePath = getDailyUploadFilePath(applCd, currentDate); //서버 저장 전체 DIR 경로
			String relativeDirPath = getRelativeUploadDir(applCd, currentDate); //[upload.home]을 제외한 저장 DIR 경로
			String dailyFilePrefix = getDailyFilePrefix(envDvcd, applCd, currentDate);

			File file = null;

			if (files != null) {
				String isWrite = "FAIL";
				for (FileItem fi : files) {
					file = createFile(makeUploadFileFullName(dailyUploadFilePath, dailyFilePrefix));
					try {
						fi.write(file);
						isWrite = "SUCCESS";
					} catch (Exception e) {
						if (file != null && file.exists()) file.delete();
						isWrite = "FAIL";
					} finally {
						FileResource fr = createFileResource(fi, file, isWrite);
						fr.setStoredDir(relativeDirPath); //@@
						fr.setGroupId(applCd); //파일그룹ID = 업무구분
						resources.add(fr);
					}
				}
			}
		}

		return resources;
	}

	/**
	 * 업로드된 모든 파일을 삭제한다.
	 * 
	 * @param resources
	 *            업로드 파일 목록
	 */
	public static void removeForceUploadFile(List<FileResource> resources) {
		if (resources != null) {
			File file = null;
			for (FileResource fr : resources) {
				if (fr instanceof FileResource) {
					file = new File(((FileResource) fr).getStoredFullName());
				} else {
					try {
						file = lookupUploadFile(fr.getStoredName());
					} catch (Exception e) {
					}
				}
				if (file != null && file.exists()) {
					file.delete();
				}
			}
		}
	}

	/**
	 * 업로드 파일의 InputStream 조회
	 * 
	 * @param uploadFileId
	 *            업로드 파일 아이디
	 * @return 업로드 파일의 InputStream
	 */
	public static InputStream getUploadFileInputStream(String uploadFileId, String appCd, String relativeDir) {
		File file = lookupUploadFile(uploadFileId, appCd, relativeDir);
		if (!file.exists()) {
			//System.err.println("파일경로 ::: [" + file.getAbsolutePath() + "]");
			throw new RuntimeException("File(" + uploadFileId + ") not found.");
		}

		FileInputStream fis = null;
		try {
			fis = new FileInputStream(file);
		} catch (FileNotFoundException e) {
			throw new RuntimeException("File(" + uploadFileId + ") not found.");
		}
		return fis;
	}
	public static InputStream getUploadFileInputStream(String uploadFileId) {
		File file = lookupUploadFile(uploadFileId);
		if (!file.exists()) {
			throw new RuntimeException("File(" + uploadFileId + ") not found.");
		}

		FileInputStream fis = null;
		try {
			fis = new FileInputStream(file);
		} catch (FileNotFoundException e) {
			throw new RuntimeException("File(" + uploadFileId + ") not found.");
		}
		return fis;
	}

	/**
	 * 업로드 파일 삭제
	 * 
	 * @param uploadFileId
	 *            업로드 파일 아이디
	 * @return 삭제여부
	 */
	public static boolean removeUploadFile(String uploadFileId) {
		File file = lookupUploadFile(uploadFileId);
		if (!file.exists()) {
			throw new RuntimeException("File(" + uploadFileId + ") not found.");
		}
		return file.delete();
	}
	public static boolean removeUploadFile(String uploadFileId, String applCd, String relativeDir) {
		File file = lookupUploadFile(uploadFileId, applCd, relativeDir);
		if ( !file.exists() ) {
			//throw new RuntimeException("File(" + uploadFileId + ") not found.");
			return false;
		}
		return file.delete();
	}

	/**
	 * 업로드 파일 조회
	 * 
	 * @param uploadFileId
	 *            업로드 파일 아이디
	 * @return 업로드 파일 객체
	 */
	public static File lookupUploadFile(String uploadFileId, String applCd, String relativeDir) {
		String fileName = lookupUploadFileFullName(uploadFileId, applCd, relativeDir);
		return new File(fileName);
	}
	public static File lookupUploadFile(String uploadFileId) {
		String fileName = lookupUploadFileFullName(uploadFileId);
		return new File(fileName);
	}

	/**
	 * 업로드 파일을 데이타 파일로 변환
	 * 
	 * @param uploadFileId
	 *            업로드 파일 아이디
	 * @param sysCd
	 *            시스템 구분(계정계, 정보계)
	 * @param applCd
	 *            어플리케이션 구분(CBM, CUS등)
	 * @param fileName
	 *            저장할 파일명
	 * @param overwrite
	 *            덮어쓰기 여부
	 * @param remove
	 *            원본 삭제 여부
	 * @throws IOException
	 */
	public static void uploadToData(String uploadFileId, String sysCd, String applCd, String fileName, boolean overwrite, boolean remove) throws IOException {
		File uploadFile = lookupUploadFile(uploadFileId);
		if (!uploadFile.exists()) {
			throw new IOException("Upload File not found. fileId=" + uploadFileId);
		}

		String dataFileName = makeDataFileFullName(sysCd, applCd, fileName);
		String dataCheckFileName = dataFileName.substring(0, dataFileName.length() - getDataFileExtention().length()) + getDataCheckFileExtention();
		File dataFile = new File(dataFileName);
		File dataCheckFile = new File(dataCheckFileName);
		if (!overwrite) {
			if (dataFile.exists()) {
				throw new IOException("Data File is exist. " + dataFile.getAbsolutePath());
			}
			if (dataCheckFile.exists()) {
				throw new IOException("Data Check File is exist. " + dataCheckFile.getAbsolutePath());
			}
		}

		// data file
		org.apache.commons.io.FileUtils.copyFile(uploadFile, dataFile);

		// data check file 
		String fileContent = "fileCreateTime=" + DateUtils.getDefaultCurrentDateTime() + " | fileSize=" + uploadFile.length();
		org.apache.commons.io.FileUtils.writeStringToFile(dataCheckFile, fileContent);

		if (remove) {
			uploadFile.delete();
		}
	}

	/**
	 * 데이타 파일을 업로드 파일로 변환
	 * 
	 * @param dataFileFullPath
	 *            데이타 파일명
	 * @param envDvcd
	 *            환경 구분 (로컬, 개발, 운영)
	 * @param bankCd
	 *            은행코드
	 * @param applCd
	 *            어플리케이션 구분(CBM, CUS등) 어플리케이션 구분(CBM, CUS등)
	 * @param overwrite
	 *            덮어쓰기 여부
	 * @param remove
	 *            원본 삭제 여부
	 * @return 업로드 파일 아이디
	 * @throws IOException
	 */
	public static String dataToUpload(String dataFileFullPath, String envDvcd, String bankCd, String applCd, boolean overwrite, boolean remove) throws IOException {
		File dataFile = new File(dataFileFullPath);
		if (!dataFile.exists()) {
			throw new IOException("Data File not found. " + dataFile.getAbsolutePath());
		}

		File uploadFile = createUploadFile(envDvcd, bankCd, applCd);
		if (!overwrite) {
			if (uploadFile.exists()) {
				throw new IOException("Upload File is exist. " + uploadFile.getAbsolutePath());
			}
		}

		org.apache.commons.io.FileUtils.copyFile(dataFile, uploadFile);

		if (remove) {
			dataFile.delete();
		}

		return uploadFile.getName();
	}

	/**
	 * 업로드 파일 생성
	 * 
	 * @param envDvcd
	 *            개발환경정보구분코드
	 * @param bankCd
	 *            은행코드
	 * @param applCd
	 *            업무코드
	 * @return 업로드 파일 객체
	 */
	public static File createUploadFile(String envDvcd, String bankCd, String applCd) {
		Date currentDate = new Date();
		String dailyUploadFilePath = getDailyUploadFilePath(applCd, currentDate);
		String dailyFilePrefix = getDailyFilePrefix(envDvcd, applCd, currentDate);
		return createFile(makeUploadFileFullName(dailyUploadFilePath, dailyFilePrefix));
	}

	/**
	 * 데이타 파일 전체 경로
	 * 
	 * @param sysCd
	 *            시스템 코드(계정계, 정보계)
	 * @param applCd
	 *            어플리케이션 코드 (CBM, CUS 등)
	 * @param fileName
	 *            파일 이름
	 * @return 데이타 파일 전체 경로
	 */
	public static String makeDataFileFullName(String sysCd, String applCd, String fileName) {
		StringBuilder sb = new StringBuilder();
		String path = getDataFileRootPath();
		sb.append(path);
		if (!path.endsWith("/") && !path.endsWith("\\")) {
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		sb.append(sysCd.toLowerCase());
		sb.append(SystemUtils.FILE_SEPARATOR);
		sb.append(applCd.toLowerCase());
		sb.append(SystemUtils.FILE_SEPARATOR);
		sb.append(fileName);
		if (!fileName.toUpperCase().endsWith(getDataFileExtention().toUpperCase())) {
			sb.append(getDataFileExtention());
		}
		return sb.toString();
	}

	/**
	 * 물리파일의 디렉토리를 체크하여 디렉토리 생성
	 * 
	 * @param file
	 *            물리파일
	 */
	private static boolean mkdirs(File file) {
		if (!file.exists()) {
			File parent = file.getParentFile();
			if (parent != null && !parent.exists()) {
				return parent.mkdirs();
			}
		}
		return true;
	}

	/**
	 * 영구 저장소에 저장할 파일명 생성
	 * 
	 * @param storedPath
	 *            저장소
	 * @param filePrefix
	 *            파일선행자
	 * @return 영구 저장소에 저장할 파일명
	 */
	private static String makeUploadFileFullName(String storedPath, String filePrefix) {
		StringBuilder sb = new StringBuilder();

		sb.append(storedPath);
		if (!storedPath.endsWith("/") && !storedPath.endsWith("\\")) {
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		sb.append(filePrefix);
		sb.append(UUID.randomUUID().toString());

		return sb.toString();
	}

	/**
	 * 물리파일 생성
	 * 
	 * @param fileFullName
	 *            file path
	 * @return 생성된 물리파일
	 */
	private static File createFile(String fileFullName) {
		File file = new File(fileFullName);
		mkdirs(file);
		return file;
	}

	/**
	 * 영구 저장소에 저장된 업로드 파일 정보 생성
	 * 
	 * @param fi
	 *            업로드 파일 정보
	 * @param storedFile
	 *            서버에 저장된 물리파일
	 * @param resultInfo
	 *            업로드 성공/실패 여부 [SUCCESS/FAIL]
	 * @return 영구 저장소에 저장된 업로드 파일 정보
	 */
	private static FileResource createFileResource(FileItem fi, File storedFile, String resultInfo) {
		FileResource fr = new FileResource();
		fr.setFieldName(fi.getFieldName());
		fr.setStoredName(storedFile.getName());
		fr.setStoredFullName(storedFile.getAbsolutePath());
		fr.setOriginalFullName(fi.getName());
		fr.setSize(fi.getSize());
		fr.setContentType(fi.getContentType());
		fr.setResultInfo(resultInfo);
		return fr;
	}

	/**
	 * 일별로 관리되는 영구 저장소
	 * 
	 * @param applCd
	 *            어플리케이션코드
	 * @param date
	 *            날짜정보
	 * @return 일별로 관리되는 영구 저장소
	 */
	private static String getDailyUploadFilePath(String applCd, Date date) {
		StringBuilder sb = new StringBuilder();
		String uploadRootPath = getFileUploadRootPath();
		sb.append(uploadRootPath);
		if (!uploadRootPath.endsWith("/") && !uploadRootPath.endsWith("\\")) {
			sb.append(SystemUtils.FILE_SEPARATOR);
		}

		sb.append( getRelativeUploadDir(applCd, date) ); //@since 2014-11-14 by RHKD
		/*
		sb.append("psnm"); //psnm 디렉토리 추가
		sb.append(SystemUtils.FILE_SEPARATOR);
		if ( StringUtils.isNotEmpty(applCd) ) {
			sb.append(applCd.toLowerCase()); //applCd.toLowerCase()
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		sb.append(DAILY_STORED_PATH_FORMAT.format(date));
		*/
		return sb.toString();
	}

	/**
	 * 업로드 홈 디렉토리를 제외한, 업로드 파일 저장 디렉토리 경로 문자열을 구하여 반환
	 * (예) psnm/DEFAULT/2014/11/15
	 * 
	 * @param	applCd	업무구분코드(주의 : 소문자로 변환)
	 * @param 	date	날짜
	 * @return	업로드 파일 저장 디렉토리 경로 문자열(업로드 홈 디렉토리를 제외)
	 * @since	2014-11-14
	 */
	private static String getRelativeUploadDir(String applCd, Date date) {
		StringBuffer sb = new StringBuffer();
		sb.append(MIDFIX_DIR); //psnm 디렉토리 추가
		sb.append(SystemUtils.FILE_SEPARATOR);

		if ( StringUtils.isNotEmpty(applCd) ) {
			sb.append(applCd.toLowerCase()); //소문자만
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		sb.append(DAILY_STORED_PATH_FORMAT.format(date));

		return sb.toString();
	}

	/**
	 * 업로드 파일 전체 경로
	 * 
	 * @param uploadFileId
	 *            업로드 파일 아이디
	 * @return 업로드 파일 전체 경로
	 */
	public static String lookupUploadFileFullName(String uploadFileId, String applCd, String relativeDir) {
		if ( StringUtils.isEmpty(uploadFileId) ) {
			throw new RuntimeException("Invalid upload file id. [" + uploadFileId + "]");
		}

		String uploadRootPath = getFileUploadRootPath();
		if (!uploadRootPath.endsWith("/") && !uploadRootPath.endsWith("\\")) {
			uploadRootPath += SystemUtils.FILE_SEPARATOR;
		}
		//System.out.println("\t- applCd = [" + applCd + "], relativeDir = [" + relativeDir + "]");

		StringBuilder sb = new StringBuilder();
		sb.append(uploadRootPath); //(예) /upload/
		sb.append( removeDirChar(relativeDir) ); //# 보안을 위해 상위 디렉토리 이동 문자열 제거

		if ( !StringUtils.isEmpty(relativeDir) && !relativeDir.endsWith("/") ) {
			sb.append(SystemUtils.FILE_SEPARATOR); //relativeDir 문자열이 / 로 마치지 않을때 추가함
		}

		sb.append(uploadFileId);
		//System.out.println("\t- file full path = [" + sb.toString() + "]");
		return sb.toString();
	}
	public static String removeDirChar(String path) {
		if (null==path) return null;
		String p = path.replaceAll("\\.\\./", ""); // ../ 문자열 제거
		p = p.replaceAll("\\.\\.\\\\", ""); // ..\ 문자열 제거
		p = p.replaceAll("\\.\\.", ""); // .. 문자열 제거
		return p;
	}
	public static String lookupUploadFileFullName(String uploadFileId) {
		//bnkcd_applcd_yyyyMMdd_이름
		List<String> tokens = StringUtils.stringToList(uploadFileId, '_');
		//////////////////////////////////
		if (tokens == null || tokens.size() < 4) {
			throw new RuntimeException("Invalid upload file id. [" + uploadFileId + "]");
		}

		String uploadRootPath = getFileUploadRootPath();
		if (!uploadRootPath.endsWith("/") && !uploadRootPath.endsWith("\\")) {
			uploadRootPath += SystemUtils.FILE_SEPARATOR;
		}

		String envCd = tokens.remove(0);
		String applCd = tokens.remove(0);
		String dailyCode = tokens.remove(0);
		//		String fileName = tokens.remove(0);

		StringBuilder sb = new StringBuilder();
		sb.append(uploadRootPath);
		sb.append(applCd.toLowerCase());
		sb.append(SystemUtils.FILE_SEPARATOR);

		int index = 0;
		// yyyy
		if (dailyCode.length() >= 4) {
			sb.append(dailyCode.substring(index, (index += 4)));
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		// mm
		if (dailyCode.length() >= 6) {
			sb.append(dailyCode.substring(index, (index += 2)));
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		// dd
		if (dailyCode.length() >= 8) {
			sb.append(dailyCode.substring(index, (index += 2)));
			sb.append(SystemUtils.FILE_SEPARATOR);
		}
		sb.append(uploadFileId);
		return sb.toString();
	}

	/**
	 * 일별 파일 선행자
	 * 
	 * @return 일별 파일 선행자
	 */
	private static String getDailyFilePrefix(String envCd, String applCd, Date date) {
		return envCd.toUpperCase() + "_" + applCd.toUpperCase() + "_" + DAILY_FILE_PREFIX_FORMAT.format(date);
	}

	private static long getLong(String str) {
		if (str != null) {
			String s = str.toUpperCase();
			long multiplier = 1L;
			int index;
			if ((index = s.indexOf("KB")) != -1) {
				multiplier = 1024L;
				s = s.substring(0, index);
			} else if ((index = s.indexOf("MB")) != -1) {
				multiplier = 1048576L;
				s = s.substring(0, index);
			} else if ((index = s.indexOf("GB")) != -1) {
				multiplier = 1073741824L;
				s = s.substring(0, index);
			}
			try {
				return Long.valueOf(s).longValue() * multiplier;
			} catch (NumberFormatException e) {
			}
		}
		return -1;
		//		return DEFAULT_MAX_FILE_SIZE;
	}

	private static int getInt(String str) {
		if (str != null) {
			String s = str.toUpperCase();
			int multiplier = 1;
			int index;
			if ((index = s.indexOf("KB")) != -1) {
				multiplier = 1024;
				s = s.substring(0, index);
			} else if ((index = s.indexOf("MB")) != -1) {
				multiplier = 1048576;
				s = s.substring(0, index);
			} else if ((index = s.indexOf("GB")) != -1) {
				multiplier = 1073741824;
				s = s.substring(0, index);
			}
			try {
				return Integer.valueOf(s).intValue() * multiplier;
			} catch (NumberFormatException e) {
			}
		}
		return -1;
		//		return DEFAULT_MAX_FILE_SIZE;
	}

}

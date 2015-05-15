package com.psnm.common.file;


public class FileResource {

	/**
	 * 업로드된 전체경로를 포함한 원본 파일명
	 */
	private String originalFullName;

	/**
	 * 업로드된 원본 파일명
	 */
	private String originalName;

	/**
	 * 업로드 필드명
	 */
	private String fieldName;

	/**
	 * 서버에 저장된 파일명
	 */
	private String storedName;

	/**
	 * 서버저장 디렉토리경로(업로드 홈 제외)
	 */
	private String storedDir;

	/**
	 * 서버에 저장된 전체경로를 포함한 파일명
	 */
	private String storedFullName;

	/**
	 * 파일 타입
	 */
	private String contentType;

	/**
	 * 파일 사이즈
	 */
	private long size;

	/**
	 * 파일그룹ID(업무구분)
	 */
	private String groupId;
	
	/**
	 * 업로드 성공/실패 여부 [SUCCESS/FAIL]
	 */
	private String resultInfo;

	// /**
	// * 서비스 수행 완료 후 파일 삭제 요청 여부
	// */
	// private boolean deleteRquest;

	FileResource() {
	}

	/**
	 * 업로드된 전체경로를 포함한 원본 파일명
	 * 
	 * @return the originalName
	 */
	public String getOriginalFullName() {
		return originalFullName;
	}

	/**
	 * 업로드된 전체경로를 포함한 원본 파일명
	 * 
	 * @param originalName
	 *            the originalName to set
	 */
	void setOriginalFullName(String originalFullName) {
		this.originalFullName = originalFullName;
		this.originalName = parseSimpleName(originalFullName);
		// this.extensionName = parseExtensionName(originalName);
	}

	/**
	 * 업로드된 원본 파일명
	 * 
	 * @return the originalSimpleName
	 */
	public String getOriginalName() {
		return originalName;
	}

	/**
	 * 업로드 필드명 설정
	 * 
	 * @param fieldName
	 *            업로드 필드명
	 */
	void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	/**
	 * 업로드 필드명 조회
	 */
	public String getFieldName() {
		return fieldName;
	}

	/**
	 * 서버에 저장된 파일명
	 * 
	 * @return the storedName
	 */
	public String getStoredName() {
		return storedName;
	}

	/**
	 * 서버에 저장된 파일명
	 * 
	 * @param storedName
	 *            the storedName to set
	 */
	void setStoredName(String storedName) {
		this.storedName = storedName;
	}

	/**
	 * 서버에 저장된 전체경로를 포함한 파일명
	 * 
	 * @return 서버에 저장된 전체경로를 포함한 파일명
	 */
	String getStoredFullName() {
		return storedFullName;
	}

	/**
	 * 서버에 저장된 전체경로를 포함한 파일명
	 * 
	 * @param storedFullName
	 *            the storedFullName to set
	 */
	void setStoredFullName(String storedFullName) {
		this.storedFullName = storedFullName;
	}

	/**
	 * 파일 사이즈
	 * 
	 * @return the size
	 */
	public long getSize() {
		return size;
	}

	/**
	 * 파일 사이즈
	 * 
	 * @param size
	 */
	void setSize(long size) {
		this.size = size;
	}
	
	/**
	 * 업로드 성공/실패 여부 [SUCCESS/FAIL]
	 * 
	 * @param resultInfo
	 */
	public String getResultInfo() {
		return resultInfo;
	}
	
	/**
	 * 업로드 성공/실패 여부 [SUCCESS/FAIL]
	 * 
	 * @param resultInfo
	 */
	public void setResultInfo(String resultInfo) {
		this.resultInfo = resultInfo;
	}

	/**
	 * 파일 타입
	 * 
	 * @return the contentType
	 */
	public String getContentType() {
		return contentType;
	}

	/**
	 * @param contentType
	 *            the contentType to set
	 */
	void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getStoredDir() {
		return storedDir;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	/**
	 * 서버저장경로를 설정
	 * 
	 * @param storedDir
	 */
	public void setStoredDir(String storedDir) {
		if (null==storedDir || "".equals(storedDir)) {
			return;
		}
		if ( storedDir.startsWith("/") || storedDir.startsWith("\\") ) {
			this.storedDir = storedDir.substring(1);
		}
		else {
			this.storedDir = storedDir;
		}
		this.storedDir = this.storedDir.replaceAll("[\\\\]", "/");
	}

	public void setOriginalName(String originalName) {
		this.originalName = originalName;
	}

	private String parseSimpleName(String fileName) {
		String name = fileName;
		if (name == null) {
			return "";
		}

		int pos1 = name.lastIndexOf("/");
		int pos2 = name.lastIndexOf("\\");
		int pos = 0;
		if (pos1 > pos2) {
			pos = pos1;
		} else {
			pos = pos2;
		}

		if (pos != -1) {
			return name.substring(pos + 1);
		} else {
			return name;
		}
	}

	/**
	 * 업로드 파일 정보
	 */
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("FileResource { ");
		sb.append("storedName=" + storedName);
		sb.append(", storedDir=" + storedDir);
		sb.append(", groupId=" + groupId);
		sb.append(", contentType=" + contentType);
		sb.append(", size=" + size);
		sb.append(", fieldName=" + fieldName);
		sb.append(", originalName=" + originalName);
		sb.append(", originalFullName=" + originalFullName);
		sb.append(", resultInfo=" + resultInfo);
		sb.append(" }");
		return sb.toString();
	}
}

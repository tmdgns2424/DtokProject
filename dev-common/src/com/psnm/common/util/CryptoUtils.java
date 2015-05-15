package com.psnm.common.util;

import java.security.MessageDigest;

import nexcore.framework.core.ServiceConstants;
import nexcore.framework.core.crypt.ICryptoFactoryManager;
import nexcore.framework.core.ioc.ComponentRegistry;
import org.apache.commons.codec.binary.Base64; //sun.misc.BASE64Encoder;

/**
 * 암호 관련 도구 클래스
 * (참고) Base64 인코딩 클래스는 commons-lang의 도구 사용함
 * 
 */
public final class CryptoUtils {

    /**
     * 객체 생성 금지
     */
    private CryptoUtils() {
    }

    /**
     * MD5을 이용한 메시지 축약(Masher) 메시지 다이제스트(message digest)
     * 
     * <pre>
     * 각 메시지마다 고유하게 산출되도록 만든 간단한 문자열.
     * 임의의 길이의 메시지를 단방향 해시 함수로 반복 적용하여 축약된 일정한 길이의 
     * 비트열로 만들어 표현한 것으로, 메시지(또는 문서나 문장)마다 단 하나의 메시지
     * 다이제스트가 산출되고, 서로 다른 문서에서 같은 메시지 다이제스트가 산출될 수 
     * 없다. 따라서 원문의 변조 여부를 확인할 수 있는 일종의 체크섬(checksum)이다.
     * </pre>
     * 
     * @param str
     * @return
     * @throws Exception
     */
    static public String digestMessage(String source) {
        ICryptoFactoryManager factory = (ICryptoFactoryManager)ComponentRegistry.lookup(ServiceConstants.CRYPT);
        return factory.encode("md5", source);
    }

    /**
     * SHA1을 이용한 메시지 축약(Masher) 메시지 다이제스트(message digest)
     * 
     * <pre>
     * Framework 구동없이도 테스트된다.
     * </pre>
     * 
     * @param str
     * @return
     * @throws Exception
     */
    static public String digestSHA1(String source) {
    	try{
		    MessageDigest md = MessageDigest.getInstance("SHA1");
		    byte[] bytes = source.getBytes("UTF-8");
		    //BASE64Encoder encoder = new BASE64Encoder();
		    //String base64 = encoder.encode(md.digest(bytes));
		    Base64 encoder = new Base64();
		    String base64 = encoder.encodeToString( md.digest(bytes) );
		    return base64;
    	}catch(Exception e){
    	    return source;
    	}
    }
    
    
    
    
    
    
    static public String digestSHA256(String source) {
    	try{
		    MessageDigest md = MessageDigest.getInstance("SHA-256");
		    byte[] bytes = source.getBytes("UTF-8");
		    //BASE64Encoder encoder = new BASE64Encoder();
		    //String base64 = encoder.encode(md.digest(bytes));
		    Base64 encoder = new Base64();
		    String base64 = encoder.encodeToString( md.digest(bytes) );
		    return base64;
    	}catch(Exception e){
    	    return source;
    	}
    }
    
    
    
    
    
    /**
     * DES 암호화 메소드
     * 
     * @param source
     * @return
     */
    static public String encode(String source){
        return encode("cipher", source);
    }
    
    /**
     * 암호화 메소드
     * 
     * <p>cryptoKey는 다음을 가질 수 있다 
     * <ol>
     * <li>md5 : MD5 암호화. decode는 불가</li>
     * <li>cipher : DES 암호화. encode/decode 가능</li>
     * </ol>
     * </p>
     * 
     * @param cryptoKey
     * @param source
     * @return
     */
    static public String encode(String cryptoKey, String source) {
        ICryptoFactoryManager factory = (ICryptoFactoryManager)ComponentRegistry.lookup(ServiceConstants.CRYPT);
        return factory.encode(cryptoKey, source);
    }

    /**
     * DES 복호화 메소드
     * 
     * @param source
     * @return
     */
    static public String decode(String source){
        return encode("cipher", source);
    }
    
    /**
     * 복호화 메소드
     * 
     * <p>cryptoKey는 다음을 가질 수 있다 
     * <ol>
     * <li>cipher : DES 암호화. encode/decode 가능</li>
     * </ol>
     * md5는 decode 불가함.
     * </p>
     * 
     * @param cryptoKey
     * @param source
     * @return
     */
    static public String decode(String cryptoKey, String source) {
        ICryptoFactoryManager factory = (ICryptoFactoryManager)ComponentRegistry.lookup(ServiceConstants.CRYPT);
        return factory.decode(cryptoKey, source);
    }

}

package com.psnm.common.util;

import com.sun.org.apache.xml.internal.security.exceptions.Base64DecodingException;
import com.sun.org.apache.xml.internal.security.utils.Base64;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

/**
 * Created with IntelliJ IDEA.
 * 
 * 
 * 
 * 
 * 
 * 
 */
public class SHA256Hash
{
    private boolean encoding = true;

    private SHA256Hash()
    {
        this.encoding = true;
    }

    private SHA256Hash( boolean encoding )
    {
        this.encoding = encoding;
    }

    private static char HEXCHARS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

    private static String byteToHex( byte[] bytes )
    {
        char encoded[] = new char[bytes.length << 1];
        int offset = 0;
        for(int i=0, iend=bytes.length;i<iend;i++)
        {
            encoded[offset++] = HEXCHARS[bytes[i] >> 4 & 15];
            encoded[offset++] = HEXCHARS[bytes[i] & 15];
        }
        return new String( encoded );
    }

    /**
     * 문자열을 hash 하여 나온 결과값을 인코딩해서 반환한다.
     *
     * @param str     hash 대상 문자열
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    private String encrypt( String str )
    {
        try
        {
            byte[] arr = getDigest( str );
            return this.encoding ? byteToHex( arr ) : Base64.encode( arr );
        }
        catch ( Exception e )
        {
            return null;
        }
    }

    /**
     * digest를 생성한다.
     *
     * @param str  hash할 문자열
     * @return hash한 결과값
     * @throws java.security.NoSuchAlgorithmException
     * @throws java.io.UnsupportedEncodingException
     */
    private static byte[] getDigest( String str ) throws NoSuchAlgorithmException, UnsupportedEncodingException
    {
        MessageDigest md = MessageDigest.getInstance( "SHA-256" );
        md.reset();
        md.update( str.getBytes() );
        return md.digest();

    }

    /**
     * 문자열을 hash 하여 나온 결과값을 hex 방식으로 인코딩한 후 반환한다.
     *
     * @param str hash 대상 문자열
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( String str )
    {
        return new SHA256Hash().encrypt( str );
    }

    /**
     * 문자열을 hash하여 나온 결과값을 선택한 encoding 방식으로 인코딩한 후 반환한다.
     *
     * @param encoding encoding 방식( true : hex, false : Base64 )
     * @param str      has 대상 문자열
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( boolean encoding, String str )
    {
        return new SHA256Hash( encoding ).encrypt( str );
    }

    /**
     * hex 방식으로 인코딩된 hash 값과 문자열을 비교한다.
     *
     * @param encoded hash값
     * @param str     문자열
     * @return 비교 결과
     * @throws com.sun.org.apache.xml.internal.security.exceptions.Base64DecodingException
     * @throws java.security.NoSuchAlgorithmException
     * @throws java.io.UnsupportedEncodingException
     */
    public static boolean equal( String encoded, String str ) throws Base64DecodingException, NoSuchAlgorithmException, UnsupportedEncodingException {
        System.out.println(encoded);
        return equal(true, encoded, str);
    }

    /**
     * 정해진 encoding 방식으로 hash 값과 문자열을 비교한다.
     *
     * @param encoding encoding 방식( true : hex, false : Base64 )
     * @param encoded  hash값
     * @param str      문자열
     * @return 비교 결과
     * @throws com.sun.org.apache.xml.internal.security.exceptions.Base64DecodingException
     * @throws java.security.NoSuchAlgorithmException
     * @throws java.io.UnsupportedEncodingException
     */
    public static boolean equal( boolean encoding, String encoded, String str ) throws Base64DecodingException, NoSuchAlgorithmException, UnsupportedEncodingException
    {
        byte[] arr = getDigest( str );
        return encoded.equals( encoding ? byteToHex( arr ) : Base64.encode( arr ) );
    }

    public static void main( String[] args ) throws Exception
    {
        System.out.println(encode("UK1488"));
        System.out.println(encode("UK1487"));
        System.out.println(encode("P2420001"));
    }
}

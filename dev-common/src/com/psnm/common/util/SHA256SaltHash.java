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
public class SHA256SaltHash {
    private Random rand;
    private boolean encoding = true;

    private SHA256SaltHash()
    {
        this.rand = new Random();
        this.encoding = true;
    }

    private SHA256SaltHash( boolean encoding )
    {
        this.rand = new Random();
        this.encoding = encoding;
    }

    private static char HEXCHARS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    private static final byte HEXBYTES[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    private static byte[] hexToByte( String str )
    {
        if ( str == null )
        {
            return new byte[0];
        }
        char values[] = str.toCharArray();
        int length = values.length;
        if ( length == 0 )
        {
            return new byte[0];
        }
        byte out[] = new byte[length + 1 >> 1];
        int i = 0;
        int iend = (length >> 1) << 1;
        int offset = 0;
        while ( i < iend )
        {
            int value = HEXBYTES[values[i++] & 127] << 4;
            value |= HEXBYTES[values[i++] & 127];
            out[offset++] = (byte) value;
        }
        if ( i < length )
        {
            out[offset] = (byte) (HEXBYTES[values[i] & 127] << 4);
        }
        return out;
    }

    private static String byteToHex( byte[] bytes )
    {
        char encoded[] = new char[bytes.length << 1];
        int offset = 0;
        for(int i=0, iend=bytes.length;i<iend;i++)
        {
            encoded[offset++] = HEXCHARS[bytes[i] >> 4 & 15];
            encoded[offset++] = HEXCHARS[bytes[i] & 15];
        }
//        for ( byte aByte : bytes )
//        {
//            encoded[offset++] = HEXCHARS[aByte >> 4 & 15];
//            encoded[offset++] = HEXCHARS[aByte & 15];
//        }
        return new String( encoded );
    }

    /**
     * 문자열 hash 시에 사용하는 salt 바이트를 배열을 생성한다.
     *
     * @return byte 배열
     */
    private byte[] getSalt()
    {
        byte salt[] = new byte[8];
        long value = rand.nextLong();
        int i = 0;
        for ( int iend = salt.length; i < iend; i++ )
        {
            salt[i] = (byte) (int) value;
            value >>= 8;
        }
        return salt;
    }

    /**
     * 2개의 byte 배열을 결합한다.
     *
     * @param first  첫번째 배열
     * @param second 두번쨰 배열
     * @return 결합한 결과
     */
    private static byte[] join( byte first[], byte second[] )
    {
        byte t[] = new byte[first.length + second.length];
        System.arraycopy( first, 0, t, 0, first.length );
        System.arraycopy( second, 0, t, first.length, second.length );
        return t;
    }

    /**
     * 문자열을 hash 하여 나온 결과값을 인코딩해서 반환한다.
     *
     * @param str hash 대상 문자열
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    private String encrypt( String str )
    {
        return encrypt( str, getSalt() );
    }

    /**
     * 문자열을 hash 하여 나온 결과값을 인코딩해서 반환한다.
     *
     * @param str     hash 대상 문자열
     * @param saltKey salt key 값;
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    private String encrypt( String str, byte[] saltKey )
    {
        try
        {
/*
            byte[] salt = new byte[8];
            int saltLength = saltKey.length > 8 ? 8 : saltKey.length;
            System.arraycopy( saltKey, 0, salt, 0, saltLength );
            for (; saltLength < 8; saltLength++ )
            {
                salt[saltLength] = 0;
            }
*/
//            byte[] arr = getDigest( str, salt );
            byte[] arr = getDigest( str, saltKey );
//            byte[] arr = getDigest( str, salt );
//            return "{SSHA}" + (this.encoding ? byteToHex( join( arr, salt ) ) : Base64.encode( join( arr, salt ) ));
//            System.out.println(byteToHex( arr  ));
//            System.out.println(byteToHex(join(arr, saltKey)));
            //요구사항이 {SSHA} 제거한 값을 리턴하도록 되어 있어서 수정 (20130912 : koks)
//            return this.encoding ? byteToHex( join( arr, salt ) ) : Base64.encode( join( arr, salt ) );
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
     * @param salt salt 바이트 배열
     * @return hash한 결과값
     * @throws NoSuchAlgorithmException
     * @throws UnsupportedEncodingException
     */
    private static byte[] getDigest( String str, byte[] salt ) throws NoSuchAlgorithmException, UnsupportedEncodingException
    {
        MessageDigest md = MessageDigest.getInstance( "SHA-256" );
        md.reset();
        md.update( str.getBytes() );
        md.update( salt );
        return md.digest();
//        md.update(salt);
//        return md.digest(str.getBytes());

    }

    /**
     * salt key 값을 byte 배열로 지정 받아서 문자열을 hash하여 나온 결과값을 hex 방식으로 인코딩한 후 {SSHA}를 앞에 붙여서 반환한다.
     *
     * @param str     has 대상 문자열
     * @param saltKey salt key 값
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( String str, byte[] saltKey )
    {
        return new SHA256SaltHash().encrypt( str, saltKey );
    }

    /**
     * salt key 값을 문자열로 지정 받아서 문자열을 hash하여 나온 결과값을 hex 방식으로 인코딩한 후 {SSHA}를 앞에 붙여서 반환한다.
     *
     * @param str     has 대상 문자열
     * @param saltKey salt key 값
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( String str, String saltKey )
    {
        return encode( str, saltKey.getBytes() );
    }

    /**
     * random 생성한 salt key 값을 사용하여 문자열을 hash 하여 나온 결과값을 hex 방식으로 인코딩한 후 {SSHA}를 앞에 붙여서 반환한다.
     *
     * @param str hash 대상 문자열
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( String str )
    {
        return new SHA256SaltHash().encrypt( str );
    }

    /**
     * salt key 값을 byte 배열로 지정 받아서 문자열을 hash하여 나온 결과값을 선택한 encoding 방식으로 인코딩한 후 {SSHA}를 앞에 붙여서 반환한다.
     *
     * @param encoding encoding 방식( true : hex, false : Base64 )
     * @param str      has 대상 문자열
     * @param saltKey  salt key 값
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( boolean encoding, String str, byte[] saltKey )
    {
        return new SHA256SaltHash( encoding ).encrypt( str, saltKey );
    }

    /**
     * salt key 값을 문자열로 지정 받아서 문자열을 hash하여 나온 결과값을 선택한 encoding 방식으로 인코딩한 후 {SSHA}를 앞에 붙여서 반환한다.
     *
     * @param encoding encoding 방식( true : hex, false : Base64 )
     * @param str      has 대상 문자열
     * @param saltKey  salt key 값
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( boolean encoding, String str, String saltKey )
    {
        return encode( encoding, str, saltKey.getBytes() );
    }

    /**
     * random 생성한 salt key 값을 사용하여 문자열을 hash 하여 나온 결과값을 선택한 encoding 방식으로 인코딩한 후 {SSHA}를 앞에 붙여서 반환한다.
     *
     * @param encoding encoding 방식( true : hex, false : Base64 )
     * @param str      hash 대상 문자열
     * @return 인코딩된 hash 값(예외가 발생할 경우 null 값을 반환한다.)
     */
    public static String encode( boolean encoding, String str )
    {
        return new SHA256SaltHash( encoding ).encrypt( str );
    }

    /**
     * hex 방식으로 인코딩된 hash 값과 문자열을 비교한다.
     *
     * @param encoded hash값
     * @param str     문자열
     * @return 비교 결과
     * @throws Base64DecodingException
     * @throws NoSuchAlgorithmException
     * @throws UnsupportedEncodingException
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
     * @throws Base64DecodingException
     * @throws NoSuchAlgorithmException
     * @throws UnsupportedEncodingException
     */
    public static boolean equal( boolean encoding, String encoded, String str ) throws Base64DecodingException, NoSuchAlgorithmException, UnsupportedEncodingException
    {
        encoded = encoded.startsWith( "{SSHA}" ) ? encoded.substring( 6 ) : encoded;
        byte[] decoded = encoding ? hexToByte( encoded ) : Base64.decode( encoded );
        byte[] salt = new byte[8];
        System.arraycopy( decoded, decoded.length - 8, salt, 0, 8 );
        byte[] arr = getDigest( str, salt );
        return encoded.equals( encoding ? byteToHex( join( arr, salt ) ) : Base64.encode( join( arr, salt ) ) );
    }

    public static void main( String[] args ) throws Exception {
    	String[] userids = {
    			"91204841",
    			"93100012",
    			"16115801",
    			"15698601",
    			"D1476300",
    			"D151521012"
    	};

    	for (int i=0; i<userids.length; i++) {
    		System.out.println("- USER_ID = [" + userids[i] + "], PWD = [" + SHA256SaltHash.encode("1111", userids[i]) + "]");
    	}
    	System.out.println("----------------------------------------------------------------------------------");
    	for (int i=0; i<userids.length; i++) {
    		//update PS_MNG.TBAS_USER_MGMT set pwd = 'f66523f6cd1078b47...5f98f' where user_id = '93100012';
    		StringBuffer sb = new StringBuffer();
    		sb.append("update PS_MNG.TBAS_USER_MGMT set pwd = '");
    		sb.append( SHA256SaltHash.encode("1111", userids[i]) ).append("'");
    		sb.append(" where user_id = '").append( userids[i] ).append("';");
    		System.out.println(sb);
    	}


//
//        System.out.println(SHAHashingExample.hash("UK1488", "nets0001"));
//        System.out.println(encode("UK1487", "1q2w3e4r5t"));
//        System.out.println(SHAHashingExample.hash("nets0001", "UK1488"));
//        System.out.println(SHAHashingExample.hash( "nets0001", "UK1488"));
    }
}

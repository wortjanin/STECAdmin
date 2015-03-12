ALTER SESSION SET CURRENT_SCHEMA=SYS;
SET DEFINE OFF;
CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "STEC_CryptPw" AS package me.stec.admin.server;

//	package me.stec.admin.server;
	
	import java.math.BigInteger;
	import java.security.*;
	
	public class STEC_CryptPw{
		    private static final String m1 = "SHA-1";
	//		private static final String m1 = "MD5";
	
	//		private static final String encoding = "UTF-8";
		    
		    private static String digest(String str, String encoding, String method) throws Exception{
				byte[] bytesOfMessage = str.getBytes(encoding);
				MessageDigest md = MessageDigest.getInstance(method);
				byte[] thedigest = md.digest(bytesOfMessage);
				BigInteger bigInt = new BigInteger(1, thedigest);
		
				String hash = bigInt.toString(16);
		
				byte b = thedigest[0];
				if(0 == (b >>> 4)){ 
					if (0 == (b & 0x0F)) 	hash = "00" + hash;
					else					hash = "0"	+ hash;
				}
					
				return hash.toUpperCase();
		   }
		    
		    private static final char[] array = 
		    	"$#_abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
		    public static String aT(String str, String sDig, String dir, String goDeep, String encoding) throws Exception {
		    	boolean dr			= (dir.equals("Y")?true:false);
		    	boolean goDeeper	= (goDeep.equals("Y")?true:false);
		    	boolean s_or_d = Character.isLowerCase(str.charAt(0));
		    	String dig = digest((s_or_d?sDig:str), encoding, m1);
		    	char[] d = dig.toCharArray();
		    	char[] s = (s_or_d?str:sDig).toCharArray();
		    	char f = 'k';
		    	final int s_len = s.length;
		    	final int d_len = d.length;
		    	final int a_len = array.length;
		    	StringBuffer buf = new StringBuffer("");
		    	if(d_len < s_len)
		    		throw new Exception("string is too long");
		    	if (goDeeper && s_len < 8)
		    		throw new Exception("string is too short");
		    	int i;
		    	for(i=0; i<s_len;i++){
		    		int x = d[d_len - i - 1];
		    		char c = s[s_len - i - 1];
		    		int y = c;
		    		if(Character.isLetter(c)) f = c;
		    		x = Math.abs(x);
		    		y = Math.abs(y);
		    		x = ((x + y) * (i + 1) * (dr?1:2)) % a_len;
		    		buf.append(array[(dr?x:(a_len - x - 1))]);
		    		dr = !dr;
		    	}
		    	if(goDeeper && (!Character.isLetter(buf.charAt(0))))
		    		buf.insert(0, f);
		
		    	if(goDeeper && buf.length() < 25){
		        	int len = Math.max(30 - buf.length(), buf.length())/2;//len must be <= 15 and >= 7
		//	    	len = Math.min(len , dig.length() - 2); //dig.len must be >= 32 for SHA-1 && MD5 => len must be the same
			    	if(dr){
			    		String s2 = dig.substring(0, Character.isDigit(dig.charAt(1))?(len/2):len);
			    		buf.append(aT(s2, s2, dir,  "N", encoding));
			    	}else{
			    		String s2 = dig.substring(len - ((Character.isDigit(dig.charAt(2)))?(len/2):-1), len + len/2);
			    		buf.append(aT(s2, s2, (dir.equals("Y")?"N":"Y"), "N", encoding));}
		    	}
		    	return buf.toString().substring(0, Math.min(buf.length(), 30));
		    }
	};   
/

-- drop FUNCTION fn_stec_crypt_pw;
CREATE OR REPLACE FUNCTION fn_stec_crypt_pw (
	in_str			IN   VARCHAR2,
	in_s_for_digest	IN   VARCHAR2,
	in_dir			IN   VARCHAR2,
	in_deep			IN   VARCHAR2,
	in_encoding		IN   VARCHAR2
) RETURN VARCHAR2  AS LANGUAGE JAVA NAME
  
    'me.stec.admin.server.STEC_CryptPw.aT(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String) return java.lang.String';
    ;
/

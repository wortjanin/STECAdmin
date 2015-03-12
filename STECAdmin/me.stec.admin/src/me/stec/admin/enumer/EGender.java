package me.stec.admin.enumer;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import me.stec.admin.iface.IAttr;
import me.stec.admin.widget.provider.MPComboGenderMy;

public class EGender {
	public static final EGender Male = new EGender("M");
	public static final EGender Female = new EGender("W");

	@Override
	public boolean equals(Object obj) {
		return sGender.equals(((EGender)obj).sGender);
	}

	public boolean equals(String obj) {
		return sGender.equals(obj);
	}

	@Override
	public int hashCode() {
		return sGender.hashCode();
	}
	
	@Override
	public String toString() {
		return sGender;
	}

	
	private String sGender;
	private EGender(String gender){
		this.sGender = gender;
	}
	
//------------------------------------------------------------------------	
	public static abstract class AAttr extends IAttr{
		@Override
		public Object getVal(Object value) {
			return Inner.bm.get(value);
		}
		@Override
		public String translateVal(Object value) {
			return Inner.translate.get(value);
		}
	}
	
	private static final class Inner{
		private static final BiMap<Object, Object> bm = HashBiMap.create();
		private static final BiMap<Object, String> translate = HashBiMap.create();
		static{
			bm.put(EGender.Male.sGender,	EGender.Male);
			bm.put(EGender.Female.sGender,	EGender.Female);
			ZHelper.setupTranslation(new MPComboGenderMy(), bm, translate);
		}
	}
}

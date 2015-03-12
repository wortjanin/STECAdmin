package me.stec.admin.enumer;

import me.stec.admin.iface.IAttr;
import me.stec.admin.widget.provider.MPComboYN;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

public class EYN {
	public static final EYN Yes = new EYN("Y");
	public static final EYN No = new EYN("N");

	@Override
	public boolean equals(Object obj) {
		return sYesNo.equals(((EYN)obj).sYesNo);
	}

	public boolean equals(String obj) {
		return sYesNo.equals(obj);
	}

	@Override
	public int hashCode() {
		return sYesNo.hashCode();
	}
	
	@Override
	public String toString() {
		return sYesNo;
	}

	
	private String sYesNo;
	private EYN(String gender){
		this.sYesNo = gender;
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
			bm.put(EYN.Yes.sYesNo,	EYN.Yes);
			bm.put(EYN.No.sYesNo,	EYN.No);
			ZHelper.setupTranslation(new MPComboYN(), bm, translate);
		}
	}

}

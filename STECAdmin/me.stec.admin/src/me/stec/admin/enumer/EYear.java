package me.stec.admin.enumer;

import java.math.BigDecimal;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import me.stec.admin.iface.IAttr;
import me.stec.admin.widget.provider.MPComboYearMy;

public class EYear {
	public static final EYear First = new EYear(1);
	public static final EYear Second = new EYear(2);
	public static final EYear Third = new EYear(3);
	public static final EYear Fourth = new EYear(4);
	public static final EYear Fifth = new EYear(5);
	public static final EYear Sixth = new EYear(6);

	@Override
	public boolean equals(Object obj) {
		return bD.equals(((EYear)obj).bD);
	}
	
	@Override
	public int hashCode() {
		return bD.hashCode();
	}
	
	@Override
	public String toString() {
		return bD.toString();
	}

	
	private BigDecimal bD;
	private EYear(int year){
		bD = BigDecimal.valueOf(year);
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
			bm.put(First.bD,	First);
			bm.put(Second.bD,	Second);
			bm.put(Third.bD,	Third);
			bm.put(Fourth.bD,	Fourth);
			bm.put(Fifth.bD,	Fifth);
			bm.put(Sixth.bD,	Sixth);
			ZHelper.setupTranslation(new MPComboYearMy(), bm, translate);
		}
	}

}

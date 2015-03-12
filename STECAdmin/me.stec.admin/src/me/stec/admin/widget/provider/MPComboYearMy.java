package me.stec.admin.widget.provider;


import me.stec.admin.enumer.EYear;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

public class MPComboYearMy  extends AMPCombo {
	private static final BiMap<String, Object> data = HashBiMap.create();

	static{
		data.put("", 			null);
		data.put("1-й курс", 	EYear.First);
		data.put("2-й курс", 	EYear.Second);
		data.put("3-й курс", 	EYear.Third);
		data.put("4-й курс", 	EYear.Fourth);
		data.put("5-й курс", 	EYear.Fifth);
		data.put("6-й курс", 	EYear.Sixth);
		iMaxLength = new Integer("6-й курс".length());
	}

	@Override
	public BiMap<String, Object> getRowList() {
		return data;
	}

	private static final Integer iMaxLength;
	@Override
	public Integer getTextLimit() {
		return iMaxLength;
	}

}

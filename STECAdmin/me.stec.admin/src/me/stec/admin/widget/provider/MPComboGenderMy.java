package me.stec.admin.widget.provider;


import me.stec.admin.enumer.EGender;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;


public class MPComboGenderMy extends AMPCombo {
	private static final BiMap<String, Object> data = HashBiMap.create();
	static{
		data.put("", 		null);
		data.put("Мужской", EGender.Male);
		data.put("Женский", EGender.Female);
		iMaxLength = new Integer("Женский".length());
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

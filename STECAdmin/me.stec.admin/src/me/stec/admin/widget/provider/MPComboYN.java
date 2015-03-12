package me.stec.admin.widget.provider;


import me.stec.admin.enumer.EYN;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;


public class MPComboYN extends AMPCombo {
	private static final BiMap<String, Object> data = HashBiMap.create();
	static{
		data.put("", 		null);
		data.put("да", 		EYN.Yes);
		data.put("нет",	 	EYN.No);
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

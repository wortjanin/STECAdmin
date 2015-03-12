package me.stec.admin.widget.provider;


import com.google.common.collect.BiMap;

public abstract class AMPCombo {
	public abstract BiMap<String, Object> getRowList();
	public abstract Integer getTextLimit();
	
	public Object getVal(String comboKey){
		return getRowList().get(comboKey);
	}

	public String getKey(Object ivalVal){
		return getRowList().inverse().get(ivalVal);
	}

}

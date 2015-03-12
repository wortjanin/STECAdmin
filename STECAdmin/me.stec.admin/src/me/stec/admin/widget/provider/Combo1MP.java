package me.stec.admin.widget.provider;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import me.stec.admin.logic.AItemList;

public class Combo1MP{
	private AItemList aItemList;
	private BiMap<String, Object> data = HashBiMap.create();

	public Combo1MP(AItemList aItemList){
		this.aItemList = aItemList;
		
	}

	public Combo1MP run() throws SQLException{
		data.clear();
		data.put("", null);
		ResultSet rs = aItemList.loadListCombo();
		while (rs.next()){
			//loadListCombo must return 2 and only 2 columns 
			//(1. "number" and 2. "label", NOTE: "label" must be unique)
			data.put(String.valueOf(rs.getObject(2)), rs.getObject(1));
		}
		return this;
	}
	
	public BiMap<String, Object> getRowList() {
		return data;
	}

}

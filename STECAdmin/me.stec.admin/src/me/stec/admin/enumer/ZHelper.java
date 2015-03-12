package me.stec.admin.enumer;

import java.util.Map.Entry;

import me.stec.admin.widget.provider.AMPCombo;

import com.google.common.collect.BiMap;

public final class ZHelper {
	public static void setupTranslation(
			AMPCombo aMPCombo, 
			BiMap<Object, Object> bm,
			BiMap<Object, String> translate){
		BiMap<Object, Object> invBm = bm.inverse();
		BiMap<Object, String> tr = aMPCombo.getRowList().inverse();
		for(Entry<Object, String> e : tr.entrySet()) 
			translate.put(invBm.get(e.getKey()), e.getValue());
	}
}

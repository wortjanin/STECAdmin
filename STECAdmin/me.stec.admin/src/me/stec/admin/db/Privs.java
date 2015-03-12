package me.stec.admin.db;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import me.stec.admin.logic.AItem;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

public class Privs {
	
	private static final int obj = 0, priv = 1, obj_type = 2, gr = 3;  
	private static final BiMap<Integer, String> numNam = HashBiMap.create();
	private static List<String[]> listPrivs = new ArrayList<String[]>(); 

	private static final int SELECT = 0, INSERT = 1, UPDATE = 2, DELETE = 3;  
	private static final BiMap<String, Integer> SIUD = HashBiMap.create();

	private static final List<AItem> listRec = new ArrayList<AItem>();
	
	static{
		numNam.put(obj,			"obj");
		numNam.put(priv, 		"priv");
		numNam.put(obj_type,	"obj_type");
		numNam.put(gr,			"gr");
		
		SIUD.put("SELECT", SELECT);
		SIUD.put("INSERT", INSERT);
		SIUD.put("UPDATE", UPDATE);
		SIUD.put("DELETE", DELETE);
	}
	
	public static void Load() throws SQLException{
		listPrivs.clear();
        Conn.get().prepareCall("call pr_temp_privs_collect()").execute();
        ResultSet rs = Conn.get().prepareStatement(
        		"SELECT " 	+	numNam.get(obj)			+ ", " + 
        						numNam.get(priv)		+ ", " +
        						numNam.get(obj_type)	+ ", " +
        						numNam.get(gr)			+ "  " +
        		"FROM temp_privs " ).executeQuery();
        
        while(rs.next()){
        	String[] objPrivTypeGrant = new String[numNam.size()];
        	for(int i = 0;i < objPrivTypeGrant.length; i++)
        		objPrivTypeGrant[i] = rs.getString(i+1);
        	listPrivs.add(objPrivTypeGrant);
        }
        
        for(AItem aItem: listRec)
        	setupMe(aItem);
	}
	
	
	private static void setupMe(AItem aItem){
		aItem.setCanSelect(false);
		aItem.setCanInsert(false);
		aItem.setCanUpdate(false);
		aItem.setCanDelete(false);
		for(String[] objPrivTypeGrant: listPrivs)
			if(	objPrivTypeGrant[obj].equals(aItem.getDbSchemeName()) &&
				(	objPrivTypeGrant[obj_type].equals("VIEW") || 
					objPrivTypeGrant[obj_type].equals("TABLE")	) 				){
				switch(SIUD.get(objPrivTypeGrant[priv])){
					case SELECT:
						aItem.setCanSelect(true);
						break;
					case INSERT:
						aItem.setCanInsert(true);
						break;
					case UPDATE:
						aItem.setCanUpdate(true);
						break;
					case DELETE:
						aItem.setCanDelete(true);
						break;
					default:
						break;
				}
			}
	}
	
	public static void setup(AItem aItem){
		setupMe(aItem);
		listRec.add(aItem);
	}
	
}

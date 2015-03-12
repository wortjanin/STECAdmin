//*
//* DO NOT EDIT THIS FILE 
//* This file is generated from file ./../me.stec.admin/sql/table/100902_00-09_stec_login.sql 
//* Edit that file if it is necessary and run me.stec.jet.Main for regeneration
//* (me.ste.jet -> right click -> Run As -> Java Application -> Main - me.stec.jet)
//* or create an inherent class to extend the functionality.
//*

package me.stec.admin.logic.user;

import java.sql.SQLException;

import java.math.BigDecimal;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;


import me.stec.admin.iface.IAttr;
import me.stec.admin.iface.IVal;
import me.stec.admin.logic.DbField;
import me.stec.admin.logic.AItem;
import me.stec.admin.db.Privs;

/**
* Логин пользователя
*/
public class Login extends 
AItem{
	@Override
	public String getDbSchemeName(){
		return "STEC_LOGIN";
	}

	@Override
	public boolean getDbSchemeReadOnly(){
		return true;
	}

	@Override
	public BigDecimal getID() {
		return this.getId().getValue();
	}
	@Override
	public void setID(BigDecimal id) {
		this.getId().setValue(id);
	} 

	@Override
	public String getIdDbColumnName() {
		return this.getId().getDbColumnName();
	}

	@Override
	protected String getLoadQuery() {
		return Login.sLoadQuery;
	} 
	@Override
	protected String getInsertQuery() {
		return Login.sInsertQuery;
	} 
	@Override
	protected String getUpdateQuery() {
		return Login.sUpdateQuery;
	} 
	@Override
	protected String getDeleteQuery() {
		return Login.sDeleteQuery;
	} 
	
	protected static final BiMap<String, Integer> columnNumber = HashBiMap.create();
	@Override
	protected BiMap<String, Integer> getColumnNumber() {
		return columnNumber;
	}
	
	/**
	 * NOTE: field m_def SHOULD NEVER BE CHANGED (as well as it's state)  
	 */
	private static final Login m_def = new Login();  
	/**
	 * NOTE: sLoadQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	static{
		FillColumnData(m_def);
	}
	
	/**
	 * NOTE: sLoadQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	private static String sLoadQuery	= m_def.getLoadQueryString();
	/**
	 * NOTE: sInsertQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	private static String sInsertQuery	= m_def.getInsertQueryString();
	/**
	 * NOTE: sUpdateQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	private static String sUpdateQuery	= m_def.getUpdateQueryString();
	/**
	 * NOTE: sDeleteQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	private static String sDeleteQuery	= m_def.getDeleteQueryString();

	
	@Override
	public String getLastIdQuery(){
		return "";
	}

	private static final class Inner{
		private static boolean canSelect = false;
		private static boolean canInsert = false;
		private static boolean canUpdate = false;
		private static boolean canDelete = false;
		static{
			Privs.setup(m_def);
		}
	}

	@Override
	public void setCanSelect(boolean canSelect){
		Login.Inner.canSelect = canSelect;
	}
	@Override
	public boolean canSelect(){
		return 	Login.Inner.canSelect;
	}
	
	@Override
	public void setCanInsert(boolean canInsert){
		Login.Inner.canInsert = canInsert;
	}
	@Override
	public boolean canInsert(){
		return 	Login.Inner.canInsert;
	}

	@Override
	public void setCanUpdate(boolean canUpdate){
		Login.Inner.canUpdate = canUpdate;
	}
	@Override
	public boolean canUpdate(){
		return 	Login.Inner.canUpdate;
	}

	@Override
	public void setCanDelete(boolean canDelete){
		Login.Inner.canDelete = canDelete;
	}
	@Override
	public boolean canDelete(){
		return 	Login.Inner.canDelete;
	}
	
		
		public Login(){
			super(new IVal[]{
				new DbField<BigDecimal, zzzIdAttr>(null, zzzIdAttr.getInstance()),
				new DbField<BigDecimal, zzzIdStecUserAttr>(null, zzzIdStecUserAttr.getInstance()),
				new DbField<String, zzzLoginAttr>(null, zzzLoginAttr.getInstance()),
				new DbField<String, zzzIsBlockedAttr>(null, zzzIsBlockedAttr.getInstance())
			});
		}
		public Login(BigDecimal id, boolean forUpdate)  throws SQLException {
			this();
			this.setID(id);
			load(forUpdate);
		}

		public static Login getDef(){
			return Login.m_def;
		}
		
		public static final class zzzIdAttr extends IAttr{
			private zzzIdAttr(){}
			private static final zzzIdAttr m_Instance = new zzzIdAttr();
			public static zzzIdAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Id";  }
			public String           getDbColumnName()		{ return "STEC_LOGIN_ID"; }  
			public String           getCaption()			{ return "ИН логина"; }  
			public boolean          getDbReadOnly()			{ return true; }  
			public boolean          getDbIsNotNull()		{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, zzzIdAttr> getId() { return (DbField<BigDecimal, zzzIdAttr>)super.val[0]; } 
		public void setId(DbField<BigDecimal, zzzIdAttr> value) { super.val[0].setVal(value.getVal());} 
		public void setId(BigDecimal value) { super.val[0].setVal(value);}
		
		
		public static final class zzzIdStecUserAttr extends IAttr{
			private zzzIdStecUserAttr(){}
			private static final zzzIdStecUserAttr m_Instance = new zzzIdStecUserAttr();
			public static zzzIdStecUserAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "IdStecUser";  }
			public String           getDbColumnName()		{ return "STEC_USER_ID"; }  
			public String           getCaption()			{ return "ИН Пользователя"; }         }
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, zzzIdStecUserAttr> getIdStecUser() { return (DbField<BigDecimal, zzzIdStecUserAttr>)super.val[1]; } 
		public void setIdStecUser(DbField<BigDecimal, zzzIdStecUserAttr> value) { super.val[1].setVal(value.getVal());} 
		public void setIdStecUser(BigDecimal value) { super.val[1].setVal(value);}
		
		
		public static final class zzzLoginAttr extends IAttr{
			private zzzLoginAttr(){}
			private static final zzzLoginAttr m_Instance = new zzzLoginAttr();
			public static zzzLoginAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Login";  }
			public String           getDbColumnName()		{ return "LOGIN"; }  
			public String           getCaption()			{ return "Логин"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzLoginAttr> getLogin() { return (DbField<String, zzzLoginAttr>)super.val[2]; } 
		public void setLogin(DbField<String, zzzLoginAttr> value) { super.val[2].setVal(value.getVal());} 
		public void setLogin(String value) { super.val[2].setVal(value);}
		
		
		public static final class zzzIsBlockedAttr extends IAttr{
			private zzzIsBlockedAttr(){}
			private static final zzzIsBlockedAttr m_Instance = new zzzIsBlockedAttr();
			public static zzzIsBlockedAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "IsBlocked";  }
			public String           getDbColumnName()		{ return "BLOCKED"; }  
			public String           getCaption()			{ return "Аккаунт заблокирован"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzIsBlockedAttr> getIsBlocked() { return (DbField<String, zzzIsBlockedAttr>)super.val[3]; } 
		public void setIsBlocked(DbField<String, zzzIsBlockedAttr> value) { super.val[3].setVal(value.getVal());} 
		public void setIsBlocked(String value) { super.val[3].setVal(value);}
		
		
}
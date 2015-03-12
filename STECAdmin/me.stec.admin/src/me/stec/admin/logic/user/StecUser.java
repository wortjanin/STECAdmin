//*
//* DO NOT EDIT THIS FILE 
//* This file is generated from file ./../me.stec.admin/sql/table/100902_00-06_vw_stec_user.sql 
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
* Пользователь
*/
public class StecUser extends 
AItem{
	@Override
	public String getDbSchemeName(){
		return "VW_STEC_USER";
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
		return StecUser.sLoadQuery;
	} 
	@Override
	protected String getInsertQuery() {
		return StecUser.sInsertQuery;
	} 
	@Override
	protected String getUpdateQuery() {
		return StecUser.sUpdateQuery;
	} 
	@Override
	protected String getDeleteQuery() {
		return StecUser.sDeleteQuery;
	} 
	
	protected static final BiMap<String, Integer> columnNumber = HashBiMap.create();
	@Override
	protected BiMap<String, Integer> getColumnNumber() {
		return columnNumber;
	}
	
	/**
	 * NOTE: field m_def SHOULD NEVER BE CHANGED (as well as it's state)  
	 */
	private static final StecUser m_def = new StecUser();  
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
		return "SELECT sq_stec_user_i.currval FROM DUAL";
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
		StecUser.Inner.canSelect = canSelect;
	}
	@Override
	public boolean canSelect(){
		return 	StecUser.Inner.canSelect;
	}
	
	@Override
	public void setCanInsert(boolean canInsert){
		StecUser.Inner.canInsert = canInsert;
	}
	@Override
	public boolean canInsert(){
		return 	StecUser.Inner.canInsert;
	}

	@Override
	public void setCanUpdate(boolean canUpdate){
		StecUser.Inner.canUpdate = canUpdate;
	}
	@Override
	public boolean canUpdate(){
		return 	StecUser.Inner.canUpdate;
	}

	@Override
	public void setCanDelete(boolean canDelete){
		StecUser.Inner.canDelete = canDelete;
	}
	@Override
	public boolean canDelete(){
		return 	StecUser.Inner.canDelete;
	}
	
		
		public StecUser(){
			super(new IVal[]{
				new DbField<BigDecimal, zzzIdAttr>(null, zzzIdAttr.getInstance()),
				new DbField<String, zzzSurnameAttr>(null, zzzSurnameAttr.getInstance()),
				new DbField<String, zzzNameAttr>(null, zzzNameAttr.getInstance()),
				new DbField<String, zzzPatronymicAttr>(null, zzzPatronymicAttr.getInstance()),
				new DbField<String, zzzGenderAttr>(null, zzzGenderAttr.getInstance()),
				new DbField<String, zzzLoginAttr>(null, zzzLoginAttr.getInstance()),
				new DbField<String, zzzPasswordAttr>(null, zzzPasswordAttr.getInstance()),
				new DbField<Boolean, zzzPassIsTempAttr>(null, zzzPassIsTempAttr.getInstance()),
				new DbField<String, zzzBlockedAttr>(null, zzzBlockedAttr.getInstance()),
				new DbField<BigDecimal, zzzIdCatAttr>(null, zzzIdCatAttr.getInstance()),
				new DbField<String, zzzCatAttr>(null, zzzCatAttr.getInstance())
			});
		}
		public StecUser(BigDecimal id, boolean forUpdate)  throws SQLException {
			this();
			this.setID(id);
			load(forUpdate);
		}

		public static StecUser getDef(){
			return StecUser.m_def;
		}
		
		public static final class zzzIdAttr extends IAttr{
			private zzzIdAttr(){}
			private static final zzzIdAttr m_Instance = new zzzIdAttr();
			public static zzzIdAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Id";  }
			public String           getDbColumnName()		{ return "STEC_USER_ID"; }  
			public String           getCaption()			{ return "ИН Пользователя"; }  
			public boolean          getDbReadOnly()			{ return true; }  
			public boolean          getDbIsNotNull()		{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, zzzIdAttr> getId() { return (DbField<BigDecimal, zzzIdAttr>)super.val[0]; } 
		public void setId(DbField<BigDecimal, zzzIdAttr> value) { super.val[0].setVal(value.getVal());} 
		public void setId(BigDecimal value) { super.val[0].setVal(value);}
		
		
		public static final class zzzSurnameAttr extends IAttr{
			private zzzSurnameAttr(){}
			private static final zzzSurnameAttr m_Instance = new zzzSurnameAttr();
			public static zzzSurnameAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Surname";  }
			public String           getDbColumnName()		{ return "SURNAME"; }  
			public String           getCaption()			{ return "Фамилия"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzSurnameAttr> getSurname() { return (DbField<String, zzzSurnameAttr>)super.val[1]; } 
		public void setSurname(DbField<String, zzzSurnameAttr> value) { super.val[1].setVal(value.getVal());} 
		public void setSurname(String value) { super.val[1].setVal(value);}
		
		
		public static final class zzzNameAttr extends IAttr{
			private zzzNameAttr(){}
			private static final zzzNameAttr m_Instance = new zzzNameAttr();
			public static zzzNameAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Name";  }
			public String           getDbColumnName()		{ return "NAME"; }  
			public String           getCaption()			{ return "Имя"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzNameAttr> getName() { return (DbField<String, zzzNameAttr>)super.val[2]; } 
		public void setName(DbField<String, zzzNameAttr> value) { super.val[2].setVal(value.getVal());} 
		public void setName(String value) { super.val[2].setVal(value);}
		
		
		public static final class zzzPatronymicAttr extends IAttr{
			private zzzPatronymicAttr(){}
			private static final zzzPatronymicAttr m_Instance = new zzzPatronymicAttr();
			public static zzzPatronymicAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Patronymic";  }
			public String           getDbColumnName()		{ return "PATRONYMIC"; }  
			public String           getCaption()			{ return "Отчество"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzPatronymicAttr> getPatronymic() { return (DbField<String, zzzPatronymicAttr>)super.val[3]; } 
		public void setPatronymic(DbField<String, zzzPatronymicAttr> value) { super.val[3].setVal(value.getVal());} 
		public void setPatronymic(String value) { super.val[3].setVal(value);}
		
		
		public static final class zzzGenderAttr extends IAttr{
			private zzzGenderAttr(){}
			private static final zzzGenderAttr m_Instance = new zzzGenderAttr();
			public static zzzGenderAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Gender";  }
			public String           getDbColumnName()		{ return "GENDER"; }  
			public String           getCaption()			{ return "Пол"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzGenderAttr> getGender() { return (DbField<String, zzzGenderAttr>)super.val[4]; } 
		public void setGender(DbField<String, zzzGenderAttr> value) { super.val[4].setVal(value.getVal());} 
		public void setGender(String value) { super.val[4].setVal(value);}
		
		
		public static final class zzzLoginAttr extends IAttr{
			private zzzLoginAttr(){}
			private static final zzzLoginAttr m_Instance = new zzzLoginAttr();
			public static zzzLoginAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Login";  }
			public String           getDbColumnName()		{ return "LOGIN"; }  
			public String           getCaption()			{ return "Логин"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzLoginAttr> getLogin() { return (DbField<String, zzzLoginAttr>)super.val[5]; } 
		public void setLogin(DbField<String, zzzLoginAttr> value) { super.val[5].setVal(value.getVal());} 
		public void setLogin(String value) { super.val[5].setVal(value);}
		
		
		public static final class zzzPasswordAttr extends IAttr{
			private zzzPasswordAttr(){}
			private static final zzzPasswordAttr m_Instance = new zzzPasswordAttr();
			public static zzzPasswordAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Password";  }
			public String           getDbColumnName()		{ return "PW"; }  
			public String           getCaption()			{ return "Пароль"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzPasswordAttr> getPassword() { return (DbField<String, zzzPasswordAttr>)super.val[6]; } 
		public void setPassword(DbField<String, zzzPasswordAttr> value) { super.val[6].setVal(value.getVal());} 
		public void setPassword(String value) { super.val[6].setVal(value);}
		
		
		public static final class zzzPassIsTempAttr extends IAttr{
			private zzzPassIsTempAttr(){}
			private static final zzzPassIsTempAttr m_Instance = new zzzPassIsTempAttr();
			public static zzzPassIsTempAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "PassIsTemp";  }
			public String           getDbColumnName()		{ return "PW_IS_TEMP"; }  
			public String           getCaption()			{ return "Пароль временный"; }  
			public boolean          getDbReadOnly()			{ return true; }  
			public boolean          isBoolean()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<Boolean, zzzPassIsTempAttr> getPassIsTemp() { return (DbField<Boolean, zzzPassIsTempAttr>)super.val[7]; } 
		public void setPassIsTemp(DbField<Boolean, zzzPassIsTempAttr> value) { super.val[7].setVal(value.getVal());} 
		public void setPassIsTemp(Boolean value) { super.val[7].setVal(value);}
		
		
		public static final class zzzBlockedAttr extends IAttr{
			private zzzBlockedAttr(){}
			private static final zzzBlockedAttr m_Instance = new zzzBlockedAttr();
			public static zzzBlockedAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Blocked";  }
			public String           getDbColumnName()		{ return "BLOCKED"; }  
			public String           getCaption()			{ return "Аккаунт заблокирован"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzBlockedAttr> getBlocked() { return (DbField<String, zzzBlockedAttr>)super.val[8]; } 
		public void setBlocked(DbField<String, zzzBlockedAttr> value) { super.val[8].setVal(value.getVal());} 
		public void setBlocked(String value) { super.val[8].setVal(value);}
		
		
		public static final class zzzIdCatAttr extends IAttr{
			private zzzIdCatAttr(){}
			private static final zzzIdCatAttr m_Instance = new zzzIdCatAttr();
			public static zzzIdCatAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "IdCat";  }
			public String           getDbColumnName()		{ return "CAT_ID"; }  
			public String           getCaption()			{ return "ИН Категории"; }         }
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, zzzIdCatAttr> getIdCat() { return (DbField<BigDecimal, zzzIdCatAttr>)super.val[9]; } 
		public void setIdCat(DbField<BigDecimal, zzzIdCatAttr> value) { super.val[9].setVal(value.getVal());} 
		public void setIdCat(BigDecimal value) { super.val[9].setVal(value);}
		
		
		public static final class zzzCatAttr extends IAttr{
			private zzzCatAttr(){}
			private static final zzzCatAttr m_Instance = new zzzCatAttr();
			public static zzzCatAttr getInstance() {return m_Instance; }
			public String           getName()				{ return "Cat";  }
			public String           getDbColumnName()		{ return "CAT"; }  
			public String           getCaption()			{ return "Категория пользователя"; }  
			public boolean          isString()				{ return true; }         }
		@SuppressWarnings("unchecked")
		public DbField<String, zzzCatAttr> getCat() { return (DbField<String, zzzCatAttr>)super.val[10]; } 
		public void setCat(DbField<String, zzzCatAttr> value) { super.val[10].setVal(value.getVal());} 
		public void setCat(String value) { super.val[10].setVal(value);}
		
		
}
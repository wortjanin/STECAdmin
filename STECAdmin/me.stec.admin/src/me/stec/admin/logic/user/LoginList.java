//*
//* DO NOT EDIT THIS FILE 
//* This file is generated from file ./../me.stec.admin/sql/table/100902_00-09_stec_login.sql 
//* Edit that file if it is necessary and run me.stec.jet.Main for regeneration
//* (me.ste.jet -> right click -> Run As -> Java Application -> Main - me.stec.jet)
//* or create an inherent class to extend the functionality.
//*

package me.stec.admin.logic.user;

import java.math.BigDecimal;



import me.stec.admin.iface.IVal;
import me.stec.admin.logic.DbField;
import me.stec.admin.logic.AItemList;

/**
* Список Логин пользователяов
*/
public class LoginList extends 
AItemList{

	@Override
	public String getDbSchemeName(){
		return "STEC_LOGIN";
	}
	
	@Override
	public boolean getDbSchemeReadOnly(){
		return true;
	}

	@Override
	protected String getLoadQuery() {
		return LoginList.sLoadQuery;
	}
	@Override
	protected String getLoadComboQuery(){
		return LoginList.sLoadComboQuery;
	}
	@Override
	protected String getDeleteQuery() {
		return LoginList.sDeleteQuery;
	}
	/**
	 * NOTE: m_def should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	protected static final LoginList m_def = new LoginList();
//	static{
//		m_def.sOrderBy = m_def.sOrderByCombo = " ORDER BY " + m_def.getId().getDbColumnName();
//	}
	
	/**
	 * NOTE: sLoadQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	protected static String sLoadQuery		= m_def.getLoadQueryString();
	/**
	 * NOTE: sLoadComboQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	protected static String sLoadComboQuery = m_def.getLoadComboQueryString();
	/**
	 * NOTE: sDeleteQuery should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	protected static String sDeleteQuery	= m_def.getDeleteQueryString();
	
		public LoginList(){
			this(false,		0);
		}
		public LoginList(boolean bDistinct){
			this(bDistinct, 0);//0 (or negative int) means no limit
		}
		public LoginList(boolean bDistinct, int iLimit){
			super(new IVal[]{
				new DbField<BigDecimal, Login.zzzIdAttr>(null, Login.zzzIdAttr.getInstance()),
				new DbField<BigDecimal, Login.zzzIdStecUserAttr>(null, Login.zzzIdStecUserAttr.getInstance()),
				new DbField<String, Login.zzzLoginAttr>(null, Login.zzzLoginAttr.getInstance()),
				new DbField<String, Login.zzzIsBlockedAttr>(null, Login.zzzIsBlockedAttr.getInstance())
			});
			
			super.bDistinct 	= bDistinct;
			super.iLimit		= iLimit;
			
			if (null == m_def)	return;
			
			super.getListHeader().addAll(m_def.getListHeader());
			super.sOrderBy		= m_def.sOrderBy;
			super.sOrderByCombo	= m_def.sOrderByCombo;
			
		}

		@Override
		public Login getItemDef(){
			return Login.getDef();
		}
		
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, Login.zzzIdAttr> getId() { return (DbField<BigDecimal, Login.zzzIdAttr>)super.val[0]; } 
		public void setId(DbField<BigDecimal, Login.zzzIdAttr> value) { super.val[0].setVal(value.getVal());}
		public void setId(BigDecimal value) { super.val[0].setVal(value);}
		 
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, Login.zzzIdStecUserAttr> getIdStecUser() { return (DbField<BigDecimal, Login.zzzIdStecUserAttr>)super.val[1]; } 
		public void setIdStecUser(DbField<BigDecimal, Login.zzzIdStecUserAttr> value) { super.val[1].setVal(value.getVal());}
		public void setIdStecUser(BigDecimal value) { super.val[1].setVal(value);}
		 
		@SuppressWarnings("unchecked")
		public DbField<String, Login.zzzLoginAttr> getLogin() { return (DbField<String, Login.zzzLoginAttr>)super.val[2]; } 
		public void setLogin(DbField<String, Login.zzzLoginAttr> value) { super.val[2].setVal(value.getVal());}
		public void setLogin(String value) { super.val[2].setVal(value);}
		 
		@SuppressWarnings("unchecked")
		public DbField<String, Login.zzzIsBlockedAttr> getIsBlocked() { return (DbField<String, Login.zzzIsBlockedAttr>)super.val[3]; } 
		public void setIsBlocked(DbField<String, Login.zzzIsBlockedAttr> value) { super.val[3].setVal(value.getVal());}
		public void setIsBlocked(String value) { super.val[3].setVal(value);}
		 
}

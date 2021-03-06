//*
//* DO NOT EDIT THIS FILE 
//* This file is generated from file ./../me.stec.admin/sql/table/100902_00-07_stec_group.sql 
//* Edit that file if it is necessary and run me.stec.jet.Main for regeneration
//* (me.ste.jet -> right click -> Run As -> Java Application -> Main - me.stec.jet)
//* or create an inherent class to extend the functionality.
//*

package me.stec.admin.logic.org;

import java.math.BigDecimal;



import me.stec.admin.iface.IVal;
import me.stec.admin.logic.DbField;
import me.stec.admin.logic.AItemList;

/**
* Список Групп
*/
public class StecGroupList extends 
AItemList{

	@Override
	public String getDbSchemeName(){
		return "STEC_GROUP";
	}
	
	@Override
	public boolean getDbSchemeReadOnly(){
		return true;
	}

	@Override
	protected String getLoadQuery() {
		return StecGroupList.sLoadQuery;
	}
	@Override
	protected String getLoadComboQuery(){
		return StecGroupList.sLoadComboQuery;
	}
	@Override
	protected String getDeleteQuery() {
		return StecGroupList.sDeleteQuery;
	}
	/**
	 * NOTE: m_def should NEVER be changed DYNAMICALLY, 
	 * only a static context is encouraged for any change  
	 */
	protected static final StecGroupList m_def = new StecGroupList();
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
	
		public StecGroupList(){
			this(false,		0);
		}
		public StecGroupList(boolean bDistinct){
			this(bDistinct, 0);//0 (or negative int) means no limit
		}
		public StecGroupList(boolean bDistinct, int iLimit){
			super(new IVal[]{
				new DbField<BigDecimal, StecGroup.zzzIdAttr>(null, StecGroup.zzzIdAttr.getInstance()),
				new DbField<String, StecGroup.zzzNameAttr>(null, StecGroup.zzzNameAttr.getInstance()),
				new DbField<String, StecGroup.zzzTechNameAttr>(null, StecGroup.zzzTechNameAttr.getInstance())
			});
			
			super.bDistinct 	= bDistinct;
			super.iLimit		= iLimit;
			
			if (null == m_def)	return;
			
			super.getListHeader().addAll(m_def.getListHeader());
			super.sOrderBy		= m_def.sOrderBy;
			super.sOrderByCombo	= m_def.sOrderByCombo;
			
		}

		@Override
		public StecGroup getItemDef(){
			return StecGroup.getDef();
		}
		
		@SuppressWarnings("unchecked")
		public DbField<BigDecimal, StecGroup.zzzIdAttr> getId() { return (DbField<BigDecimal, StecGroup.zzzIdAttr>)super.val[0]; } 
		public void setId(DbField<BigDecimal, StecGroup.zzzIdAttr> value) { super.val[0].setVal(value.getVal());}
		public void setId(BigDecimal value) { super.val[0].setVal(value);}
		 
		@SuppressWarnings("unchecked")
		public DbField<String, StecGroup.zzzNameAttr> getName() { return (DbField<String, StecGroup.zzzNameAttr>)super.val[1]; } 
		public void setName(DbField<String, StecGroup.zzzNameAttr> value) { super.val[1].setVal(value.getVal());}
		public void setName(String value) { super.val[1].setVal(value);}
		 
		@SuppressWarnings("unchecked")
		public DbField<String, StecGroup.zzzTechNameAttr> getTechName() { return (DbField<String, StecGroup.zzzTechNameAttr>)super.val[2]; } 
		public void setTechName(DbField<String, StecGroup.zzzTechNameAttr> value) { super.val[2].setVal(value.getVal());}
		public void setTechName(String value) { super.val[2].setVal(value);}
		 
}

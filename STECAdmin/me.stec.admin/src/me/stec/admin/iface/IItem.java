/**
 * 
 */
package me.stec.admin.iface;

import java.sql.SQLException;

import java.math.BigDecimal;

/**
 * @author chernoivanov
 *
 */
public interface IItem {
	BigDecimal getID();
	void	setID(BigDecimal id);

	IVal	getComboName();
	
	String	getIdDbColumnName();

	void	load(boolean forUpdate) throws SQLException;
	int		acceptChanges()			throws SQLException;
	int		delete()				throws SQLException;
	
	void setCanSelect(boolean canSelect);
	boolean canSelect();
	void setCanInsert(boolean canInsert);
	boolean canInsert();
	void setCanUpdate(boolean canUpdate);
	boolean canUpdate();
	void setCanDelete(boolean canDelete);
	boolean canDelete();

}


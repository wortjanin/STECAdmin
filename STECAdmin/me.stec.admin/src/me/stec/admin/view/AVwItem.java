package me.stec.admin.view;

import java.math.BigDecimal;
import java.sql.SQLException;


public abstract class AVwItem extends AVw {

	public abstract String getVwId();
	public abstract void setItem(BigDecimal id, boolean forUpdate) throws SQLException;
	public abstract void setReady();
	
	public abstract int getMinWidth();
	public abstract int getMinHeight();

}

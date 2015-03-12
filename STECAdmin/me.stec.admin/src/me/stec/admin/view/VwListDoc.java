package me.stec.admin.view;

//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Statement;
//
//import me.stec.admin.db.Conn;

import me.stec.admin.widget.filter.WgFilterDoc;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

public class VwListDoc extends AVwList {

	private static final String ID = "me.stec.admin.view.VwListDoc";  //  @jve:decl-index=0:
	public static String getId() {	return ID;	}

	private static VwListDoc vwListDoc;
	static VwListDoc getInstance(){
		return vwListDoc;
	}

	private static 	WgFilterDoc wgFilterDoc;
	public Control wgFilterControlGet(){
		return wgFilterDoc;
	}
	static void setWgFilterControl(WgFilterDoc wgFilterDoc){
		VwListDoc.wgFilterDoc = wgFilterDoc;
	}


	public VwListDoc() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void createPartControl(Composite parent) {
		vwListDoc = this;
		super.createPartControl(parent);
	}

	
	
//	private void setStatusLine(String message) {
//		// Get the status line and set the text
//		IActionBars bars = getViewSite().getActionBars();
//		bars.getStatusLineManager().setMessage(message);
//	}

	
	@Override
	public void setFocus() {
	}
	@Override
	public void wgFilterControlClear() {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void wgFilterControlRun() {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void setMyFocus() {
		super.setMyFocus();
		vwFilter.drawWgFilterControl(this);
	}

	
}  //  @jve:decl-index=0:visual-constraint="0,0"

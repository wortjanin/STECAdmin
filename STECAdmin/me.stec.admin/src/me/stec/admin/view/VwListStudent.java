package me.stec.admin.view;



//import me.stec.admin.iface.IVal;



import java.sql.SQLException;

import me.stec.admin.iface.IWg2IVal;
import me.stec.admin.iface.IWg2IVal.WgIValPair;
import me.stec.admin.logic.user.*;
import me.stec.admin.widget.filter.WgFilterStudent;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

public class VwListStudent extends AVwList {


	private static final String ID = "me.stec.admin.view.VwListStudent";  //  @jve:decl-index=0:
	public static String getId() {	return ID;	}

	private static VwListStudent vwListStudent;
	static VwListStudent getInstance(){
		return vwListStudent;
	}

	private static StudentList studentList = new StudentList();// = new StudentList();
	private static 	WgFilterStudent wgFilterStudent;
	public Control wgFilterControlGet(){
		return wgFilterStudent;
	}
 
	private static IWg2IVal iWg2IVal;
	static void setWgFilterControl(final WgFilterStudent wgFS){
		VwListStudent.wgFilterStudent = wgFS;
		iWg2IVal = new IWg2IVal(new WgIValPair[]{
				new WgIValPair(wgFS.getTSurname()	,  studentList.getSurname()), 
				new WgIValPair(wgFS.getTName()		,  studentList.getName()), 
				new WgIValPair(wgFS.getTPatronymic(),  studentList.getPatronymic()), 
				new WgIValPair(wgFS.getCGender()	,  studentList.getGender()), 
				new WgIValPair(wgFS.getTLogin()		,  studentList.getLogin(), false),
				new WgIValPair(wgFS.getCFaculty()	,  studentList.getFaculty()), 
				new WgIValPair(wgFS.getCSpeciality(),  studentList.getSpeciality()), 
				new WgIValPair(wgFS.getCGroup()		,  studentList.getGroupUniver())
//				studentList.setYear(Integer.decode(wgFS.getCYear().getText().replaceAll("[^0-9]+", "")));
				 }) {
			public void clearWg(){
				super.clearWg();
				wgFS.getCYear().setText("");
				wgFS.getCGender().getCCombo().setText("");
				//--------------------------- yet unused controls:
				wgFS.getTLogin().setText("");
				wgFS.getCContrForm().setText("");
				wgFS.getCEduForm().setText("");
				wgFS.getCStuGroup().setText("");
				wgFS.getBCardReceived().setSelection(false);
				wgFS.getBCardRequesters().setSelection(false);
				wgFS.getBPasswordsRegenerated().setSelection(false);
				wgFS.getBSurnameChangeRequesters().setSelection(false);	} 
			public void dataFromWg() {
				super.dataFromWg();
//				try{studentList.setYear(Integer.decode(wgFS.getCYear().getText().replaceAll("[^0-9]+", "")));}catch(Throwable e){}
			}
		};
	}

	

	public VwListStudent() {
		super.ini(studentList);
	}
	@Override
	public void createPartControl(Composite parent) {
		vwListStudent = this;
		if(null != vwFilter) vwFilter.setCurrent(this);
		super.createPartControl(parent);
		super.setColumn(titles.indexOf(studentList.getSpeciality()), false);
//		super.setColumn(titles.indexOf(studentList.getGender()), false);
		top.setBackground(VwFilter.getColorBorder());
	}

	@Override
	public void setFocus() {
	}

	public void setMyFocus() {
		super.setMyFocus();
		vwFilter.drawWgFilterControl(this);
	}

	
	@Override
	public void wgFilterControlClear() {
		iWg2IVal.clearWg(); 
	}

	@Override
	public void wgFilterControlRun() throws SQLException {
		iWg2IVal.dataFromWg(); 
		tableViewer.setInput(itemList.run().getRowList());
	}
}  //  @jve:decl-index=0:visual-constraint="10,10"

package me.stec.admin.view;

import java.math.BigDecimal;
import java.sql.SQLException;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.layout.FillLayout;

import me.stec.admin.widget.item.WgItemStudent;

public class VwItemStudent extends AVwItem {

	private static final String ID = "me.stec.admin.view.VwItemStudent"; //$NON-NLS-1$

	public VwItemStudent() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		parent.setLayout(new FillLayout(SWT.HORIZONTAL));
		{
			wgItemStudent = new WgItemStudent(parent, SWT.NONE);
			wgItemStudent.setVisible(false);
		}

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	public void setReady(){
		wgItemStudent.setVisible(true);
	}
	
	WgItemStudent wgItemStudent;
	public int getMinWidth(){
		return wgItemStudent.getMinWidth();
	}
	public int getMinHeight(){
		return wgItemStudent.getMinHeight();
	}
	
	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
	}

	/**
	 * Initialize the toolbar.
	 */
	private void initializeToolBar() {
//		IToolBarManager toolbarManager = getViewSite().getActionBars()
//				.getToolBarManager();
	}

	/**
	 * Initialize the menu.
	 */
	private void initializeMenu() {
//		IMenuManager menuManager = getViewSite().getActionBars()
//				.getMenuManager();
	}

	@Override
	public void setFocus() {
		// Set the focus
	}

	/**
	 * @return the id
	 */
	public static String getId() {
		return ID;
	}

	public void setItem(BigDecimal bdID, boolean forUpdate) throws SQLException{
		wgItemStudent.setAItem(bdID, forUpdate);
	}

	@Override
	public String getVwId() {
		// TODO Auto-generated method stub
		return ID;
	}

	@Override
	public void leaveMyFocus(boolean nextIsFilter) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setMyFocus() {
		// TODO Auto-generated method stub
		
	}
}

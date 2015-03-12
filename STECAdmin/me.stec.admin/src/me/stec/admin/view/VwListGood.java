package me.stec.admin.view;

//import org.eclipse.jface.action.IMenuManager;
//import org.eclipse.jface.action.IToolBarManager;
//import org.eclipse.swt.SWT;
import me.stec.admin.widget.filter.WgFilterGood;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

public class VwListGood extends AVwList {

	private static final String ID = "me.stec.admin.view.VwListGood"; //$NON-NLS-1$

	private static 	WgFilterGood wgFilterGood;
	public Control wgFilterControlGet(){
		return wgFilterGood;
	}
	static void setWgFilterControl(WgFilterGood wgFilterGood){
		VwListGood.wgFilterGood = wgFilterGood;
	}

	public VwListGood() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
//		Composite container = new Composite(parent, SWT.NONE);
		super.createPartControl(parent);

		createActions();
		initializeToolBar();
		initializeMenu();
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
	}

	public static String getId() {
		return ID;
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

}

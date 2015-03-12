package me.stec.admin.view;

//import org.eclipse.jface.action.IMenuManager;
//import org.eclipse.jface.action.IToolBarManager;
//import org.eclipse.swt.SWT;
import me.stec.admin.widget.filter.WgFilterDocGroup;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

public class VwListDocGroup extends AVwList {

	private static final String ID = "me.stec.admin.view.VwListDocGroup"; //$NON-NLS-1$
	public static String getId() {
		return ID;
	}

	private static VwListDocGroup vwListDocGroup;
	static VwListDocGroup getInstance(){
		return vwListDocGroup;
	}

	private static 	WgFilterDocGroup wgFilterDocGroup;
	public Control wgFilterControlGet(){
		return wgFilterDocGroup;
	}
	static void setWgFilterControl(WgFilterDocGroup wgFilterDocGroup){
		VwListDocGroup.wgFilterDocGroup = wgFilterDocGroup;
	}

	public VwListDocGroup() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		vwListDocGroup = this;
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

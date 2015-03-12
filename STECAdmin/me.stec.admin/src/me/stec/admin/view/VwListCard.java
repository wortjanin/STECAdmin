package me.stec.admin.view;

//import org.eclipse.jface.action.IMenuManager;
//import org.eclipse.jface.action.IToolBarManager;
//import org.eclipse.swt.SWT;
import me.stec.admin.widget.filter.WgFilterCard;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;

public class VwListCard extends AVwList {

	private static final String ID = "me.stec.admin.view.VwListCard"; //$NON-NLS-1$
	public static String getId() {
		return ID;
	}

	private static VwListCard vwListCard;
	static VwListCard getInstance(){
		return vwListCard;
	}
	
	private static 	WgFilterCard wgFilterCard;
	public Control wgFilterControlGet(){
		return wgFilterCard;
	}
	static void setWgFilterControl(WgFilterCard wgFilterCard){
		VwListCard.wgFilterCard = wgFilterCard;
	}

	public VwListCard() {

	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		VwListCard.vwListCard = this;

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
//		this.
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

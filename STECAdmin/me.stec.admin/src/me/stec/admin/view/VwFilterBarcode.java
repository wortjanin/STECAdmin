package me.stec.admin.view;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.jface.action.Action;
import com.swtdesigner.ResourceManager;

public class VwFilterBarcode extends AVw {

	private static final String ID = "me.stec.admin.view.VwFilterBarcode"; //$NON-NLS-1$

	Composite composite;
	private Action clear;
	private Action find;
	
	public VwFilterBarcode() {
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
		composite = new Composite(parent, SWT.NONE);

		createActions();
		initializeToolBar();
		initializeMenu();
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		// Create the actions
		{
			clear = new Action("Очистить") {
			};
			clear.setImageDescriptor(ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/delete.gif"));
			clear.setToolTipText("Очистить штрихкод");
		}
		{
			find = new Action("Найти") {
			};
			find.setImageDescriptor(ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/Search.png"));
			find.setToolTipText("Найти");
		}
	}

	/**
	 * Initialize the toolbar.
	 */
	private void initializeToolBar() {
		IToolBarManager toolbarManager = getViewSite().getActionBars()
				.getToolBarManager();
		toolbarManager.add(clear);
		toolbarManager.add(find);
	}

	/**
	 * Initialize the menu.
	 */
	private void initializeMenu() {
		IMenuManager menuManager = getViewSite().getActionBars()
				.getMenuManager();
		menuManager.add(find);
		menuManager.add(clear);
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

	@Override
	public void leaveMyFocus(boolean nextIsFilter) {
		 // TODO Auto-generated method stub
		this.composite.getParent().setBackground(nextIsFilter?null:VwFilter.getColorBorder());
		this.composite.layout();
	}

	@Override
	public void setMyFocus() {
		// TODO Auto-generated method stub
		
	}

}

package me.stec.admin.view;

//import org.eclipse.jface.action.IMenuManager;
//import org.eclipse.jface.action.IToolBarManager;
import java.sql.SQLException;

import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;


import com.swtdesigner.SWTResourceManager;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.custom.StackLayout;
import org.eclipse.swt.graphics.Color;

import me.stec.admin.widget.filter.WgFilterCard;
import me.stec.admin.widget.filter.WgFilterDoc;
import me.stec.admin.widget.filter.WgFilterDocGroup;
import me.stec.admin.widget.filter.WgFilterGood;
import me.stec.admin.widget.filter.WgFilterOrder;
import me.stec.admin.widget.filter.WgFilterStudent;

import org.eclipse.jface.action.Action;
import com.swtdesigner.ResourceManager;
import org.eclipse.swt.layout.FillLayout;

public class VwFilter extends AVw {

	private static final String ID = "me.stec.admin.view.VwFilter"; //$NON-NLS-1$
	private Composite composite;
	private StackLayout compositeStackLayout;
	
	private static Color colorBorder = SWTResourceManager.getColor(157, 167, 195);
	public static Color getColorBorder(){
		return colorBorder;
	}
	
	public VwFilter() {
		//this.
	}

	public void Run(){
		try {
			aVwCurrent.wgFilterControlRun();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public void Clear(){
		aVwCurrent.wgFilterControlClear();
	}

	/**
	 * Create contents of the view part.
	 * @param parent
	 */
	@Override
	public void createPartControl(Composite parent) {
//		parent.addListener(SWT.Resize, new Listener() {
//			public void handleEvent(Event e) {
//				//System.out.println(composite.getSize());
//				if(composite.getSize().x < iMinSizeX || composite.getSize().x < iMinSizeY){
//					composite.pack();
////					composite.setBounds(composite.getLocation().x, composite.getLocation().y, iMinSizeX, iMinSizeY);
//				}
//			}});
		
		WgFilterStudent wgFilterStudent;
		AVwList.setVwFilter(this);
		FillLayout fl_parent = new FillLayout(SWT.HORIZONTAL);
		fl_parent.marginWidth = 3;
		fl_parent.marginHeight = 3;
		parent.setLayout(fl_parent);
		{
			ScrolledComposite scrolledComposite = new ScrolledComposite(parent, SWT.H_SCROLL | SWT.V_SCROLL);
			scrolledComposite.setExpandHorizontal(true);
			scrolledComposite.setExpandVertical(true);
			composite = new Composite(scrolledComposite, SWT.NONE);
			composite.setLayout(this.compositeStackLayout =  new StackLayout());
			VwListStudent.setWgFilterControl(wgFilterStudent = new WgFilterStudent(composite, SWT.NONE));
			VwListCard.setWgFilterControl(new WgFilterCard(composite, SWT.NONE));
			VwListDoc.setWgFilterControl(new WgFilterDoc(composite, SWT.NONE));
			VwListDocGroup.setWgFilterControl(new WgFilterDocGroup(composite, SWT.NONE));
			VwListOrder.setWgFilterControl(new WgFilterOrder(composite, SWT.NONE));
			VwListGood.setWgFilterControl(new WgFilterGood(composite, SWT.NONE));
			this.compositeStackLayout.topControl = wgFilterStudent;
			scrolledComposite.setContent(composite);
			scrolledComposite.setMinSize(composite.computeSize(SWT.DEFAULT, SWT.DEFAULT));
		}
		this.aVwCurrent = VwListStudent.getInstance();
		createActions();
		initializeToolBar();
		initializeMenu();
		meIsCurrent = true;
		
	}

	/**
	 * Create the actions.
	 */
	private void createActions() {
		{
			clear = new Action("Очистить") {
				public void run() {
					super.run();
					VwFilter.this.Clear();		}	};
			clear.setToolTipText("Очистить фильтр");
			clear.setImageDescriptor(ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/delete.gif"));
		}
		{
			find = new Action("Найти") {
				public void run() {
					super.run();
					VwFilter.this.Run();	}	};
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

	public static String getId() {
		return ID;
	}

	void setCurrent(AVwList aVwCurrent){
		this.aVwCurrent = aVwCurrent;
	}
	private AVwList aVwCurrent = null;
	private boolean meIsCurrent = true;
	private Action clear;
	private Action find;
	
	private void process(AVwList me){
		if(meIsCurrent){
			this.leaveMyFocus(false);
			if(!me.equals(aVwCurrent)){
				aVwCurrent.leaveMyFocus(false);
				aVwCurrent = me;
			}
		}			
		else{
			aVwCurrent.leaveMyFocus(false);
			aVwCurrent = me;
		}
	}
	
	public void drawWgFilterControl(AVwList me) {
		this.compositeStackLayout.topControl = me.wgFilterControlGet();
		process(me);
		this.composite.layout();
	}
	
	@Override
	public void setFocus() {
	}

	private boolean meIsActivated = false;
	@Override
	public void setMyFocus() {
		if(!meIsActivated) {meIsActivated=true; return;}
		aVwCurrent.leaveMyFocus(true);
		this.composite.getParent().getParent().setBackground(null);
		this.composite.getParent().getParent().layout();
		meIsCurrent = true;
	}

	@Override
	public void leaveMyFocus(boolean nextIsFilter) {
		this.composite.getParent().getParent().setBackground(nextIsFilter?null:getColorBorder());
		this.composite.getParent().getParent().layout();
		meIsCurrent = false;
	}

	
}

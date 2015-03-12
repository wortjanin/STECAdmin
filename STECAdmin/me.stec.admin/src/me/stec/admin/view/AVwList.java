package me.stec.admin.view;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
//import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import me.stec.admin.iface.IAttr;
import me.stec.admin.iface.IVal;
import me.stec.admin.logic.AItemList;
import me.stec.admin.logic.DbField;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.swt.widgets.MenuItem;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.widgets.ToolBar;

import com.swtdesigner.ResourceManager;
import com.swtdesigner.SWTResourceManager;

import org.eclipse.jface.viewers.CellEditor;
import org.eclipse.jface.viewers.CheckboxCellEditor;
import org.eclipse.jface.viewers.ColumnViewer;
import org.eclipse.jface.viewers.EditingSupport;
import org.eclipse.jface.viewers.IStructuredContentProvider;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.ITableLabelProvider;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.TableViewerColumn;
import org.eclipse.jface.viewers.Viewer;
import org.eclipse.jface.viewers.ViewerSorter;
import org.eclipse.swt.widgets.ToolItem;

import me.stec.admin.widget.list.WgListSum;

public abstract class AVwList  extends AVw {
	public AVwList() {
	}

	protected final void ini(AItemList aItemList){
		this.aItemList = aItemList;
		titles = this.aItemList.getHeader();
		titles.add(0, this.dbFCheck);
//		titles.add(this.dbFSelect);
		for(iTID = 0 ;iTID < titles.size();iTID++)
			if(titles.get(iTID).getAttr().getClass().getName().equals(
					aItemList.getId().getAttr().getClass().getName()))
				break;
		assert iTID < titles.size();
	}
	private int iTID=0;
	
	private void setupWgAccessibility(int itemCount){
		if(null == this.aItemList){
			top.setEnabled(false);
			toolBar.setEnabled(false);
			return;
		}
		boolean bCheck = itemCount > 0;
		this.checkAll.setEnabled(bCheck);
		this.uncheckAll.setEnabled(bCheck);
		this.checkInvert.setEnabled(bCheck);
		int selNum = ((IStructuredSelection)tableViewer.getSelection()).size();
		setupCheckButtons(0 < selNum);
		setupOpenButtons(1 == selNum);
		this.create.setEnabled(this.aItemList.getItemDef().canInsert());
		this.delete.setEnabled((0 <  iChecked	) && this.aItemList.getItemDef().canDelete());
	}
	
	private void setupOpenButtons(boolean enabled){
		this.open.setEnabled(enabled && aItemList.getItemDef().canSelect());
		this.edit.setEnabled(enabled && aItemList.getItemDef().canUpdate());
	}
	
	private void setupCheckButtons(boolean enabled){
		this.check.setEnabled(enabled);
		this.uncheck.setEnabled(enabled);
	}
	
	
	
	private GridLayout layout;
	protected Composite top;
	private ToolBar toolBar;
	protected AItemList aItemList;
	protected List<IVal> titles = new ArrayList<IVal>();
	
	protected static VwFilter vwFilter;
//	protected Table table;
	protected TableViewer tableViewer;
	public static void setVwFilter(VwFilter vwFilter){
		AVwList.vwFilter = vwFilter;
	}

	protected void setColumn(int j, boolean visible){
		TableColumn tc = tableViewer.getTable().getColumn(j);
		tc.setWidth(visible?bound:0);
		tc.setResizable(visible);
//		tableViewer.getTable().getMenu().getItems()[j].setSelection(visible);
		listMenuItem.get(j).setSelection(visible);
	}
	private Menu headerMenu;

	private void createColumns(final Composite parent, final TableViewer viewer) {
		headerMenu = new Menu(parent);
		for (int i = 0; i < titles.size(); i++) {
			//TableViewerColumn column = new TableViewerColumn(viewer, SWT.NONE);
			final TableViewerColumn viewerColumn = new TableViewerColumn(
					viewer, SWT.NONE);
			final TableColumn column = viewerColumn.getColumn();
			IAttr ia = titles.get(i).getAttr();
			column.setText(ia.getCaption());

			if(ia.equals(dbFCheck.getAttr())){	column.setAlignment(SWT.CENTER);}
			column.setMoveable(true);
			column.setToolTipText(ia.getCaption());
			viewerColumn.setEditingSupport(new ItemListES(viewer, i));

//			if(ia.equals(dbFSelect.getAttr())){
//				column.setWidth(0);
//				column.setResizable(false);
//			}else{
				column.setWidth(bound);
				column.setResizable(true);
				createMenuItem(headerMenu, column, ia);
//			}
			
			// Setting the right sorter
			final int index = i;
			column.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(SelectionEvent e) {
					tableViewer.setSelection(null);
					setupCheckButtons(false);
					setupOpenButtons(false);
					wgListSum.getSelected().setText("0");
					tableSorter.setColumn(index);
					tableViewer.getTable().setSortDirection(tableSorter.getDirection());
					tableViewer.getTable().setSortColumn(column);
					tableViewer.refresh();
					top.layout();
				}
				@Override
				public void widgetDefaultSelected(SelectionEvent e) {
				}
			});
		}
		final Table table = viewer.getTable();
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
		table.addListener(SWT.MenuDetect, new Listener() {
			public void handleEvent(Event event) {
				table.setMenu(headerMenu);
			}
		});

	}

	protected int bound = 100;

	private List<MenuItem> listMenuItem = new ArrayList<MenuItem>();
	private void createMenuItem(Menu parent, final TableColumn column, final IAttr ia) {
		final MenuItem itemName = new MenuItem(parent, SWT.CHECK);
		itemName.setText(column.getText());
		itemName.setSelection(column.getResizable());
		itemName.addListener(SWT.Selection, new Listener() {
			public void handleEvent(Event event) {
				if (itemName.getSelection()) {
					column.setWidth(bound);
					column.setResizable(true);
				} else {
					column.setWidth(0);
					column.setResizable(false);
				}
			}
		});
		listMenuItem.add(itemName);
	}

	protected ItemListVS tableSorter = new ItemListVS();
//	private int iVwCount=0;
	@Override
	public void createPartControl(Composite parent) {
        layout = new GridLayout();
        layout.verticalSpacing = 3;
        layout.horizontalSpacing = 3;
        layout.marginHeight = 3;
        layout.marginWidth = 3;
        top = new Composite(parent, SWT.NONE);
        top.setLayout(layout);
      
        toolBar = new ToolBar(top, SWT.FLAT | SWT.RIGHT);
        toolBar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
        toolBar.setBackground(SWTResourceManager.getColor(SWT.COLOR_WIDGET_BACKGROUND));
        
        checkAll = new ToolItem(toolBar, SWT.NONE);
        checkAll.addSelectionListener(new SelectionAdapter() {
        	@Override
        	public void widgetSelected(SelectionEvent e) {
        		checkAll(Boolean.TRUE);
        	}
        });
        checkAll.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/check_all.png"));
        checkAll.setToolTipText("Выбрать всех");
        
        uncheckAll = new ToolItem(toolBar, SWT.NONE);
        uncheckAll.addSelectionListener(new SelectionAdapter() {
        	@Override
        	public void widgetSelected(SelectionEvent e) {
        		checkAll(Boolean.FALSE);
        	}
        });
        uncheckAll.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/clear_all.png"));
        uncheckAll.setToolTipText("Очистить выборку");

        checkInvert = new ToolItem(toolBar, SWT.NONE);
        checkInvert.addSelectionListener(new SelectionAdapter() {
        	@Override
        	public void widgetSelected(SelectionEvent e) {
        		invertAll();
        	}
        });
        checkInvert.setToolTipText("Инвертировать выборку");
        checkInvert.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/check_invert_all.png"));
        
        check = new ToolItem(toolBar, SWT.NONE);
        check.addSelectionListener(new SelectionAdapter() {
        	@Override
        	public void widgetSelected(SelectionEvent e) {
        		checkSelected(Boolean.TRUE);
        	}
        });
        check.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/check.png"));
        check.setToolTipText("Выбрать выделенных");
        
        uncheck = new ToolItem(toolBar, SWT.NONE);
        uncheck.addSelectionListener(new SelectionAdapter() {
        	@Override
        	public void widgetSelected(SelectionEvent e) {
        		checkSelected(Boolean.FALSE);
        	}
        });
        uncheck.setToolTipText("Очистить выборку у выделенных");
        uncheck.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/clear.png"));
        
        open = new ToolItem(toolBar, SWT.NONE);
        open.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/open.png"));
        open.setToolTipText("Открыть");
        open.addSelectionListener(new SelectionAdapter() {
			@Override
        	public void widgetSelected(SelectionEvent e) {
				IStructuredSelection sel = (IStructuredSelection)tableViewer.getSelection();
				if(sel.size() != 1) return;
				ElementOpen(top, (BigDecimal)((Object[])((IStructuredSelection)tableViewer.getSelection()).toArray()[0])[iTID], false);
        	}
        });
        
        create = new ToolItem(toolBar, SWT.NONE);
        create.setToolTipText("Создать");
        create.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/new.png"));
        create.addSelectionListener(new SelectionAdapter() {
			@Override
        	public void widgetSelected(SelectionEvent e) {
				ElementOpen(top, null, true);
        	}
        });
        
        edit = new ToolItem(toolBar, SWT.NONE);
        edit.setToolTipText("Редактировать");
        edit.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/edit.png"));
        
        delete = new ToolItem(toolBar, SWT.NONE);
        delete.setToolTipText("Удалить");
        delete.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/delete.gif"));
        
        tableViewer = new TableViewer(top, SWT.MULTI | SWT.H_SCROLL
				| SWT.V_SCROLL | SWT.BORDER | SWT.FULL_SELECTION);
        createColumns(top, tableViewer);
        Table table = tableViewer.getTable();
        table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
		tableViewer.setContentProvider(new ItemListCP());
		tableViewer.setLabelProvider(new ItemListLP());
		getSite().setSelectionProvider(tableViewer);
		
		wgListSum = new WgListSum(top, SWT.NONE);
		wgListSum.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		tableViewer.setSorter(tableSorter);
		tableViewer.getTable().addListener(SWT.Selection, new Listener() {
			@Override
			public void handleEvent(Event event) {
				int selNum = ((IStructuredSelection)tableViewer.getSelection()).size();
				wgListSum.getSelected().setText(String.valueOf(selNum));
				AVwList.this.setupCheckButtons(selNum > 0);
				AVwList.this.setupOpenButtons(1 == selNum);
				if(null == event.item){
					tableViewer.getTable().redraw();
					return;
				}
				Rectangle r1 =  ((TableItem)event.item).getBounds();
				tableViewer.getTable().redraw(r1.x, r1.y, r1.width, r1.height, true);
			}
		});
		tableViewer.getTable().addListener(SWT.MeasureItem, paintListener);
		tableViewer.getTable().addListener(SWT.PaintItem, paintListener);
//		tableViewer.addSelectionChangedListener(new ISelectionChangedListener() {
//			Object element;
//			@Override
//			public void selectionChanged(SelectionChangedEvent event) {
//				if(null!=selected){
//					for(int iVwCount=0; iVwCount<selected.length;iVwCount++)
//						((Object[])(selected[iVwCount]))[titles.size()-1] = Boolean.FALSE;
//				}
//				selected = ((IStructuredSelection)tableViewer.getSelection()).toArray();
//				for(int iVwCount=0; iVwCount<selected.length;iVwCount++)
//					((Object[])(selected[iVwCount]))[titles.size()-1] = Boolean.TRUE;
//				tableViewer.getTable().redraw();
//			}
//		});
		setupWgAccessibility(0);
	}
	
	private void ElementOpen(Composite parent, BigDecimal id, boolean forUpdate){
		try {
			DlgItemStudent dlgItemStudent = new DlgItemStudent(parent.getShell(), 
					SWT.MODELESS | SWT.CLOSE | SWT.TITLE | SWT.RESIZE);
			
			dlgItemStudent.setItem(id, forUpdate);
			dlgItemStudent.open();
//			iVwCount++;
//			if(iVwCount > 9){
//				open.setEnabled(false);
//			}
//			IViewSite iVS = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().showView(
//					VwItemStudent.getId(), VwItemStudent.getId() + iVwCount, IWorkbenchPage.VIEW_CREATE).getViewSite();
//			IWorkbenchPart iWP = iVS.getPart();
//			WorkbenchPage wp = (WorkbenchPage) getSite().getPage();
//			IViewReference viewReference =	(IViewReference) getSite().getPage().getReference(iWP);
//			wp.getActivePerspective().getPresentation().detachPart(viewReference);
//			
//			AVwItem aVwItem = (AVwItem)iWP;
//			iVS.getShell().setBounds(new Rectangle(iniX + iVwCount*10, iniY + iVwCount*10, 
//					aVwItem.getMinWidth()+30, aVwItem.getMinHeight()+ 60));
//			aVwItem.setItem(id, forUpdate);
//			aVwItem.setReady();
//			
//			wp.activate(iWP);
		}        			
		catch (Throwable e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}
	
	private void checkAll(Boolean check){
		Table t = tableViewer.getTable();
		for(int i=0; i< t.getItemCount(); i++)
			((Object[])t.getItem(i).getData())[0] = check;
		iChecked = (check?t.getItemCount():0);
		wgListSum.getChecked().setText(String.valueOf(iChecked));
		delete.setEnabled((0 <  iChecked) && aItemList.getItemDef().canDelete()	);

		t.redraw();
	}
	private void invertAll(){
		Table t = tableViewer.getTable();
		for(int i=0; i< t.getItemCount(); i++)
			((Object[])t.getItem(i).getData())[0] = !(Boolean)((Object[])t.getItem(i).getData())[0];
		iChecked = t.getItemCount() - iChecked;
		wgListSum.getChecked().setText(String.valueOf(iChecked));
		delete.setEnabled((0 <  iChecked	) && aItemList.getItemDef().canDelete());
		t.redraw();
	}
	private void checkSelected(Boolean check){
		IStructuredSelection sel = (IStructuredSelection) tableViewer.getSelection();
		if(null != sel){
			Iterator<?> iter = sel.iterator();
			int i=0;
			while(iter.hasNext()){
				Object[] data = ((Object[])iter.next());
				i+= (check.equals(data[0])?0:1);
				data[0] = check;
			}
			iChecked += (check?i:-i);
		}else
			iChecked = 0;
		wgListSum.getChecked().setText(String.valueOf(iChecked));
		delete.setEnabled((0 <  iChecked	) && aItemList.getItemDef().canDelete());
		tableViewer.getTable().redraw();
	}

	
	
	Object[] selected;

//	private boolean controlPressed = false;
	List<Object> elementsToDeselect = new ArrayList<Object>();

//	private Listener controlKeyListener = new Listener() {
//		@Override
//		public void handleEvent(Event event) {
//			if(event.keyCode = SWT.)
//				controlPressed = (event.type == SWT.KeyDown);
//		}
//	};
	
	private Listener paintListener = new Listener() {
		public void handleEvent(Event event) {
			Object element = ((TableItem)event.item).getData();
			Object data = ((Object[])element)[event.index];
			if(data instanceof Boolean){
				boolean isCheckable = (0 == event.index);
				//IStructuredSelection sel = (IStructuredSelection)tableViewer.getSelection();
				//boolean selected = (Boolean)((Object[])element)[titles.size()-1];
					//(!sel.isEmpty() && sel.toList().contains(element));
				Image image =//(selected)
//					?((isCheckable) 
//							?	(((Boolean)data)?ItemListLP.CHECKED_SEL	:ItemListLP.UNCHECKED_SEL)
//							:	(((Boolean)data)?ItemListLP.TRUE_SEL		:ItemListLP.FALSE)			)
					/*:*/((isCheckable) 
							?	(((Boolean)data)?ItemListLP.CHECKED		:ItemListLP.UNCHECKED)
							:	(((Boolean)data)?ItemListLP.TRUE		:ItemListLP.FALSE)			);
				int dH = 2;
				Rectangle rect = image.getBounds();
				switch(event.type) {
					case SWT.MeasureItem: {
						event.height = rect.height + dH;
						break;
					}
					case SWT.PaintItem: {
						int dX = Math.max(0, (tableViewer.getTable().getColumn(event.index).getWidth() - rect.width)/2 - ((isCheckable)?3:0));
						int x = event.x + dX;
						event.gc.drawImage(image, x, event.y + dH/2);
						break;
					}
				}
			}
		}
	};		

	@Override
	public void setFocus() {
	}

	@Override
	public void setMyFocus() {
		this.top.setBackground(null);
		this.top.layout();
		//vwFilter.leaveFocus(false);
	}

	@Override
	public void leaveMyFocus(boolean nextIsFilter) {
		this.top.setBackground(nextIsFilter?VwFilter.getColorBorder():null);
		this.top.layout();
	}

	public abstract Control wgFilterControlGet();
	public abstract void	wgFilterControlClear();
	public abstract void	wgFilterControlRun() throws SQLException;

	protected ItemListMP itemList = new ItemListMP();

//	public static final class zzzDbSelectAttr extends IAttr{
//		private zzzDbSelectAttr(){}
//		private static final zzzDbSelectAttr m_Instance = new zzzDbSelectAttr();
//		public static zzzDbSelectAttr getInstance() {return m_Instance; }
//		public String           getName()				{ return "DbSelect";  }
//		public String           getDbColumnName()		{ return "1"; }  
//		public String           getCaption()			{ return "Выделен"; } 
//		public boolean			getDbLoadableInList()	{ return false;	}
//		public boolean          getDbReadOnly()			{ return true; }  
//		public boolean          getDbSaveOnly()			{ return true; }		        }
//	private final DbField<Boolean, zzzDbSelectAttr> dbFSelect = 
//		new DbField<Boolean, AVwList.zzzDbSelectAttr>(false, zzzDbSelectAttr.getInstance());
	
	public static final class zzzDbCheckAttr extends IAttr{
		private zzzDbCheckAttr(){}
		private static final zzzDbCheckAttr m_Instance = new zzzDbCheckAttr();
		public static zzzDbCheckAttr getInstance() {return m_Instance; }
		public String           getName()				{ return "DbCheck";  }
		public String           getDbColumnName()		{ return "0"; }  
		public String           getCaption()			{ return "Выбран"; } 
		public boolean			getDbLoadableInList()	{ return false;	}
		public boolean          getDbReadOnly()			{ return true; }  
		public boolean          getDbSaveOnly()			{ return true; }		        }
	private final DbField<Boolean, zzzDbCheckAttr> dbFCheck = 
		new DbField<Boolean, AVwList.zzzDbCheckAttr>(false, zzzDbCheckAttr.getInstance());
	public class ItemListMP {
		
		private List<Object[]> rowList = new ArrayList<Object[]>();
		private List<BigDecimal> checkedId = new ArrayList<BigDecimal>();
		
		protected ItemListMP(){
		}

		public ItemListMP run() throws SQLException{
			checkedId.clear();
			for(int iOld = 0; iOld < rowList.size(); iOld ++)
				if((Boolean)rowList.get(iOld)[0])
					checkedId.add((BigDecimal) rowList.get(iOld)[iTID]);
			iChecked = checkedId.size();
			wgListSum.getChecked().setText(String.valueOf(iChecked));
			rowList = new ArrayList<Object[]>();
			List<IVal> listColumns = new ArrayList<IVal>();
			Table table = tableViewer.getTable();
			for (int i = 0; i < titles.size(); i++) 
				if(table.getColumn(i).getResizable() ||	iTID == i)
					listColumns.add(titles.get(i));
			listColumns.remove(dbFCheck);
//			listColumns.remove(dbFSelect);
			ResultSet rs = aItemList.loadList(listColumns, aItemList.getId());
			listColumns.add(0, dbFCheck);
//			listColumns.add(dbFSelect);
			int iChk=0;
			List<BigDecimal> chkIdSkipped = new ArrayList<BigDecimal>();
			BigDecimal chkId = null;
			while(rs.next()){
				Object[] o = new Object[titles.size()];
				this.ini(rs, o, listColumns);
				for(;iChk < checkedId.size();iChk++){
					chkId = checkedId.get(iChk); 
					if(chkId.compareTo((BigDecimal) o[iTID]) >= 0) break;
					else chkIdSkipped.add(chkId);
				}
				if(iChk < checkedId.size() && 0 == chkId.compareTo((BigDecimal) o[iTID])){
					o[0] = Boolean.TRUE;
					iChk++;
				}
				else
					o[0] = Boolean.FALSE;
				rowList.add(o);			
			}
			checkedId.clear();
			//load all chkIdSkipped
			while (chkIdSkipped.size() > 0){
				List<BigDecimal> buf = new ArrayList<BigDecimal>();
				for(int iBuf=0;iBuf<iRecNMax && chkIdSkipped.size() > 0; iBuf++){
					buf.add(chkIdSkipped.get(0));
					chkIdSkipped.remove(0);
				}
				listColumns.remove(dbFCheck);
				rs = aItemList.loadList(listColumns, aItemList.getId(), buf);
				listColumns.add(0, dbFCheck);
				while(rs.next()){
					Object[] o = new Object[titles.size()];
					o[0] = Boolean.TRUE;
					this.ini(rs, o, listColumns);
					rowList.add(o);			
				}
			}
			tableViewer.setSelection(null);
			wgListSum.getSelected().setText("0");
			wgListSum.getTot().setText(String.valueOf(rowList.size()));
			setupWgAccessibility(rowList.size());
			return this;
		}
		private void ini(ResultSet rs, Object[] o, List<IVal> listColumns) throws SQLException{
			int iCount=1;
			int iMax = o.length/* - 1*/;
			int col = iCount;
			for(; col < iMax && iCount < listColumns.size(); col++){
				IAttr ia = listColumns.get(iCount).getAttr();
				if(titles.get(col).getAttr().getDbColumnName().equals(
						ia.getDbColumnName()))
					o[col] = ia.translateVal(ia.isBoolean()	? rs.getBoolean	(iCount++)
															: rs.getObject	(iCount++));
				else
					o[col] = "";
			}
			for(;col < iMax;col++) o[col] = "";
//			o[col] = Boolean.FALSE;
		}
		
		public List<Object[]> getRowList() {
			return rowList;
		}

	}
	private final int iRecNMax = 100;
	private ToolItem create;
	private ToolItem edit;
	private ToolItem delete;
	private ToolItem uncheck;
	private ToolItem check;
	private ToolItem uncheckAll;
	private ToolItem checkAll;
	private ToolItem checkInvert;
	private WgListSum wgListSum;
	private int iChecked = 0;
	private ToolItem open;
	public class ItemListCP implements IStructuredContentProvider {

		@Override
		public Object[] getElements(Object inputElement) {
			@SuppressWarnings("unchecked")
			List<Object[]> rowList = (List<Object[]>) inputElement;
			return rowList.toArray();
		}

		@Override
		public void dispose() {
		}

		@Override
		public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
		}
	}
	public static class ItemListLP extends LabelProvider implements	ITableLabelProvider {
		// We use icons
		private static final Image CHECKED = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/checked1.png").createImage();
		private static final Image UNCHECKED = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/unchecked1.png").createImage();

//		private static final Image CHECKED_SEL = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/checked_selected.png").createImage();
//		private static final Image UNCHECKED_SEL = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/unchecked_selected.png").createImage();

		private static final Image TRUE = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/true1.png").createImage();
		private static final Image FALSE = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/false.png").createImage();

//		private static final Image TRUE_SEL = ResourceManager.getPluginImageDescriptor("me.stec.admin", "icons/app/true_selected.png").createImage();
		
		@Override
		public Image getColumnImage(Object element, int columnIndex) {
//			// In case you don't like image just return null here
//			Object obj = ((Object[]) element)[columnIndex];
//			if (obj instanceof Boolean) {
//				if (((Boolean) obj)) {
//					return CHECKED;
//				} else {
//					return UNCHECKED;
//				}
//			}
			return null;
		}

		
		@Override
		public String getColumnText(Object element, int columnIndex) {
			Object obj = ((Object[]) element)[columnIndex];
			if (obj instanceof Boolean) 
				return null;
			return String.valueOf(obj);
		}
		
	}
	
	public class ItemListVS extends ViewerSorter {
		private int propertyIndex = 0;
		private static final int ASCENDING = 0;
		//private static final int DESCENDING = 1;
		//private static final int ASCENDING = 0;

		private int direction = ASCENDING;

		public ItemListVS() {
		}

		public int getDirection(){
			return direction== 1 ? SWT.DOWN : SWT.UP;
		}
		public void setColumn(int column) {
			List<?> sel = ((IStructuredSelection)tableViewer.getSelection()).toList();
			for(int iSel = 0; iSel < sel.size(); iSel++)
				((Object[])sel.get(iSel))[titles.size()-1] = Boolean.FALSE;
			tableViewer.setSelection(null);
			
			if (column == this.propertyIndex) {
				// Same column as last sort; toggle the direction
				direction = 1 - direction;
			} else {
				// New column; do an ascending sort
				this.propertyIndex = column;
				direction = ASCENDING;
			}
		}
//		public void setDirection(int direction) {
//			this.direction = ((direction == SWT.UP) ? 0 : 1);
//		}
		@Override
		public int compare(Viewer viewer, Object e1, Object e2) {
			//Person p1 = (Person) e1;
			//Person p2 = (Person) e2;
			Object p1 = ((Object[]) e1)[propertyIndex];
			Object p2 = ((Object[]) e2)[propertyIndex];
			int rc = 0;
			if(p1 instanceof String)
				rc = String.valueOf(p2).compareTo(String.valueOf(p1));
			else if(p1 instanceof BigDecimal)
				rc = (((BigDecimal)p2).compareTo((BigDecimal)p1));
			else if(p1 instanceof Boolean){
				if((Boolean)p1 && !(Boolean)p2) rc = 1;
				else if (!(Boolean)p1 && (Boolean)p2) rc = -1;
			}
			else if (p1 instanceof Integer)
				rc = ((Integer)p1 < (Integer)p2)?1:(p1.equals(p2)?0:-1);
			else if (p1 instanceof Float)
				rc = ((Float)p1 < (Float)p2)?1:(p1.equals(p2)?0:-1);
				
			// If descending order, flip the direction
			if (direction == ASCENDING) 
				rc = -rc;

			return rc;
		}
	}
	
	public class ItemListES extends EditingSupport {
		private CellEditor editor;
		private int column = 0;

		public ItemListES(ColumnViewer viewer, int column) {
			super(viewer);
			// Create the correct editor based on the column index
			this.column = column;
			if(0 == column){
				editor = new CheckboxCellEditor(null, SWT.CENTER | SWT.CHECK | SWT.READ_ONLY);
			}
		}

		@Override
		protected boolean canEdit(Object element) {
			return true;//0 == column;
		}

		@Override
		protected CellEditor getCellEditor(Object element) {
			return editor;
		}

		@Override
		protected Object getValue(Object element) {
			if(0 != column) return null;
			return ((Object[])element)[column];
		}

		@Override
		protected void setValue(Object element, Object value) {
			if(0 != column) 
				return;
			iChecked = iChecked + ((Boolean)value?1:-1);
			wgListSum.getChecked().setText(String.valueOf(iChecked));
			delete.setEnabled((0 <  iChecked	) && aItemList.getItemDef().canDelete());
			((Object[])element)[column] = value;
			getViewer().update(element, null);
		}

	}
	
}

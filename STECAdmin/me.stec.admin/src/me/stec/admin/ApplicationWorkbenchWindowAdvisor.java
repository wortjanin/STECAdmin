package me.stec.admin;

import java.sql.SQLException;

import me.stec.admin.db.Conn;
import me.stec.admin.db.Privs;
import me.stec.admin.view.AVw;
import me.stec.admin.view.VwFilter;
import me.stec.admin.view.VwItemStudent;

import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.ui.IPartListener;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.application.ActionBarAdvisor;
import org.eclipse.ui.application.IActionBarConfigurer;
import org.eclipse.ui.application.IWorkbenchWindowConfigurer;
import org.eclipse.ui.application.WorkbenchWindowAdvisor;

public class ApplicationWorkbenchWindowAdvisor extends WorkbenchWindowAdvisor {

	public ApplicationWorkbenchWindowAdvisor(IWorkbenchWindowConfigurer configurer) {
		super(configurer);
	}

	public ActionBarAdvisor createActionBarAdvisor(
			IActionBarConfigurer configurer) {
		return new ApplicationActionBarAdvisor(configurer);
	}

	public void preWindowOpen() {
		IWorkbenchWindowConfigurer configurer = getWindowConfigurer();
		//configurer.setInitialSize(new Point(400, 300));
		//configurer.setShowCoolBar(false);
		//configurer.setShowStatusLine(false);
		configurer.setTitle("СТЭК Администратор");
        //IWorkbenchWindowConfigurer configurer = getWindowConfigurer();
        //configurer.setInitialSize(new Point(600, 400));
        Rectangle r = PlatformUI.getWorkbench().getDisplay().getBounds();
        configurer.setInitialSize(new Point(r.width, r.height));
        configurer.setShowCoolBar(false);
        configurer.setShowStatusLine(true);

        configurer.setShowMenuBar(true);

        Conn.setConnString("jdbc:oracle:thin:@localhost:1521:dbx");
        try { Privs.Load();	} catch (SQLException e) {e.printStackTrace();	}

//        Display display = PlatformUI.getWorkbench().getDisplay();
////	    final Shell shell = new Shell(display);
//	    final ShConn shell = new ShConn(display);
//        DlgConn dlgConn = new DlgConn(shell, SWT.APPLICATION_MODAL 
//        		/*| SWT.TITLE | SWT.RESIZE*/);
//        
//		dlgConn.open();

	}
	
    @Override
    public void postWindowOpen() {
    	super.postWindowOpen();
        PlatformUI.getWorkbench().getActiveWorkbenchWindow()
        	.getActivePage().addPartListener(new IPartListener() {
				public void partActivated(IWorkbenchPart part) {
					if(part instanceof AVw)
						((AVw)part).setMyFocus();
				}
				public void partBroughtToTop(IWorkbenchPart part) {	}
				public void partClosed(IWorkbenchPart part) {}
				public void partDeactivated(IWorkbenchPart part) {}
				public void partOpened(IWorkbenchPart part) {}			});
        
        PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().activate(
        		PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(VwFilter.getId()).getViewSite().getPart());
    }

    @Override
    public void postWindowClose() {
    	try{ Conn.get().close(); }catch(Throwable e){}
    }

}

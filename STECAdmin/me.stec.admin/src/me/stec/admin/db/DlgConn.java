package me.stec.admin.db;

import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import com.swtdesigner.ResourceManager;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.layout.FormLayout;
import org.eclipse.swt.layout.FormData;
import org.eclipse.swt.layout.FormAttachment;
import com.swtdesigner.SWTResourceManager;
import org.eclipse.swt.widgets.Button;

public class DlgConn extends Dialog {

	protected Object result;
	protected Shell shell;
	private Text txtLogin;
	private Text txtPassword;
	private Button btnCancel;

	/**
	 * Create the dialog.
	 * @param parent
	 * @param style
	 */
	public DlgConn(Shell parent, int style) {
		super(parent, SWT.CLOSE | SWT.SYSTEM_MODAL);
	}

	/**
	 * Open the dialog.
	 * @return the result
	 */
	public Object open() {
		createContents();
		shell.open();
		shell.layout();
		Display display = getParent().getDisplay();
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
		return result;
	}

	/**
	 * Create contents of the dialog.
	 */
	private void createContents() {
		shell = new Shell(getParent(), SWT.SYSTEM_MODAL);
		shell.setBackground(SWTResourceManager.getColor(255, 255, 255));
//		shell.set;
		shell.setSize(562, 372);
	    Rectangle rDis = shell.getDisplay().getBounds();
	    int w = rDis.width, h = rDis.height;
	    shell.setLocation(
	    		Math.max(400, w/2 - shell.getSize().x/2), 
	    		Math.max(300, h/2 - shell.getSize().y/2));
	    FormLayout fl_shell = new FormLayout();
	    shell.setLayout(fl_shell);
	    
	    txtLogin = new Text(shell, SWT.NONE);
	    txtLogin.setTextLimit(30);
	    txtLogin.setEditable(true);
	    txtLogin.setEnabled(true);
	    txtLogin.setText("");
	    txtLogin.setToolTipText("Логин");
	    txtLogin.setFont(SWTResourceManager.getFont("Tahoma", 11, SWT.BOLD));
	    txtLogin.setForeground(SWTResourceManager.getColor(51, 51, 51));
	    txtLogin.setBackground(SWTResourceManager.getColor(245, 222, 179));
	    FormData fd_txtLogin = new FormData();
	    fd_txtLogin.top = new FormAttachment(0, 230);
	    fd_txtLogin.left = new FormAttachment(0, 228);
	    fd_txtLogin.height = 20;
	    fd_txtLogin.width = 180;
	    txtLogin.setLayoutData(fd_txtLogin);
	    
	    txtPassword = new Text(shell, SWT.NONE);
	    txtPassword.setToolTipText("Пароль");
	    txtPassword.setTextLimit(30);
	    txtPassword.setText("");
	    txtPassword.setForeground(SWTResourceManager.getColor(51, 51, 51));
	    txtPassword.setFont(SWTResourceManager.getFont("Tahoma", 11, SWT.BOLD));
	    txtPassword.setEnabled(true);
	    txtPassword.setEditable(true);
	    txtPassword.setBackground(SWTResourceManager.getColor(245, 222, 179));
	    txtPassword.setEchoChar('*');
	    FormData fd_txtPassword = new FormData();
	    fd_txtPassword.top = new FormAttachment(0, 260);
	    fd_txtPassword.left = new FormAttachment(0, 228);
	    fd_txtPassword.height = 20;
	    fd_txtPassword.width = 180;
	    txtPassword.setLayoutData(fd_txtPassword);
	    
	    Button btnConnect = new Button(shell, SWT.FLAT);
	    btnConnect.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/connect.PNG"));
	    btnConnect.setForeground(SWTResourceManager.getColor(51, 51, 51));
	    FormData fd_btnConnect = new FormData();
	    fd_btnConnect.top = new FormAttachment(0, 290);
	    fd_btnConnect.left = new FormAttachment(0, 228);
	    fd_btnConnect.width = 80;
	    fd_btnConnect.height = 20;
	    btnConnect.setLayoutData(fd_btnConnect);
	    
	    btnCancel = new Button(shell, SWT.FLAT);
	    btnCancel.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/cancel.PNG"));
	    btnCancel.setForeground(SWTResourceManager.getColor(51, 51, 51));
	    FormData fd_btnCancel = new FormData();
	    fd_btnCancel.left = new FormAttachment(0, 328);
	    fd_btnCancel.top = new FormAttachment(0, 290);
	    fd_btnCancel.height = 20;
	    fd_btnCancel.width = 80;
	    btnCancel.setLayoutData(fd_btnCancel);
	    
	    Label label = new Label(shell, SWT.RIGHT);
	    label.setFont(SWTResourceManager.getFont("Tahoma", 8, SWT.NORMAL));
	    label.setLayoutData(new FormData());
	    label.setBackground(SWTResourceManager.getColor(SWT.COLOR_YELLOW));
	    label.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/splash.png"));
//	    FormData fd_label = new FormData();
//	    fd_label.top = new FormAttachment(0);
//	    fd_label.left = new FormAttachment(0);
//	    label.setLayoutData(fd_label);

//		shell.setText(getText());

	}
}

package me.stec.admin.db;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Button;
import com.swtdesigner.SWTResourceManager;
import com.swtdesigner.ResourceManager;
import org.eclipse.swt.widgets.Label;

public class WgConn extends Composite {
	private Text txtLogin;
	private Text txtPassword;
//	Color color = SWTResourceManager.getColor(255, 252, 242);
//	Color colorTxt = SWTResourceManager.getColor(254, 187, 114);
	Color colorTxt = SWTResourceManager.getColor(255, 255, 255);
	Color color = SWTResourceManager.getColor(209, 148, 89);
	private Button btnConnect;
	private Button btnCancel;

	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public WgConn(Composite parent, int style) {
		super(parent, style);
		setBackground(color);
		setLayout(new GridLayout(2, false));
		
		txtLogin = new Text(this, SWT.NONE);
		txtLogin.setBackground(colorTxt);
		txtLogin.setToolTipText("Логин");
		txtLogin.setForeground(SWTResourceManager.getColor(51, 51, 51));
		txtLogin.setFont(SWTResourceManager.getFont("Tahoma", 11, SWT.BOLD));
		GridData gd_txtLogin = new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1);
		gd_txtLogin.heightHint = 18;
		gd_txtLogin.widthHint = 100;
		txtLogin.setLayoutData(gd_txtLogin);
		
		txtPassword = new Text(this, SWT.NONE);
		txtPassword.setBackground(colorTxt);
		txtPassword.setToolTipText("Пароль");
		txtPassword.setForeground(SWTResourceManager.getColor(51, 51, 51));
		txtPassword.setFont(SWTResourceManager.getFont("Tahoma", 11, SWT.BOLD));
		GridData gd_txtPassword = new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1);
		gd_txtPassword.heightHint = 18;
		gd_txtPassword.widthHint = 100;
		txtPassword.setLayoutData(gd_txtPassword);
		txtPassword.setEchoChar('*');
		
		btnConnect = new Button(this, SWT.NONE);
		btnConnect.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/connect.PNG"));
		GridData gd_btnConnect = new GridData(SWT.LEFT, SWT.CENTER, true, true, 1, 1);
		gd_btnConnect.heightHint = 20;
		gd_btnConnect.widthHint = 80;
		btnConnect.setLayoutData(gd_btnConnect);
		
		btnCancel = new Button(this, SWT.NONE);
		btnCancel.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/cancel.PNG"));
		GridData gd_btnCancel = new GridData(SWT.RIGHT, SWT.CENTER, true, false, 1, 1);
		gd_btnCancel.widthHint = 80;
		gd_btnCancel.heightHint = 20;
		btnCancel.setLayoutData(gd_btnCancel);
	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

	public Text getTxtLogin() {
		return txtLogin;
	}
	public Text getTxtPassword() {
		return txtPassword;
	}
	public Button getBtnConnect() {
		return btnConnect;
	}
	public Button getBtnCancel() {
		return btnCancel;
	}
}

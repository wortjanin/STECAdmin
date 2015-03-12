
package me.stec.admin.splashHandlers;

import me.stec.admin.db.Conn;
import me.stec.admin.db.WgConn;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FormAttachment;
import org.eclipse.swt.layout.FormData;
import org.eclipse.swt.layout.FormLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Link;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.splash.AbstractSplashHandler;

import com.swtdesigner.SWTResourceManager;

/**
 * @since 3.3
 * 
 */
public class InteractiveSplashHandler extends AbstractSplashHandler {
	
	private final static int F_LABEL_HORIZONTAL_INDENT = 175;

	private final static int F_BUTTON_WIDTH_HINT = 80;

	private final static int F_TEXT_WIDTH_HINT = 175;
	
	private final static int F_COLUMN_COUNT = 2;
	
	private WgConn fCompositeLogin;
	
	private Text fTextUsername;
	
	private Text fTextPassword;
	
	private Button fButtonOK;
	
	private Button fButtonCancel;
	
	private boolean fAuthenticated;
	
	private Link link;
	
	private Text errorString;
	/**
	 * 
	 */
	public InteractiveSplashHandler() {
		fCompositeLogin = null;
		fTextUsername = null;
		fTextPassword = null;
		fButtonOK = null;
		fButtonCancel = null;
		fAuthenticated = false;
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see org.eclipse.ui.splash.AbstractSplashHandler#init(org.eclipse.swt.widgets.Shell)
	 */
	public void init(final Shell splash) {
		// Store the shell
		super.init(splash);
		System.setProperty("file.encoding", "UTF-8");
		// Configure the shell layout
		configureUISplash();
		// Create UI
		createUI();		
		// Create UI listeners
		createUIListeners();
		// Force the splash screen to layout
		splash.layout(true);
		// Keep the splash screen visible and prevent the RCP application from 
		// loading until the close button is clicked.
		doEventLoop();
	}
	
	/**
	 * 
	 */
	private void doEventLoop() {
		Shell splash = getSplash();
//	    while (!splash.isDisposed()) 
//	      if (!splash.getDisplay().readAndDispatch()) 
//	    	  splash.getDisplay().sleep();

		while (fAuthenticated == false) {
			if (splash.getDisplay().readAndDispatch() == false) {
				splash.getDisplay().sleep();
			}
		}
	}

	private boolean bOk = false;
	/**
	 * 
	 */
	private void createUIListeners() {
	    final Text textUsr = fCompositeLogin.getTxtLogin();
	    final Button btnOk = fCompositeLogin.getBtnConnect();
	    final Text textPwd = fCompositeLogin.getTxtPassword();
//	    final Text labelErr = new Text(getSplash(), SWT.FILL);// = wgConn.getLblError();
	    final Button btnCancel = fCompositeLogin.getBtnCancel();
	    textUsr.setText("dev");
	    btnOk.addSelectionListener(	new SelectionAdapter() {
	      public void widgetSelected(SelectionEvent e) {
	    	  	if(bOk) return;
				if(Conn.InnConn.Open("jdbc:oracle:thin:@localhost:1521:dbx",
						//connString,
						/*usr = */textUsr.getText(), textPwd.getText())){
					  	//bOk = true;
					  	//getSplash().close();
						bOk = true;
						fAuthenticated = true;
						btnOk.setEnabled(false);
						btnCancel.setEnabled(false);
					  	Conn.InnConn.setErrString("");
					}
				else{
					errorString.setText(Translate(Conn.InnConn.getErrString()));
					errorString.setToolTipText("В случае неустранимых проблем, обратитесь к Администратору Системы");
					errorString.setVisible(true);
					errorString.redraw();
				}
	      }
	    });

	    btnCancel.addSelectionListener(	new SelectionAdapter() {
		      public void widgetSelected(SelectionEvent e) {
		    	  handleButtonCancelWidgetSelected();
		      }
		});
		
//		// Create the OK button listeners
//		createUIListenersButtonOK();
//		// Create the cancel button listeners
//		createUIListenersButtonCancel();
	}

	private String Translate(String s){
		if(s.contains("ORA-01017"))
			return "Неправильный логин/пароль";
		else if(s.contains("The Network Adapter could not establish the connection"))
			return "Ошибка сетевого подключения";
		else if(s.contains("ORA-28000"))
			return "Аккаунт заблокирован";
		else if(s.contains("ORA-01005: null password given"))
			return "Необходимо ввести пароль";
		return s;
	}

	/**
	 * 
	 */
//	private void createUIListenersButtonCancel() {
//		fButtonCancel.addSelectionListener(new SelectionAdapter() {
//			public void widgetSelected(SelectionEvent e) {
//				handleButtonCancelWidgetSelected();
//			}
//		});		
//	}

	/**
	 * 
	 */
	private void handleButtonCancelWidgetSelected() {
		// Abort the loading of the RCP application
		getSplash().getDisplay().close();
		System.exit(0);		
	}
	
	/**
	 * 
	 */
//	private void createUIListenersButtonOK() {
//		fButtonOK.addSelectionListener(new SelectionAdapter() {
//			public void widgetSelected(SelectionEvent e) {
//				handleButtonOKWidgetSelected();
//			}
//		});				
//	}

//	/**
//	 * 
//	 */
//	private void handleButtonOKWidgetSelected() {
//		String username = fTextUsername.getText();
//		String password = fTextPassword.getText();
//		// Aunthentication is successful if a user provides any username and
//		// any password
//		if ((username.length() > 0) &&
//				(password.length() > 0)) {
//			fAuthenticated = true;
//		} else {
//			MessageDialog.openError(
//					getSplash(),
//					"Authentication Failed",  //$NON-NLS-1$
//					"A username and password must be specified to login.");  //$NON-NLS-1$
//		}
//	}
	
	/**
	 * 
	 */
	private void createUI() {
		// Create the login panel
		createUICompositeLogin();
		// Create the blank spanner
//		createUICompositeBlank();
//		// Create the user name label
//		createUILabelUserName();
//		// Create the user name text widget
//		createUITextUserName();
//		// Create the password label
//		createUILabelPassword();
//		// Create the password text widget
//		createUITextPassword();
//		// Create the blank label
//		createUILabelBlank();
//		// Create the OK button
//		createUIButtonOK();
//		// Create the cancel button
//		createUIButtonCancel();
	}		
	
	/**
	 * 
	 */
//	private void createUIButtonCancel() {
//		// Create the button
//		fButtonCancel = new Button(fCompositeLogin, SWT.PUSH);
//		fButtonCancel.setText("Cancel"); //$NON-NLS-1$
//		// Configure layout data
//		GridData data = new GridData(SWT.NONE, SWT.NONE, false, false);
//		data.widthHint = F_BUTTON_WIDTH_HINT;	
//		data.verticalIndent = 10;
//		fButtonCancel.setLayoutData(data);
//	}

	/**
	 * 
	 */
//	private void createUIButtonOK() {
//		// Create the button
//		fButtonOK = new Button(fCompositeLogin, SWT.PUSH);
//		fButtonOK.setText("OK"); //$NON-NLS-1$
//		// Configure layout data
//		GridData data = new GridData(SWT.NONE, SWT.NONE, false, false);
//		data.widthHint = F_BUTTON_WIDTH_HINT;
//		data.verticalIndent = 10;
//		fButtonOK.setLayoutData(data);
//	}

//	/**
//	 * 
//	 */
//	private void createUILabelBlank() {
//		Label label = new Label(fCompositeLogin, SWT.NONE);
//		label.setVisible(false);
//	}
//
//	/**
//	 * 
//	 */
//	private void createUITextPassword() {
//		// Create the text widget
//		int style = SWT.PASSWORD | SWT.BORDER;
//		fTextPassword = new Text(fCompositeLogin, style);
//		// Configure layout data
//		GridData data = new GridData(SWT.NONE, SWT.NONE, false, false);
//		data.widthHint = F_TEXT_WIDTH_HINT;
//		data.horizontalSpan = 2;
//		fTextPassword.setLayoutData(data);		
//	}
//
//	/**
//	 * 
//	 */
//	private void createUILabelPassword() {
//		// Create the label
//		Label label = new Label(fCompositeLogin, SWT.NONE);
//		label.setText("Версия "); 
//		// Configure layout data
//		GridData data = new GridData();
//		data.horizontalIndent = F_LABEL_HORIZONTAL_INDENT;
//		label.setLayoutData(data);					
//	}
//
//	/**
//	 * 
//	 */
//	private void createUITextUserName() {
//		// Create the text widget
//		fTextUsername = new Text(fCompositeLogin, SWT.BORDER);
//		// Configure layout data
//		GridData data = new GridData(SWT.NONE, SWT.NONE, false, false);
//		data.widthHint = F_TEXT_WIDTH_HINT;
//		data.horizontalSpan = 2;
//		fTextUsername.setLayoutData(data);		
//	}
//
//	/**
//	 * 
//	 */
//	private void createUILabelUserName() {
//		// Create the label
//		Label label = new Label(fCompositeLogin, SWT.NONE);
//		label.setText("&User Name:"); //$NON-NLS-1$
//		// Configure layout data
//		GridData data = new GridData();
//		data.horizontalIndent = F_LABEL_HORIZONTAL_INDENT;
//		label.setLayoutData(data);		
//	}
//
//	/**
//	 * 
//	 */
//	private void createUICompositeBlank() {
//		Composite spanner = new Composite(fCompositeLogin, SWT.NONE);
//		GridData data = new GridData(SWT.FILL, SWT.FILL, true, true);
//		data.horizontalSpan = F_COLUMN_COUNT;
//		spanner.setLayoutData(data);
//	}

	/**
	 * 
	 */
	private void createUICompositeLogin() {
		//version
		Label version = new Label(getSplash(), SWT.NONE);
		version.setText("Версия 1.2.0.3");
		version.setForeground(SWTResourceManager.getColor(230, 162, 0));
		version.setFont(SWTResourceManager.getFont("Tahoma", 10, SWT.BOLD));

		FormData fd_composite = new FormData();
		fd_composite.top = new FormAttachment(0, 218);
		fd_composite.left = new FormAttachment(0, 228);
		version.setLayoutData(fd_composite);
		
		//login frame
		fCompositeLogin = new WgConn(getSplash(), SWT.NONE);
		fd_composite = new FormData();
		fd_composite.top = new FormAttachment(0, 242);
		fd_composite.left = new FormAttachment(0, 228);
		fd_composite.width = 170;
		fCompositeLogin.setLayoutData(fd_composite);

		//settings
		link = new Link(getSplash(), SWT.NONE);
		link.setText("<a> Настройки </a>");
		link.setFont(SWTResourceManager.getFont("Tahoma", 8, SWT.NONE));
		fd_composite = new FormData();
		fd_composite.top = new FormAttachment(0, 326);
		fd_composite.left = new FormAttachment(0, 326);
		link.setLayoutData(fd_composite);
		
		//error string
		errorString = new Text(getSplash(),   SWT.NO_BACKGROUND | SWT.READ_ONLY);
		errorString.setText("");//"Ошибка");
		errorString.setForeground(SWTResourceManager.getColor(156, 26, 0));
		errorString.setFont(SWTResourceManager.getFont("Tahoma", 8, SWT.NONE));
		fd_composite = new FormData();
		fd_composite.top = new FormAttachment(0, 346);
		fd_composite.left = new FormAttachment(0, 228);
		fd_composite.width = 200;
		errorString.setLayoutData(fd_composite);
		errorString.setVisible(false);

	}

	/**
	 * 
	 */
	private void configureUISplash() {
		// Configure layout
		FormLayout layout = new FormLayout(); 
		getSplash().setLayout(layout);
//		new Label(getSplash(), SWT.NONE);
		// Force shell to inherit the splash background
		getSplash().setBackgroundMode(SWT.INHERIT_DEFAULT);
	}
	
}

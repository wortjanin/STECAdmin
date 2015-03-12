package me.stec.admin.db;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

public class ShConn extends Shell {

	/**
	 * Launch the application.
	 * @param args
	 */
	public static void main(String args[]) {
		try {
			Display display = Display.getDefault();
			ShConn shell = new ShConn(display);
			shell.open();
			shell.layout();
			while (!shell.isDisposed()) {
				if (!display.readAndDispatch()) {
					display.sleep();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Create the shell.
	 * @param display
	 */
	public ShConn(Display display) {
		super(display, SWT.SYSTEM_MODAL);
		getBorderWidth();
		createContents();
	}

	public int getBorderWidth () {
		return 0;
	}
	
	/**
	 * Create contents of the shell.
	 */
	protected void createContents() {
//		setText("SWT Application");
//		setSize(450, 300);

	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

}

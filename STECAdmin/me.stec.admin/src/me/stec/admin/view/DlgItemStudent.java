package me.stec.admin.view;

import java.math.BigDecimal;
import java.sql.SQLException;

import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import me.stec.admin.widget.item.WgItemStudent;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.GridData;
import com.swtdesigner.ResourceManager;

public class DlgItemStudent extends Dialog {

	protected Object result;
	protected Shell shell = new Shell(getParent(), getStyle());;

	/**
	 * Create the dialog.
	 * @param parent
	 * @param style
	 */
	public DlgItemStudent(Shell parent, int style) {
		super(parent, style);
		setText("Студент");
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

	WgItemStudent wgItemStudent = new WgItemStudent(shell, SWT.NONE);;

	/**
	 * Create contents of the dialog.
	 */
	private void createContents() {
		//shell = new Shell(getParent(), getStyle());
		shell.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/VwItemStudent.png"));
		shell.setSize(629, 523);
		shell.setText(getText());
		shell.setLayout(new GridLayout(1, false));
		
		//wgItemStudent = new WgItemStudent(shell, SWT.NONE);
		wgItemStudent.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));

		shell.setSize(new Point(wgItemStudent.getMinWidth()+30, wgItemStudent.getMinHeight()+ 60));
	}
	
	public void setItem(BigDecimal bdID, boolean forUpdate) throws SQLException{
		wgItemStudent.setAItem(bdID, forUpdate);
	}

}

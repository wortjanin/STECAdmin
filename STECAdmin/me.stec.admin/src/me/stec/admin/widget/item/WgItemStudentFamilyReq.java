package me.stec.admin.widget.item;

import me.stec.admin.widget.WgDcrText;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Button;
import com.swtdesigner.ResourceManager;

public class WgItemStudentFamilyReq extends Composite {

	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public WgItemStudentFamilyReq(Composite parent, int style) {
		super(parent, style);
		GridLayout gridLayout = new GridLayout(4, false);
		gridLayout.marginWidth = 0;
		gridLayout.marginHeight = 0;
		setLayout(gridLayout);
		
		Label label = new Label(this, SWT.NONE);
		label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label.setText("Запрос на новую фамилию");
		
		WgDcrText wgXText = new WgDcrText(this, SWT.BORDER | SWT.READ_ONLY);
		wgXText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Button bDecline = new Button(this, SWT.NONE);
		bDecline.setToolTipText("Отклонить");
		bDecline.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/no.png"));
		
		Button bApprove = new Button(this, SWT.NONE);
		bApprove.setToolTipText("Утвердить");
		bApprove.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/yes.png"));

	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

}

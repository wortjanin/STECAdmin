package me.stec.admin.widget;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.SWT;
import org.eclipse.nebula.widgets.datechooser.DateChooserCombo;
import org.eclipse.swt.layout.GridData;

public class WgIntervalDate extends Composite {

	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public WgIntervalDate(Composite parent, int style) {
		super(parent, style);
		GridLayout gridLayout = new GridLayout(4, false);
		gridLayout.marginWidth = 0;
		gridLayout.marginHeight = 0;
		setLayout(gridLayout);
		
		Label label = new Label(this, SWT.NONE);
		label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label.setText("  с  ");
		
		DateChooserCombo dateChooserCombo = new DateChooserCombo(this, SWT.BORDER);
		dateChooserCombo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, true, 1, 1));
		
		Label label_1 = new Label(this, SWT.NONE);
		label_1.setText("по");
		
		DateChooserCombo dateChooserCombo_1 = new DateChooserCombo(this, SWT.BORDER);
		dateChooserCombo_1.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, true, 1, 1));

	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

}

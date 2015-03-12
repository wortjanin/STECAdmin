package me.stec.admin.widget.list;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.layout.GridData;

public class WgListSum extends Composite {
	private Text checked;
	private Text selected;
	private Text tot;
	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public WgListSum(Composite parent, int style) {
		super(parent, style);
		setLayout(new GridLayout(6, false));
		
		Label label = new Label(this, SWT.NONE);
		label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label.setText("Загружено:");
		
		tot = new Text(this, SWT.READ_ONLY);
		tot.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		tot.setText("0");
		
		Label label_1 = new Label(this, SWT.NONE);
		label_1.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_1.setText("Выбрано:");
		
		checked = new Text(this, SWT.READ_ONLY);
		checked.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		checked.setText("0");
		checked.setEditable(false);
		
		Label label_2 = new Label(this, SWT.NONE);
		label_2.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_2.setText("Выделено:");
		
		selected = new Text(this, SWT.READ_ONLY);
		selected.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		selected.setText("0");
		selected.setEditable(false);

	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

	public Text getTot() {
		return tot;
	}
	public Text getChecked() {
		return checked;
	}
	public Text getSelected() {
		return selected;
	}
}

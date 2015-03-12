package me.stec.admin.db;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Link;
import org.eclipse.swt.SWT;

public class kkk extends Composite {

	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public kkk(Composite parent, int style) {
		super(parent, style);
		
		Link link = new Link(this, SWT.NONE);
		link.setBounds(36, 23, 42, 13);
		link.setText("<a>New Link</a>");

	}

	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}
}

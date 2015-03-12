package me.stec.admin.widget;

import me.stec.admin.iface.IValid;

import org.eclipse.swt.widgets.Composite;

public class WgDcrTextDecimal extends WgDcrText {

	public WgDcrTextDecimal(Composite parent, int style) {
		super(parent, style);
	}

	@Override
	public void setIValid(){
		wgXDecoration.setIValid(new IValid() {
			@Override
			public boolean check(String text) {
				return 	text.matches("[0-9]+") || 
						text.matches("[0-9]+[.][0-9]+");
			}
		});
	}

}

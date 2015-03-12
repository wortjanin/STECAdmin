package me.stec.admin.widget;

import me.stec.admin.iface.IValid;

import org.eclipse.swt.widgets.Composite;

public class WgDcrTextNumber extends WgDcrText {

	public WgDcrTextNumber(Composite parent, int style) {
		super(parent, style);
	}

	@Override
	public void setIValid(){
		wgXDecoration.setIValid(new IValid() {
			@Override
			public boolean check(String text) {
				return 	text.matches("[0-9]+");
			}
		});
	}

}

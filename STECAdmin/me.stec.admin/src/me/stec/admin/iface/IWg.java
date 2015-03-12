package me.stec.admin.iface;

import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.widgets.Control;

public interface IWg {
	String getText();
	void addModifyListener(ModifyListener modifyListener);
	Control getMyControl();
	
	void clearWg();
	void dataFromWg();
	void dataToWg();
	
	void setupLimits();
	void setupLimits(IVal iVal);
	
}

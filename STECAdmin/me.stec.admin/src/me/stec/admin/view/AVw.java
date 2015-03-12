package me.stec.admin.view;

//import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.part.ViewPart;

public abstract class AVw extends ViewPart {

	public abstract void leaveMyFocus(boolean nextIsFilter);

	public abstract void setMyFocus();

}

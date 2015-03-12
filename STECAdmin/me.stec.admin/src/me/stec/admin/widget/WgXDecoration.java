package me.stec.admin.widget;

import me.stec.admin.iface.IValid;
import me.stec.admin.iface.IWg;

import org.eclipse.jface.fieldassist.ControlDecoration;
import org.eclipse.jface.fieldassist.FieldDecorationRegistry;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;

public class WgXDecoration{
	private IWg control;
	private int position;
	public WgXDecoration(IWg control, int position) {
		this.control = control;
		this.position = position;
	}

	public String getDcrText() {
		return dcrText;
	}
	public void setDcrText(String dcrText) {
		this.dcrText = dcrText;
		if(null!=controlDecoration)
			controlDecoration.setDescriptionText(this.dcrText);
	}
	private String dcrText = "Необходимо заполнить поле";

	public IValid getIValid(){
		return this.iValid;
	}
	public void setIValid(IValid iValid){
		this.iValid = iValid;
	}
	private IValid iValid;
	private ControlDecoration controlDecoration;
	
	public void setDecoration(){
		if(null != controlDecoration) return;
		controlDecoration = new ControlDecoration(control.getMyControl(), this.position);//SWT.LEFT | SWT.TOP);
		controlDecoration.setMarginWidth(1);
		controlDecoration.setDescriptionText(getDcrText());
		controlDecoration.setImage(FieldDecorationRegistry.getDefault()
				.getFieldDecoration(FieldDecorationRegistry.DEC_ERROR).getImage());
		control.addModifyListener(new ModifyListener() {
			@Override
			public void modifyText(ModifyEvent e) {
				if(iValid.check(control.getText()))
					controlDecoration.hide();
				else
					controlDecoration.show();
			}
		});
	}
}

package me.stec.admin.widget;

import java.util.List;

import me.stec.admin.iface.IVal;
import me.stec.admin.iface.IValid;
import me.stec.admin.iface.IWg;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.SWT;

public class WgDcrText extends Text implements IWg{
	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

	@Override
	public Control getMyControl() {
		return this;
	}

	@Override
	public void clearWg() {
		this.setText("");
	}

	@Override
	public void dataFromWg() {
		iVal.setVal(this.getText());
	}

	@Override
	public void dataToWg() {
		this.setText(String.valueOf(iVal.getVal()));
	}

	public void setIVal(List<IWg> iWg, IVal iVal, Label label) {
		this.iVal = iVal;
		label.setText(this.iVal.getAttr().getCaption());
		iWg.add(this);
	}

	/**
	 * @return the iVal
	 */
	public IVal getIVal() {
		return iVal;
	}

	protected IVal iVal;
//-----------------------------------------------------------------------------------
	
	/**
	 * Create the decorated text.
	 * @param parent
	 * @param style
	 * @wbp.parser.entryPoint
	 */
	public WgDcrText(Composite parent, int style) {
		super(parent, style);
	}

	protected WgXDecoration wgXDecoration;

	@Override
	public void setupLimits(){
		super.setTextLimit(this.iVal.getAttr().getDataLength());
		if( !this.iVal.getAttr().getDbIsNotNull() || 
			this.iVal.getAttr().getDbReadOnly())
			return;
		addDecoration();
		setIValid();
		setDcrText(this.iVal.getAttr().getCaption());
	}
	
	@Override
	public void setupLimits(IVal iVal){
		super.setTextLimit(this.iVal.getAttr().getDataLength());
	}
	
	public void addDecoration(){
		wgXDecoration = new WgXDecoration(this, SWT.LEFT | SWT.TOP);
		wgXDecoration.setDecoration();
	}

	public void setIValid(IValid iValid){
		wgXDecoration.setIValid(iValid);
	}
	public void setIValid(){
		wgXDecoration.setIValid(new IValid() {
			@Override
			public boolean check(String text) {
				return text.trim().length() > 0;
			}
		});
	}
	
	public String getDcrText() {
		if(null!=wgXDecoration)
			return wgXDecoration.getDcrText();
		return "";
	}
	public void setDcrText(String dcrText) {
		if(null!=wgXDecoration)
			wgXDecoration.setDcrText("Необходимо правильно заполнить поле <" + dcrText + ">");//"Необходимо заполнить поле <" + dcrText.trim() + ">");
	}
}

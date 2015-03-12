package me.stec.admin.widget;

import java.util.Date;
import java.util.List;
import java.util.Locale;

import me.stec.admin.iface.IVal;
import me.stec.admin.iface.IValid;
import me.stec.admin.iface.IWg;

import org.eclipse.nebula.widgets.datechooser.DateChooserCombo;
import org.eclipse.nebula.widgets.formattedtext.DateFormatter;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;

public class WgDcrDateCombo extends DateChooserCombo  implements IWg {

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
		this.setValue(null);
	}

	@Override
	public void dataFromWg() {
		iVal.setVal(this.getValue());
	}

	@Override
	public void dataToWg() {
		this.setValue((Date) iVal.getVal());
	}

	/**
	 * @param iVal the iVal to set
	 */
	public void setIVal(List<IWg> iWg, IVal iVal, Label label) {
		this.iVal = iVal;
		iValDataLength = this.iVal.getAttr().getDataLength(); 
	}

	private int iValDataLength;
	public void setIVal(IVal iVal, int iValDataLength) {
		this.iVal = iVal;
		this.iValDataLength = iValDataLength;
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
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public WgDcrDateCombo(Composite parent, int style) {
		super(parent, style);
		super.setFormatter(dateFormat);
		super.setLocale(locale);
	}
	private static DateFormatter dateFormat = new DateFormatter("dd.MM.yyyy");
	private static Locale locale = new Locale("ru", "RU");
	
	private WgXDecoration wgXDecoration;
	
	@Override
	public void setupLimits(){
		super.setTextLimit(iValDataLength);
		if( !this.iVal.getAttr().getDbIsNotNull() || 
			this.iVal.getAttr().getDbReadOnly())
			return;
		addDecoration();
		setIValid();
		setDcrText(this.iVal.getAttr().getCaption());
	}

	@Override
	public void setupLimits(IVal iVal){
		super.setTextLimit(iVal.getAttr().getDataLength());
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
				return null != WgDcrDateCombo.this.getValue();
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

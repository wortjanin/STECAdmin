package me.stec.admin.widget;

import java.util.List;

import me.stec.admin.iface.IVal;
import me.stec.admin.iface.IValid;
import me.stec.admin.iface.IWg;
import me.stec.admin.widget.provider.AMPCombo;
import me.stec.admin.widget.provider.Combo2CP;
import me.stec.admin.widget.provider.Combo3LP;

import org.eclipse.jface.viewers.ComboViewer;
import org.eclipse.jface.viewers.Viewer;
import org.eclipse.jface.viewers.ViewerComparator;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;

public class WgDcrCombo extends ComboViewer  implements IWg {
	
	private static final ViewerComparator vc = new ViewerComparator(){
		@Override
		public int compare(Viewer viewer, Object e1, Object e2) {
			return e1.toString().compareTo(e2.toString());
		}
	};

	public void setLayoutData(GridData gridData) {
		getCombo().setLayoutData(gridData);
	}

	private AMPCombo aMPCombo;

	@Override
	public Control getMyControl() {
		return super.getCombo();
	}

	@Override
	public void clearWg() {
		super.getCombo().setText("");
	}

	@Override
	public void dataFromWg() {
		iVal.setVal(this.aMPCombo.getVal(super.getCombo().getText()));
	}

	@Override
	public void dataToWg() {
		super.getCombo().setText(this.aMPCombo.getKey(iVal.getVal()));
	}

	/**
	 * @param iVal the iVal to set
	 */
	public void setIVal(List<IWg> iWg, IVal iVal, IVal iValLabel, Label label, AMPCombo aMPCombo) {
		this.iVal = iVal;
		if(null != label)
			label.setText(sLabel = ((null==iValLabel)?iVal:iValLabel).getAttr().getCaption());
		this.aMPCombo = aMPCombo;
		super.setInput(aMPCombo.getRowList());
		super.getCombo().setTextLimit(this.aMPCombo.getTextLimit());
		if(null != iWg)
			iWg.add(this);
	}
	private String sLabel = "";
	/**
	 * @return the iVal
	 */
	public IVal getIVal() {
		return iVal;
	}

	protected IVal iVal;

	@Override
	public String getText() {
		return super.getCombo().getText();
	}

	@Override
	public void addModifyListener(ModifyListener modifyListener) {
		super.getCombo().addModifyListener(modifyListener);
	}
	
	protected int indexOf(String text) {
		return super.getCombo().indexOf(text);
	}
	
//-----------------------------------------------------------------------------------
	/**
	 * Create the decorated Combo.
	 * @param parent
	 * @param style
	 */
	public WgDcrCombo(Composite parent, int style) {
		super(parent, style);
		super.setContentProvider(new Combo2CP());
		super.setLabelProvider(new Combo3LP());
		super.setComparator(vc);

	}

	private WgXDecoration wgXDecoration;
	
	@Override
	public void setupLimits(){
		if( !this.iVal.getAttr().getDbIsNotNull() || 
			this.iVal.getAttr().getDbReadOnly())
				return;
			addDecoration();
			setIValid();
			setDcrText(sLabel);
	}

	@Override
	public void setupLimits(IVal iVal){
		super.getCombo().setTextLimit(iVal.getAttr().getDataLength());
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
				return WgDcrCombo.this.indexOf(text)> -1 && text.trim().length() > 0;
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

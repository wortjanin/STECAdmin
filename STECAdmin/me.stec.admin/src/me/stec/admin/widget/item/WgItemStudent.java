package me.stec.admin.widget.item;


import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import me.stec.admin.iface.IWg;
import me.stec.admin.logic.user.Student;
import me.stec.admin.widget.WgDcrCombo;
import me.stec.admin.widget.WgDcrDateCombo;
import me.stec.admin.widget.WgDcrText;
import me.stec.admin.widget.provider.MPComboFaculty;
import me.stec.admin.widget.provider.MPComboGenderMy;
import me.stec.admin.widget.provider.MPComboGroupUniver;
import me.stec.admin.widget.provider.MPComboKurs;
import me.stec.admin.widget.provider.MPComboSpeciality;

import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.TabFolder;
import org.eclipse.swt.widgets.TabItem;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;

import com.swtdesigner.ResourceManager;

public class WgItemStudent extends Composite {
	private Composite composite;
	private ScrolledComposite scrolledComposite;
	private Student student = new Student();

	protected List<IWg> iWg = new ArrayList<IWg>();
	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public WgItemStudent(Composite parent, int style) {
		super(parent, style);
		FillLayout fillLayout = new FillLayout(SWT.HORIZONTAL);
		fillLayout.marginWidth = 3;
		fillLayout.marginHeight = 3;
		setLayout(fillLayout);
		
		Point sz;
		scrolledComposite = new ScrolledComposite(this, SWT.H_SCROLL | SWT.V_SCROLL);
		scrolledComposite.setExpandHorizontal(true);
		scrolledComposite.setExpandVertical(true);
		{
			composite = new Composite(scrolledComposite, SWT.NONE);
			GridLayout gl_composite = new GridLayout(2, false);
			gl_composite.verticalSpacing = 0;
			gl_composite.marginWidth = 0;
			gl_composite.marginHeight = 0;
			gl_composite.horizontalSpacing = 0;
			composite.setLayout(gl_composite);
			{
				Group group = new Group(composite, SWT.NONE);
				GridLayout gl_group = new GridLayout(4, false);
				gl_group.marginTop = 3;
				gl_group.horizontalSpacing = 10;
				group.setLayout(gl_group);
				group.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
				group.setText("Личные данные");
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("ИН");
					WgDcrText wgXText = new WgDcrText(group, SWT.BORDER | SWT.READ_ONLY);
					wgXText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 3, 1));
					wgXText.setIVal(iWg, student.getId(), label);
				}
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("Фамилия");
					WgDcrText wgDcrText = new WgDcrText(group, SWT.BORDER);
					wgDcrText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 3, 1));
					wgDcrText.setIVal(iWg, student.getSurname(), label);
				}
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("Имя");
					WgDcrText wgDcrText = new WgDcrText(group, SWT.BORDER);
					wgDcrText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 3, 1));
					wgDcrText.setIVal(iWg, student.getName(), label);
				}
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("Отчество");
					WgDcrText wgDcrText = new WgDcrText(group, SWT.BORDER);
					wgDcrText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 3, 1));
					wgDcrText.setIVal(iWg, student.getPatronymic(), label);
				}
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("Бывшая фамилия");
					WgDcrText wgXText = new WgDcrText(group, SWT.BORDER | SWT.READ_ONLY);
					wgXText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 3, 1));
				}
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("Пол");
					WgDcrCombo wgDcrCombo = new WgDcrCombo(group, SWT.NONE);
					wgDcrCombo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
					wgDcrCombo.setIVal(iWg, student.getGender(), null, label, new MPComboGenderMy());
				}
				{
					Label label = new Label(group, SWT.NONE);
					label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
					label.setText("Дата Рождения");
					WgDcrDateCombo wgDcrDateCombo = new WgDcrDateCombo(group, SWT.BORDER);
					wgDcrDateCombo.setWeeksVisible(true);
//					wgDcrDateCombo.setLocale(Locale.getDefault());
//					wgDcrDateCombo.setLocale(new Locale("ru", "RU"));
				}
				{
					WgItemStudentFamilyReq wgItemStudentFamilyReq = new WgItemStudentFamilyReq(group, SWT.NONE);
					wgItemStudentFamilyReq.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 4, 1));
				}
			}
			{
				Label label = new Label(composite, SWT.NONE);
				GridData gd_label = new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1);
				gd_label.heightHint = 193;
				label.setLayoutData(gd_label);
				label.setImage(ResourceManager.getPluginImage("me.stec.admin", "icons/app/photo/P_no_ph.jpg"));
			}
			sz = composite.computeSize(SWT.DEFAULT, SWT.DEFAULT);
			{
				TabFolder tabFolder = new TabFolder(composite, SWT.NONE);
				tabFolder.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 2, 1));
				{
					TabItem tabItem = new TabItem(tabFolder, SWT.NONE);
					tabItem.setText("Учебная деятельность");
					{
						Composite composite_1 = new Composite(tabFolder, SWT.NONE);
						tabItem.setControl(composite_1);
						GridLayout gl_composite_1 = new GridLayout(2, false);
						gl_composite_1.horizontalSpacing = 10;
						composite_1.setLayout(gl_composite_1);
						{
							Label label = new Label(composite_1, SWT.NONE);
							label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
							label.setText("Факультет");
							WgDcrCombo wgDcrCombo = new WgDcrCombo(composite_1, SWT.NONE);
							wgDcrCombo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
							wgDcrCombo.setIVal(iWg, student.getIdFaculty(), student.getFaculty(), label, new MPComboFaculty());
						}
						{
							Label label = new Label(composite_1, SWT.NONE);
							label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
							label.setText("Курс");
							WgDcrCombo wgDcrCombo = new WgDcrCombo(composite_1, SWT.NONE);
							wgDcrCombo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
							wgDcrCombo.setIVal(iWg, student.getIdKurs(), student.getKurs(), label, new MPComboKurs());
						}
						{
							Label label = new Label(composite_1, SWT.NONE);
							label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
							label.setText("Группа");
							WgDcrCombo wgDcrCombo = new WgDcrCombo(composite_1, SWT.NONE);
							wgDcrCombo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
							wgDcrCombo.setIVal(iWg, student.getIdStecGroup(), student.getGroupUniver(), label, new MPComboGroupUniver());
						}
						{
							Label label = new Label(composite_1, SWT.NONE);
							label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
							label.setText("Специальность");
							WgDcrCombo wgDcrCombo = new WgDcrCombo(composite_1, SWT.NONE);
							wgDcrCombo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
							wgDcrCombo.setIVal(iWg, student.getIdSpeciality(), student.getSpeciality(), label, new MPComboSpeciality());
						}
					}
				}
			}
		}
		scrolledComposite.setContent(composite);
		sz.y = composite.computeSize(SWT.DEFAULT, SWT.DEFAULT).y;
		scrolledComposite.setMinSize(sz);//new Point(500, 400));

		for(IWg iwg : iWg) iwg.setupLimits();
	}

//	@Override
//	public void layout() {
//		super.layout();
//	}
	
	public int getMinHeight() {
		return scrolledComposite.getMinHeight();
	}
	public int getMinWidth() {
		return scrolledComposite.getMinWidth();
	}
	
	@Override
	protected void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

	public void setAItem(BigDecimal bdID, boolean forUpdate) throws SQLException {
		this.student.setID(bdID);
		this.student.load(forUpdate);
		for(IWg iwg : iWg) iwg.dataToWg();
	}
	
}

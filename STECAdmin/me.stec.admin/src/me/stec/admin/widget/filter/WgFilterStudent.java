package me.stec.admin.widget.filter;



import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Button;
import me.stec.admin.widget.WgDcrCombo;
import me.stec.admin.widget.provider.MPComboGenderMy;


public class WgFilterStudent extends Composite {
	private Text tSurname;
	private Text tName;
	private Text tPatronymic;
	private Text tLogin;
	private WgDcrCombo wgDcrCombo;
	private Combo cFaculty;
	private Combo cYear;
	private Combo cGroup;
	private Combo cSpeciality;
	private Combo cEduForm;
	private Combo cContrForm;
	private Combo cStuGroup;
	private Button bCardRequesters;
	private Button bSurnameChangeRequesters;
	private Button bCardReceived;
	private Button bPasswordsRegenerated;

	public WgFilterStudent(Composite parent, int style) {
		super(parent, style);
		GridLayout gridLayout = new GridLayout(1, false);
		gridLayout.marginLeft = 1;
		gridLayout.marginWidth = 3;
		gridLayout.marginHeight = 3;
		setLayout(gridLayout);

		Group group = new Group(this, SWT.NONE);
		GridData gd_group = new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1);
		gd_group.heightHint = 194;
		group.setLayoutData(gd_group);
		group.setText("По студентам");
		GridLayout gl_group = new GridLayout(4, false);
		gl_group.marginLeft = 5;
		gl_group.marginWidth = 0;
		gl_group.marginHeight = 0;
		group.setLayout(gl_group);
		
		Group group_1 = new Group(group, SWT.NONE);
		GridData gd_group_1 = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
		gd_group_1.widthHint = 169;
		gd_group_1.heightHint = 153;
		group_1.setLayoutData(gd_group_1);
		group_1.setText("Личные данные");
		group_1.setLayout(new GridLayout(3, false));
		
		Label label_1 = new Label(group_1, SWT.NONE);
		label_1.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_1.setText("Фамилия");
		
		tSurname = new Text(group_1, SWT.BORDER);
	tSurname.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1));
		
		Label label_2 = new Label(group_1, SWT.NONE);
		label_2.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_2.setText("Имя");
		
		tName = new Text(group_1, SWT.BORDER);
		tName.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1));
		
		Label lblJnxtcndj = new Label(group_1, SWT.NONE);
		lblJnxtcndj.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lblJnxtcndj.setText("Отчество");
		
		tPatronymic = new Text(group_1, SWT.BORDER);
		tPatronymic.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1));
		
		Label label_12 = new Label(group_1, SWT.NONE);
		label_12.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_12.setText("Пол");
		
		wgDcrCombo = new WgDcrCombo(group_1, SWT.NONE);
		Combo combo = wgDcrCombo.getCombo();
		combo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1));
		wgDcrCombo.setIVal(null, null, null, null, new MPComboGenderMy());
		
		Label label_13 = new Label(group_1, SWT.NONE);
		label_13.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_13.setText("Логин");
		
		tLogin = new Text(group_1, SWT.BORDER);
		tLogin.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1));
		
		Group group_4 = new Group(group, SWT.NONE);
		group_4.setText("Учебная деятельность");
		group_4.setLayout(new GridLayout(2, false));
		group_4.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
		
		Label label_6 = new Label(group_4, SWT.NONE);
		label_6.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_6.setText("Факультет");
		
		cFaculty = new Combo(group_4, SWT.NONE);
		cFaculty.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label label_5 = new Label(group_4, SWT.NONE);
		label_5.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_5.setText("Курс");
		
		cYear = new Combo(group_4, SWT.NONE);
		cYear.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label label_7 = new Label(group_4, SWT.NONE);
		label_7.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_7.setText("Группа");
		
		cGroup = new Combo(group_4, SWT.NONE);
		cGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label label_8 = new Label(group_4, SWT.NONE);
		label_8.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_8.setText("Специальность");
		
		cSpeciality = new Combo(group_4, SWT.NONE);
		cSpeciality.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label label_14 = new Label(group_4, SWT.NONE);
		label_14.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_14.setText("Форма обучения");
		
		cEduForm = new Combo(group_4, SWT.NONE);
		cEduForm.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label label_15 = new Label(group_4, SWT.NONE);
		label_15.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_15.setText("Форма договора");
		
		cContrForm = new Combo(group_4, SWT.NONE);
		cContrForm.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Group group_5 = new Group(group, SWT.NONE);
		group_5.setText("Другое");
		GridLayout gl_group_5 = new GridLayout(2, false);
		gl_group_5.horizontalSpacing = 10;
		gl_group_5.marginHeight = 0;
		gl_group_5.marginWidth = 3;
		group_5.setLayout(gl_group_5);
		GridData gd_group_5 = new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1);
		gd_group_5.widthHint = 220;
		group_5.setLayoutData(gd_group_5);
		
		Composite composite = new Composite(group_5, SWT.NONE);
		composite.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 2, 1));
		GridLayout gl_composite = new GridLayout(2, false);
		gl_composite.marginWidth = 0;
		composite.setLayout(gl_composite);
		
		Label label_9 = new Label(composite, SWT.NONE);
		label_9.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_9.setText("Группа (ст)");
		
		cStuGroup = new Combo(composite, SWT.NONE);
		cStuGroup.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Label label_16 = new Label(group_5, SWT.NONE);
		label_16.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_16.setText("Заказавшие карту");
		
		bCardRequesters = new Button(group_5, SWT.CHECK);
		
		Label label_17 = new Label(group_5, SWT.NONE);
		label_17.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_17.setText("Запросы на утверждение фамилии");
		
		bSurnameChangeRequesters = new Button(group_5, SWT.CHECK);
		
		Label label_18 = new Label(group_5, SWT.NONE);
		label_18.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_18.setText("Карты выданы");
		
		bCardReceived = new Button(group_5, SWT.CHECK);
		
		Label label_19 = new Label(group_5, SWT.NONE);
		label_19.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		label_19.setText("Пароли сброшены");
		
		bPasswordsRegenerated = new Button(group_5, SWT.CHECK);
		Label label = new Label(group, SWT.NONE);
		label.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		Label label_3 = new Label(group, SWT.NONE);
		label_3.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		Label label_4 = new Label(group, SWT.NONE);
		label_4.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		Label label_10 = new Label(group, SWT.NONE);
		label_10.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		new Label(group, SWT.NONE);
		Label label_11 = new Label(group, SWT.NONE);
		label_11.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		initialize();
	}

	private void initialize() {
		setSize(new Point(660, 206));
	}
	public Text getTSurname() {
		return tSurname;
	}
	public Text getTName() {
		return tName;
	}
	public Text getTPatronymic() {
		return tPatronymic;
	}
	public WgDcrCombo getCGender() {
		return wgDcrCombo;
	}
	public Text getTLogin() {
		return tLogin;
	}
	public Combo getCFaculty() {
		return cFaculty;
	}
	public Combo getCYear() {
		return cYear;
	}
	public Combo getCGroup() {
		return cGroup;
	}
	public Combo getCSpeciality() {
		return cSpeciality;
	}
	public Combo getCEduForm() {
		return cEduForm;
	}
	public Combo getCContrForm() {
		return cContrForm;
	}
	public Combo getCStuGroup() {
		return cStuGroup;
	}
	public Button getBCardRequesters() {
		return bCardRequesters;
	}
	public Button getBSurnameChangeRequesters() {
		return bSurnameChangeRequesters;
	}
	public Button getBCardReceived() {
		return bCardReceived;
	}
	public Button getBPasswordsRegenerated() {
		return bPasswordsRegenerated;
	}
}

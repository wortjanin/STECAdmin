package me.stec.admin.enumer;

public class EYesNo {
	public static final EYesNo Yes = new EYesNo("YES");
	public static final EYesNo No = new EYesNo("NO");

	@Override
	public boolean equals(Object obj) {
		return sYesNo.equals(((EYesNo)obj).sYesNo);
	}

	public boolean equals(String obj) {
		return sYesNo.equals(obj);
	}

	@Override
	public int hashCode() {
		return sYesNo.hashCode();
	}
	
	@Override
	public String toString() {
		return sYesNo;
	}

	
	private String sYesNo;
	private EYesNo(String gender){
		this.sYesNo = gender;
	}
}

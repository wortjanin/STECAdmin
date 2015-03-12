package me.stec.admin;

import me.stec.admin.view.VwFilter;
import me.stec.admin.view.VwFilterBarcode;
import me.stec.admin.view.VwListCard;
import me.stec.admin.view.VwListDoc;
import me.stec.admin.view.VwListDocGroup;
import me.stec.admin.view.VwListGood;
import me.stec.admin.view.VwListOrder;
import me.stec.admin.view.VwListStudent;

import org.eclipse.ui.IFolderLayout;
import org.eclipse.ui.IPageLayout;
import org.eclipse.ui.IPerspectiveFactory;

public class Perspective implements IPerspectiveFactory {
	private static String[] sVw = new String[]{
		VwFilter.getId(),
		VwFilterBarcode.getId(),
		VwListStudent.getId(),
		VwListGood.getId(),
		VwListDoc.getId(),
		VwListDocGroup.getId(),
		VwListOrder.getId(),
		VwListCard.getId()
	}; 
	public void createInitialLayout(IPageLayout layout) {
		//String editorArea = layout.getEditorArea();
		layout.setEditorAreaVisible(false);
		Perspective.setLayout(layout);
		
		IFolderLayout top = layout.createFolder("TOP", IPageLayout.TOP, 0.3f,
				layout.getEditorArea());
		
		
		IFolderLayout btm = layout.createFolder("BOTTOM",IPageLayout.BOTTOM,0.7f,
				layout.getEditorArea());
		
		int i=0;
		top.addView(sVw[i++]);
		top.addView(sVw[i++]);
		for(; i<sVw.length; i++){	btm.addView(sVw[i]);	}
		
		for(i=0; i<sVw.length; i++){	layout.getViewLayout(sVw[i]).setCloseable(false);	}
	}
	
	/**
	 * @param layout the layout to set
	 */
	private static void setLayout(IPageLayout layout) {
		Perspective.layout = layout;
	}

	/**
	 * @return the layout
	 */
	public static IPageLayout getLayout() {
		return layout;
	}

	private static IPageLayout layout;

}

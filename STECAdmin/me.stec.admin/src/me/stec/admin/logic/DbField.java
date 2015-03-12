/**
 * 
 */
package me.stec.admin.logic;


import me.stec.admin.iface.IAttr;
import me.stec.admin.iface.IVal;

/**
 * @author chernoivanov
 *
 */
public final class DbField<T, A extends IAttr> 
extends IAttr
implements IVal
{

	/**
	 * 
	 */
	private final IAttr instanceOfIAttr;
	
	/**
	 * 
	 */
	private T value;
	
	public DbField(T value, A childOfIAttr){
		instanceOfIAttr = childOfIAttr;
		this.value = value;
		assert null!=instanceOfIAttr : "IAttr.getInstance() must return a valid reference to static instance of the implemented class!";
	}

	
	@Override
	public			String	getName()				{	return instanceOfIAttr.getName();	}
	
	@Override
    public 			String 	getCaption()			{	return instanceOfIAttr.getCaption(); }
	
	@Override
    public 			String	getDbColumnName()		{	return instanceOfIAttr.getDbColumnName(); }
	
	@Override
	public 			boolean	getDbLoadableInList()	{	return instanceOfIAttr.getDbLoadableInList(); } 
	
	@Override
	public 			boolean	getDbReadOnly()			{	return instanceOfIAttr.getDbReadOnly(); } 
	
	@Override
	public 			boolean	getDbSaveOnly()			{	return instanceOfIAttr.getDbSaveOnly(); } 
	
	@Override
	public 			boolean	getDbIsCombo()			{	return instanceOfIAttr.getDbIsNotNull(); } 
	
	@Override
	public 			boolean	getDbIsNotNull()		{	return instanceOfIAttr.getDbIsNotNull(); } 
	@Override
	public 			void	setDbIsNotNull(boolean val)	{	instanceOfIAttr.setDbIsNotNull(val); }

	public T getValue() {
		return value;
	}
	public void setValue(T value) {
		this.value = value;
	}

	@Override
	public Object getVal() {
		return value;
	}
	@SuppressWarnings("unchecked")
	@Override
	public void setVal(Object value) {
		this.value = (T)instanceOfIAttr.getVal(value);
	}

	@Override
	public IAttr getAttr() {
		return instanceOfIAttr;
	} 

	@Override
	public boolean equals(Object obj) {
		return 	((IVal)obj).getAttr().equals(((IVal)this).getAttr()) && 
				((null == ((IVal)this).getVal() && null == ((IVal)obj).getVal()) || 
				 (null != ((IVal)this).getVal() && ((IVal)this).getVal().equals(((IVal)obj).getVal())));
	}
}

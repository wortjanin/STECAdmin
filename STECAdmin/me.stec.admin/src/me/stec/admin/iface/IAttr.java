/**
 * 
 */
package me.stec.admin.iface;


import me.stec.admin.enumer.EMinMax;

/**
 * @author  chernoivanov
 */
public abstract class IAttr {

	/**
	 * @uml.property  name="dbIsNotNull"
	 */
	private boolean dbIsNotNull = false;
	/**
	 * 
	 * @return reference to static instance of implemented class (singleton) 
	 * 
	 */
	/**
	 * @uml.property  name="name"
	 */
	public abstract String  getName				();

    public 			String 	getCaption			(){ return null; }
	
    public 			String	getDbColumnName		(){ return null; }
    public 			boolean	getDbLoadableInList	(){ return true; } //it used to be dbColumnVisible in C#
    public 			boolean	getDbReadOnly      	(){ return false; } 
    public 			boolean	getDbSaveOnly      	(){ return false; } 
    public 			boolean	getDbIsCombo       	(){ return false; } 
    public 			boolean	isString	    	(){ return false; } 
    public 			boolean	isBoolean	    	(){ return false; } 
    public			EMinMax isMinMax			(){ return EMinMax.NONE;}
    
    public 			boolean	getDbIsNotNull     	()				{ 	return dbIsNotNull; } 
    /**
	 * @param val
	 * @uml.property  name="dbIsNotNull"
	 */
    public 			void	setDbIsNotNull     	(boolean val)	{	dbIsNotNull = val; } 
    
    private Integer dataLength = Integer.MAX_VALUE; 
    public final	Integer getDataLength(){
    	return dataLength;
    }
    public final	void setDataLength(Integer dataLength){
    	this.dataLength = dataLength;
    }
    
    public Object getVal(Object value){
    	return value;
    }

    public Object translateVal(Object value){
    	return value;
    }

    
}

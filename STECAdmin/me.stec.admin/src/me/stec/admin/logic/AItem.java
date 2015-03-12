/**
 * 
 */
package me.stec.admin.logic;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.google.common.collect.BiMap;

import me.stec.admin.db.Conn;
import me.stec.admin.enumer.EYN;
import me.stec.admin.iface.IAttr;
import me.stec.admin.iface.IItem;
import me.stec.admin.iface.IVal;

/**
 * @author chernoivanov
 *
 */
public abstract class AItem implements IItem {
	public		abstract String		getDbSchemeName();

	public 		abstract boolean	getDbSchemeReadOnly();
	public		abstract String		getLastIdQuery();

	protected	abstract String		getLoadQuery();
	protected	abstract String		getInsertQuery();
	protected	abstract String 	getUpdateQuery();
	protected	abstract String 	getDeleteQuery();
	
	protected final IVal[] val;
	protected abstract BiMap<String, Integer> getColumnNumber();
	
	public IVal	getComboName(){return getId();}
	public abstract IVal getId();
	
	protected AItem(IVal[] value){
		this.val = value;
	}

	protected static void FillColumnData(AItem aDefItem){
		String query = "SELECT COLUMN_NAME, char_length, NULLABLE " + 
		"FROM vw_all_tab_columns " + 
		"WHERE TABLE_NAME  LIKE '" + aDefItem.getDbSchemeName() + "'";
		
		PreparedStatement pstmt = null;
		try{
			pstmt = Conn.get().prepareStatement( query );

			ResultSet rset = pstmt.executeQuery();
			IVal[] val = aDefItem.val;
			BiMap<String, Integer> bm = aDefItem.getColumnNumber();
			for(int i=0; i<val.length;i++)
				bm.put(val[i].getAttr().getDbColumnName(), i);
			while (rset.next()){
				String columnName = rset.getString(1);
				Integer dataLength = rset.getInt(2);
				String nullable = rset.getString(3);
				//ArrayList<String>
				IVal v = val[bm.get(columnName)];
				if(!v.getAttr().getDbIsNotNull())//if nullable 
					v.getAttr().setDbIsNotNull(EYN.No.equals(nullable));
				v.getAttr().setDataLength(dataLength);
			}
			
		} catch (SQLException e) {e.printStackTrace();}
		finally{
			try{if(null != pstmt)pstmt.close();}catch(Exception e){}
		}
	}

	
	private final String comma = ", ";

	protected String getLoadQueryString(){
		String res = "SELECT ";
		for(int i=0;i<val.length;i++){
			IAttr ia = val[i].getAttr(); 
			if(!ia.getDbSaveOnly())
				res += ia.getDbColumnName() + comma;
		}
		res = res.replaceAll(comma + "$", "");
		res += " FROM " + getDbSchemeName() + //getDbLoadSchemeName() +
		" WHERE " + this.getIdDbColumnName() + " = ? ";// + this.getIdDbColumnName();
		return res;
	}
	
	protected String getInsertQueryString(){
		String res = "INSERT INTO " + getDbSchemeName() + "(";
		String vals = "";
		for(int i=1;i<val.length;i++){
			res += val[i].getAttr().getDbColumnName() + comma;
			vals+= "?" + comma;
		}
		vals = vals.replaceAll(comma + "$", "");
		res += ") VALUES (" + vals + ") ";
		return res;
	}
	
	protected String getUpdateQueryString(){
		String res = "UPDATE " + this.getDbSchemeName() + " SET ";
		for(int i=1;i<val.length;i++){
			IAttr ia = val[i].getAttr(); 
			if(!ia.getDbReadOnly()){
				res += ia.getDbColumnName() + " = ?" + comma;
			}
		}
		res = res.replaceAll(comma + "$", "");
		res += " WHERE " + this.getIdDbColumnName() + " = ? ";// + this.getIdDbColumnName();
		return res;//job_id = 'SA_MAN', salary = salary + 1000, department_id = 120";
	}
	
	protected String getDeleteQueryString(){
		return "DELETE FROM " + this.getDbSchemeName() + 
		" WHERE " + this.getIdDbColumnName() + " = ? ";
	}


	@Override
	public void load(boolean forUpdate) throws SQLException {
		if(null == this.getID()) return;
		
		PreparedStatement pstmt = null;
		try{
			pstmt = Conn.get().prepareStatement( getLoadQuery() + (forUpdate ? " FOR UPDATE NOWAIT " : "") );
			pstmt.setObject(1, this.getID()); 

			ResultSet rset = pstmt.executeQuery();
			int iCount = 1;
			if (rset.next())
				for(int i=0; i<val.length;i++)
					if(!val[i].getAttr().getDbSaveOnly())
						val[i].setVal(rset.getObject(iCount++)); 
			
		}
		finally{
			try{if(null != pstmt)pstmt.close();}catch(Exception e){}
		}
	}

	@Override
	public int acceptChanges() throws SQLException {
		if(this.getDbSchemeReadOnly()) return 0;
		
		boolean bInsert = false;
		PreparedStatement pstmt = null;
		try{
			if(null == this.getID()){
				bInsert = true;
				pstmt = Conn.get().prepareStatement(this.getInsertQuery());
				for(int i=1;i<val.length;i++)
					pstmt.setObject(i, val[i].getVal());
				int retVal = pstmt.executeUpdate();
				
				pstmt.close();
				pstmt = Conn.get().prepareStatement(this.getLastIdQuery());
				ResultSet rset = pstmt.executeQuery();
				if (rset.next()) val[0].setVal(rset.getObject(1)); //this.setID(rset.getObject(1));
				else throw new SQLException("BUG: Can't ini ID");
				return retVal;
			}
			else{
				pstmt = Conn.get().prepareStatement(this.getUpdateQuery());
				int iCount = 1;
				for(int i=1;i<val.length;i++)
					if(!val[i].getAttr().getDbReadOnly())
						pstmt.setObject(iCount++, val[i].getVal());
				pstmt.setObject(iCount, this.getID()); 
			}
			return pstmt.executeUpdate();
		}
		catch(SQLException ex){
			if(bInsert) this.setID(null);
			throw ex;
		}
		finally{
			try{if(null != pstmt)pstmt.close();}catch(Exception e){}
		}
	}
	
	@Override
	public int delete() throws SQLException {
		if(null == this.getID()	|| this.getDbSchemeReadOnly()) return 0;
		
		PreparedStatement pstmt = null;
		try{
			pstmt = Conn.get().prepareStatement(this.getDeleteQuery());
			pstmt.setObject(1, this.getID()); 

			return pstmt.executeUpdate();
		}
		finally{
			try{if(null!=pstmt)pstmt.close();}catch(Exception e){}
		}
	}

}

/**
 * 
 */
package me.stec.admin.logic;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import me.stec.admin.db.Conn;
import me.stec.admin.iface.IAttr;
import me.stec.admin.iface.IList;
import me.stec.admin.iface.IVal;

/**
 * @author chernoivanov
 *
 */
public abstract class AItemList implements IList {

	public abstract IVal getId();
	
	private void setStatement(PreparedStatement pstmt, List<BigDecimal> id) throws SQLException{
		int iCount = (iLimit > 0)?2:1;
		if(null == id || 0 == id.size())
			for(int i=0;i<val.length;i++){
				Object o = val[i].getVal();
				if(null == o || (val[i].getAttr().isString() && String.valueOf(o).isEmpty()))
					continue;
				pstmt.setObject(iCount++, o);
			}
		else
			for(int i=0;i<id.size();i++){
				Object o = id.get(i);
				if(null == o)
					continue;
				pstmt.setObject(iCount++, o);
			}
	}
	
	
	@Override
	public ResultSet loadList() throws SQLException {
		String where = getWhereClause();
		String sQuery = "SELECT " + getDistinct() + 
			getLoadQuery() +
			where + sOrderBy;
		
		PreparedStatement pstmt = null;
		pstmt = Conn.get().prepareStatement(sQuery, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		if(iLimit>0) pstmt.setObject(1, iLimit); 
		if(where.length() > 0) setStatement(pstmt, null);
		return pstmt.executeQuery();
	}

	@Override
	public ResultSet loadList(IVal[] val) throws SQLException {
		return loadList(val, null, null);
	}
	@Override
	public ResultSet loadList(IVal[] val, IVal orderBy) throws SQLException {
		return loadList(val, orderBy, null);
	}
	public ResultSet loadList(IVal[] val, IVal orderBy, List<BigDecimal> id)	throws SQLException{
		String where = (null == id || 0 == id.size())?getWhereClause():getWhereClause(id);
		String sOrderBy = (null != orderBy)?(" ORDER BY " + orderBy.getAttr().getDbColumnName()):this.sOrderBy;
		String sQuery = "SELECT " + getDistinct() + 
			getLoadQueryString(val) +
			where + sOrderBy;
		
		PreparedStatement pstmt = null;
		pstmt = Conn.get().prepareStatement(sQuery, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		if(iLimit>0) pstmt.setObject(1, iLimit);
		if(where.length() > 0) setStatement(pstmt, id);
		return pstmt.executeQuery();
	}

	@Override
	public ResultSet loadList(List<IVal> val) throws SQLException {
		return loadList(val, null, null);
	}
	@Override
	public ResultSet loadList(List<IVal> val, IVal orderBy) throws SQLException {
		return loadList(val, orderBy, null);
	}
	@Override
	public ResultSet loadList(List<IVal> val, IVal orderBy, List<BigDecimal> id) throws SQLException {
		IVal[] aIVal = new IVal[val.size()];
		for(int i=0; i<aIVal.length;i++) aIVal[i] = val.get(i);
		return loadList(aIVal, orderBy, id);
	}

	@Override
	public ResultSet loadListCombo() throws SQLException {
		String sQuery = "SELECT " + getDistinct() + 
			getLoadComboQuery() + 
			/*getWhereClause() + */ sOrderByCombo;
		
		PreparedStatement pstmt = null;
		pstmt = Conn.get().prepareStatement( sQuery );
		return pstmt.executeQuery();
	}


	@Override
	public int delete() throws SQLException {
		String where = getWhereClause();
		String sQuery = getDeleteQuery() +  where;
		PreparedStatement pstmt = null;
		try{
			pstmt = Conn.get().prepareStatement( sQuery );
			if(iLimit>0) pstmt.setObject(1, iLimit); 
			if(where.length() > 0) setStatement(pstmt, null);
			return pstmt.executeUpdate();
		}
		finally{
			try{if(null != pstmt)pstmt.close();}catch(Exception e){}
		}
	}


	public		abstract String		getDbSchemeName();

	public 		abstract boolean	getDbSchemeReadOnly();

	protected	abstract String		getLoadQuery();
	protected	abstract String		getLoadComboQuery();
	protected	abstract String 	getDeleteQuery();
	
	protected final IVal[] val;
	protected AItemList(IVal[] value){
		this.val = value;
	}

	protected final String comma = ", ";
	protected final String and = " AND "; 
	
	private String getWhereClause(List<BigDecimal> id){
		String res = "";
		for(int iId = 0; iId<id.size(); iId++){
			if(null!=id.get(iId))
				res += "?" + comma;
		}
		res = res.replaceAll(comma + "$", "");
		if(res.length()>0)
			res = " WHERE " + this.getILimit() + 
					this.getId().getAttr().getDbColumnName() + " IN ( "
					+ res + " )";
		return res;
	}
	protected final String getWhereClause(){
		String res = "";
		for(int i=0;i<val.length;i++){
			IAttr ia = val[i].getAttr();
			Object o = val[i].getVal();
			boolean isString = ia.isString();
			if(null == o || (isString && String.valueOf(o).isEmpty()))
				continue;
			switch(ia.isMinMax()){
			case NONE:
				res += " (" + ia.getDbColumnName() + ((isString)?" LIKE ? ":" = ? ") + ") ";
				res += and;
				break;
			case MIN:
				res += " (" + ia.getDbColumnName() + " >= ? ";
				res += and;
				break;
			case MAX:
				res += " (" + ia.getDbColumnName() + " <= ? ";
				res += and;
				break;
			}
		}
		if(res.length() > 0) 
			res = " WHERE " + this.getILimit() + res.replaceAll(and + "$", "");
		return res;
	}
	public	List<IVal> getHeaderAll(){
		List<IVal> list = new ArrayList<IVal>();
		list.add(val[0]);
		for(int i=1;i<val.length;i++)
			if(!val[i].getAttr().getDbColumnName().equals(val[i-1].getAttr().getDbColumnName()))
				list.add(val[i]);
		return list;	
	}

	private List<IVal>	listHeader = new ArrayList<IVal>(); 
	protected	List<IVal> getListHeader(){
		return listHeader;	
	}
	public	List<IVal> getHeader(){
		List<IVal> list = new ArrayList<IVal>();
		list.addAll(this.listHeader);
		return list;	
	}
	protected final String getLoadQueryString()	{
		listHeader.clear();
		String res = ""; //"SELECT " + getDistinct(); -> in loadList
		IAttr ia = val[0].getAttr();
		if(ia.getDbLoadableInList()){
			res += ia.getDbColumnName() + comma;
			listHeader.add(val[0]);
		}
		for(int i=1;i<val.length;i++){
			ia = val[i].getAttr(); 
			if(ia.getDbLoadableInList() &&
					!val[i-1].getAttr().getDbColumnName().equals(ia.getDbColumnName())){
				res += ia.getDbColumnName() + comma;
				listHeader.add(val[i]);
			}
		}
		res = res.replaceAll(comma + "$", "");
		res += 	" FROM " + getDbSchemeName();// + getWhereClause() + " " + sOrderBy;-> in loadList
		
		return res;
	}
	
	private String getLoadQueryStringAll(){
		listHeader.clear();
		String res = "";
		IAttr ia = this.val[0].getAttr(); 
		res += ia.getDbColumnName() + comma;
		listHeader.add(val[0]);
		for(int i=1;i<this.val.length;i++){
			ia = this.val[i].getAttr(); 
			if(ia.getDbColumnName().equals(this.val[i-1].getAttr().getDbColumnName())) continue;
			res += ia.getDbColumnName() + comma;
			listHeader.add(val[i]);		}
		res = res.replaceAll(comma + "$", "");
		res += 	" FROM " + getDbSchemeName();
		return res;
	}
	protected final String getLoadQueryString(IVal[] val){
		if(null == val){//means load ALL fields
			return getLoadQueryStringAll();		}
		listHeader.clear();
		String res = ""; //"SELECT " + getDistinct(); -> in loadList	
		for(int i=0;i<val.length;i++){
			IAttr ia = val[i].getAttr(); 
			res += ia.getDbColumnName() + comma;
			listHeader.add(val[i]);			}
		res = res.replaceAll(comma + "$", "");
		res += 	" FROM " + getDbSchemeName();// + getWhereClause() + " " + sOrderBy;-> in loadList
		return res;
	}

	protected final String getDistinct(){
		return ((bDistinct)?" DISTINCT ":"");
	}
	
	protected final String getILimit(){
		return ((iLimit > 0)?(" (ROWNUM <= ?) " + and):"");
	}
	
	protected final String getLoadComboQueryString(){
		String res = ""; //"SELECT ";// + getDistinct();->query
		for(int i=0;i<val.length;i++){
			IAttr ia = val[i].getAttr(); 
			if(ia.getDbIsCombo())
				res += ia.getDbColumnName() + comma;
		}
		res = res.replaceAll(comma + "$", "") + " FROM " + getDbSchemeName();
//		res += " FROM " + getDbSchemeName();// + " " + sOrderByCombo;->query
		return res;
	}

	protected final String getDeleteQueryString(){
		return "DELETE FROM " + getDbSchemeName();// + getWhereClause();-> in delete()
	}
	
	protected boolean	bSelectAllFields	= false;
    protected boolean 	bDistinct			= false;
    protected int		iLimit				= 0;
    protected String	sOrderBy			= "";
    protected String	sOrderByCombo		= "";
	
}

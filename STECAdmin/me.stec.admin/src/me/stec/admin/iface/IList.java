/**
 * 
 */
package me.stec.admin.iface;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * @author chernoivanov
 *
 */
public interface IList {
        IItem 		getItemDef();

        ResultSet	loadList()													throws SQLException;
		ResultSet	loadList(IVal[] val)										throws SQLException;
		ResultSet	loadList(IVal[] val, IVal orderBy)							throws SQLException;
		ResultSet	loadList(IVal[] val, IVal orderBy, List<BigDecimal> id)		throws SQLException;
		
		ResultSet	loadListCombo()												throws SQLException;

        int			delete() 													throws SQLException;

		ResultSet loadList(List<IVal> val)										throws SQLException;
		ResultSet loadList(List<IVal> val, IVal orderBy)						throws SQLException;
		ResultSet loadList(List<IVal> val, IVal orderBy, List<BigDecimal> id)	throws SQLException;



}

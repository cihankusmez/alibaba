<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
        <cffunction name="saveFormData" access="remote" returnFormat="json">
            <cfargument name="formData" type="string" required="true">
            <cftry>  
                <cfset parsedData = {}>
                <cfloop list="#formData#" index="item" delimiters="&">
                    <cfset keyValue = ListToArray(item, "=")>
                    <cfset parsedData[keyValue[1]] = keyValue[2] ?: 0>
                </cfloop>

                <cfset userId = trim(parsedData.inputUserId)>
                <cfset expenseDescription = trim(parsedData.inputExpenseDescription)>
                <cfset amount = trim(parsedData.inputAmount)>

                <cfset createdAt = CreateODBCDateTime( now() )>

                <cfquery datasource="alibaba">
                    INSERT INTO Expenses (UserId, ExpenseDescription, Amount, CreatedAt) 
                    VALUES 
                    (
                        <cfqueryparam value="#userId#" cfsqltype="CF_SQL_INTEGER" >, 
                        <cfqueryparam value="#expenseDescription#" cfsqltype="CF_SQL_NVARCHAR">,
                        <cfqueryparam value="#amount#" cfsqltype="CF_SQL_DECIMAL" >,
                        <cfqueryparam value="#createdAt#" cfsqltype="CF_SQL_DATE">
                    )
                </cfquery>

                <cfset var result = {}>    

                <cfset result.status = "success">
                <cfset result.message = "Veri başarıyla eklendi.">
                <cfset result.formData = parsedData>
                <cfreturn result>

                <cfcatch type="any">
                    <cfset result.status = "fail">
                    <cfset result.message = "Veri eklenirken hata oluştu.">
                    <cfset result.error = cfcatch.message>
                </cfcatch>
            </cftry>
        </cffunction>

        <cffunction name="getFormData" access="remote" returnFormat="json">
            <cftry> 
                <cfset var result = {}>   

                <cfset expensesDao = createObject("component", "data/expenses")>
                <cfset qExpenses = expensesDao.getExpenses()>
                <cfset qExpensesLoop = expensesDao.getExpensesLoop(qExpenses)>

                <cfset result.status = "success">
                <cfset result.message = "Veri başarıyla eklendi.">
                <cfset result.view = qExpensesLoop>
                
                <cfreturn result>

                <cfcatch type="any">
                    <cfset result.status = "fail">
                    <cfset result.message = "Veri eklenirken hata oluştu.">
                    <cfset result.error = cfcatch.message>
                </cfcatch>
            </cftry>
        </cffunction>

        

    <cffunction name="deleteData" access="remote" returnFormat="json">
        <cfargument name="delete_id" type="integer" required="true">
        <cftry>  
            <cfquery name="deleteQuery" datasource="alibaba">
                DELETE FROM Expenses
                WHERE Id = <cfqueryparam value="#delete_id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfset result.status = "success">
            <cfset result.message = "Veri başarıyla silindi.">
            <cfset result.delete_id = delete_id>
            <cfreturn result>
        <cfcatch type="any">
            <cfset result.status = "fail">
            <cfset result.message = "Veri silinirken hata oluştu.">
            <cfset result.error = cfcatch.message>
        </cfcatch>
    </cftry>
    </cffunction>
</cfcomponent>






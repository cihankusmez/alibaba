<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cffunction name="getExpenses" access="public" returntype="query">
        <cfargument name="limit" default="1000" type="integer">

        <cfquery name="qExpenses" datasource="alibaba">
            select TOP #limit# Expenses.Id as ExpenseId, * from Expenses
            left join Users
            on Users.Id = Expenses.UserId
            order by Expenses.Id desc
        </cfquery>
        
        <cfreturn qExpenses>
    </cffunction>
    <cffunction name="getExpensesLoop" access="public" returntype="any">
        <cfargument name="qExpenses" type="query" required="true">
        <cfloop query="qExpenses">
            <cfset createdAt = isDate(qExpenses.CreatedAt) ? dateFormat(qExpenses.CreatedAt, "mm/dd/yyyy") : " --- ">
            <cfoutput>
                <tr>
                    <td>#createdAt#</td>
                    <td>#qExpenses.ExpenseDescription#</td>
                    <td>#DecimalFormat(qExpenses.Amount)#</td>                    
                    <td>#qExpenses.Username#</td>
                    <td>
                        <button type="button" data-id="#qExpenses.ExpenseId#" class="btn btn-secondary edit_button m-1">Düzenle</button>
                        <button type="button" data-id="#qExpenses.ExpenseId#" class="btn btn-secondary btn-danger delete_button m-1">Sil</button>
                    </td>                   
                </tr>
            </cfoutput>
        </cfloop>
    </cffunction>
</cfcomponent>
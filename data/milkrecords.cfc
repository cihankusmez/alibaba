<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cffunction name="getMilkRecords" access="public" returntype="query">

        <cfquery name="qMilkRecords" datasource="alibaba">
            select * from MilkRecords
            left join Users
            on Users.Id = MilkRecords.UserId
            left join AnimalTypes
            on AnimalTypes.Id = MilkRecords.MilkTypeId
            order by MilkRecords.Id desc
        </cfquery>
        
        <cfreturn qMilkRecords>
    </cffunction>
    <cffunction name="getMilkRecordsLoop" access="public" returntype="any">
        <cfargument name="qMilkRecords" type="query" required="true">
        <cfloop query="qMilkRecords">
            <cfset createdAt = isDate(qMilkRecords.CreatedAt) ? dateFormat(qMilkRecords.CreatedAt, "mm/dd/yyyy") : " --- ">
            <cfoutput>
                <tr>
                    <td>#qMilkRecords.AnimalTypeName#</td>
                    <td>#DecimalFormat(qMilkRecords.Amount)#</td>                    
                    <td>#createdAt#</td>                    
                    <td>#qMilkRecords.Username#</td>
                    <td>
                        <a class="btn btn-secondary">Düzenle</a>
                        <btn class="btn btn-secondary btn-danger">Sil</btn>
                    </td>                   
                </tr>
            </cfoutput>
        </cfloop>
    </cffunction>
</cfcomponent>
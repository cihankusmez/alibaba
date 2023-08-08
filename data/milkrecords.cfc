<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cffunction name="getMilkRecords" access="public" returntype="query">

        <cfquery name="qMilkRecords" datasource="alibaba">
            select m.Id as MilkRecordId, * from MilkRecords m
            left join Users u
            on u.Id = m.UserId
            left join AnimalTypes t
            on t.Id = m.MilkTypeId
            order by m.Id desc
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
                        <button type="button" data-id="#qMilkRecords.MilkRecordId#" class="btn btn-secondary edit_button m-1">Düzenle</button>
                        <button type="button" data-id="#qMilkRecords.MilkRecordId#" class="btn btn-secondary btn-danger delete_button m-1">Sil</button>
                    </td>                   
                </tr>
            </cfoutput>
        </cfloop>
    </cffunction>
</cfcomponent>
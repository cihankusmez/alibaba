<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cffunction name="getAnimals" access="public" returntype="query">
        <cfargument name="limit" default="1000" type="integer">

        <cfset searchKeyword = structKeyExists(url, "q") ? trim(url.q) : "">

        <cfquery name="qAnimals" datasource="alibaba">
            select TOP #limit# Animals.Id as AnimalId, * from Animals
            left join Users
            on Users.Id = Animals.UserId
            left join AnimalTypes
            on AnimalTypes.Id = Animals.AnimalTypeId
            <cfif len(searchKeyword) GT 0>
                WHERE Animals.EarringId LIKE <cfqueryparam value="%#searchKeyword#%" cfsqltype="CF_SQL_VARCHAR">
            </cfif>
            order by Animals.Id desc
        </cfquery>
        
        <cfreturn qAnimals>
    </cffunction>
    <cffunction name="getAnimalsLoop" access="public" returntype="any">
        <cfargument name="qAnimals" type="query" required="true">
        <cfloop query="qAnimals">
            <cfset nextHealthCheck = isDate(qAnimals.NextHealthCheck) ? dateFormat(qAnimals.NextHealthCheck, "mm/dd/yyyy") : " --- ">
            <cfoutput>
                <tr>
                    <td>#qAnimals.AnimalTypeName#</td>
                    <td>#qAnimals.EarringId#</td>                    
                    <td>#nextHealthCheck#</td>                    
                    <td>#qAnimals.Username#</td>
                    <td>
                        <button type="button" data-id="#qAnimals.AnimalId#" class="btn btn-secondary edit_button m-1">Düzenle</button>
                        <button type="button" data-id="#qAnimals.AnimalId#" class="btn btn-secondary btn-danger delete_button m-1">Sil</button>
                    </td>                   
                </tr>
            </cfoutput>
        </cfloop>
    </cffunction>
</cfcomponent>
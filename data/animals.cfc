<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cffunction name="getAnimals" access="public" returntype="query">

        <cfquery name="qAnimals" datasource="alibaba">
            select Animals.Id as AnimalId, * from Animals
            left join Users
            on Users.Id = Animals.UserId
            left join AnimalTypes
            on AnimalTypes.Id = Animals.AnimalTypeId
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
                        <button type="button" data-id="#qAnimals.AnimalId#" class="btn btn-secondary edit_button">Düzenle</button>
                        <button type="button" data-id="#qAnimals.AnimalId#" class="btn btn-secondary btn-danger delete_button">Sil</button>
                    </td>                   
                </tr>
            </cfoutput>
        </cfloop>
    </cffunction>
</cfcomponent>
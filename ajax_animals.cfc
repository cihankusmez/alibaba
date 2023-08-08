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
                <cfset animalTypeId = trim(parsedData.inputAnimalTypeId)>
                <cfset earringId = trim(parsedData.inputEarringId)>
                <cfset lastHealthCheck = CreateODBCDateTime(parsedData.inputLastHealthCheck)>
                <cfset nextHealthCheck = CreateODBCDateTime(parsedData.inputNextHealthCheck)>
                <cfset createdAt = CreateODBCDateTime( now() )>
                <cfquery datasource="alibaba">
                    INSERT INTO Animals (UserId, AnimalTypeId, EarringId, LastHealthCheck, NextHealthCheck, CreatedAt) 
                    VALUES 
                    (
                        <cfqueryparam value="#userId#" cfsqltype="CF_SQL_INTEGER" >, 
                        <cfqueryparam value="#animalTypeId#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#earringId#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#lastHealthCheck#" cfsqltype="CF_SQL_DATE">,
                        <cfqueryparam value="#nextHealthCheck#" cfsqltype="CF_SQL_DATE">,
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

                <cfset animalsDao = createObject("component", "data/animals")>
                <cfset qAnimals = animalsDao.getAnimals()>
                <cfset qAnimalsLoop = animalsDao.getAnimalsLoop(qAnimals)>

                <cfset result.status = "success">
                <cfset result.message = "Veri başarıyla eklendi.">
                <cfset result.view = qAnimalsLoop>
                
                <cfreturn result>

                <cfcatch type="any">
                    <cfset result.status = "fail">
                    <cfset result.message = "Veri eklenirken hata oluştu.">
                    <cfset result.error = cfcatch.message>
                </cfcatch>
            </cftry>
        </cffunction>
</cfcomponent>






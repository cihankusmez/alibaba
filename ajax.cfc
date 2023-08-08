<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cftry>                
        <cffunction name="saveFormData" access="remote" returnFormat="json">
            <cfargument name="formData" type="string" required="true">

            <cfset parsedData = {}>

            
            <cfloop list="#formData#" index="item" delimiters="&">
                <cfset keyValue = ListToArray(item, "=")>
                <cfset parsedData[keyValue[1]] = keyValue[2] ?: 0>
            </cfloop>

            <cfset userId = trim(parsedData.inputUserId)>
            <cfset milkTypeId = trim(parsedData.inputAnimalTypeId)>
            <cfset amount = trim(parsedData.inputAmount)>

            <cfset createdAt = CreateODBCDateTime( now() )>

            <cfquery datasource="alibaba">
                INSERT INTO MilkRecords (UserId, MilkTypeId, Amount, CreatedAt) 
                VALUES 
                (
                    <cfqueryparam value="#userId#" cfsqltype="CF_SQL_INTEGER" >, 
                    <cfqueryparam value="#milkTypeId#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#amount#" cfsqltype="CF_SQL_DECIMAL" >,
                    <cfqueryparam value="#createdAt#" cfsqltype="CF_SQL_DATE">
                )
            </cfquery>

            <cfset var result = {}>    

            <cfset result.status = "success">
            <cfset result.message = "Veri başarıyla eklendi.">
            <cfset result.formData = parsedData>
            <cfreturn result>
        </cffunction>
        <cfcatch type="any">
            <cfset result.status = "fail">
            <cfset result.message = "Veri eklenirken hata oluştu.">
            <cfset result.error = cfcatch.message>
        </cfcatch>
    </cftry>
</cfcomponent>

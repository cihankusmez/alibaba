<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cffunction name="uploadAnimal" access="remote" returnFormat="json">
        <cftry>


            <cfif structKeyExists(form, "excelFile") and len(form.excelFile)>
                <!--- Destination outside of web root --->
                <cfset dest = getTempDirectory()>
                
                <cffile action="upload" destination="#dest#" filefield="excelFile" result="upload" nameconflict="makeunique">
            
                <cfif upload.fileWasSaved>
                    <cfset theFile = upload.serverDirectory & "/" & upload.serverFile>
                    <cfif isSpreadsheetFile(theFile)>
                        <cfspreadsheet action="read" src="#theFile#" query="excelData" headerrow="1" excludeHeaderRow=true>
                        <cfset result.excelData = excelData>
                    <cfelse>
                        <cfset result.errors = "The file was not an Excel file.">
                    </cfif>
                    <cffile action="delete" file="#theFile#">
                <cfelse>
                    <cfset result.errors = "The file was not properly uploaded.">	
                </cfif>
            </cfif>
           
           <cfif structKeyExists(result, "excelData")>
                <cfset createdAt = CreateODBCDateTime( now() )>
                <cftransaction action="begin">
                    <cftry>
                            <cfquery datasource="alibaba">
                                INSERT INTO Animals (UserId, AnimalTypeId, EarringId, LastHealthCheck, NextHealthCheck, CreatedAt) 
                                VALUES
                                <cfloop query="excelData">
                                    (
                                        <cfqueryparam value="#excelData.UserId#" cfsqltype="CF_SQL_INTEGER">, <!--- userId --->
                                        <cfqueryparam value="#excelData.AnimalTypeId#" cfsqltype="CF_SQL_INTEGER">, <!--- animalTypeId --->
                                        <cfqueryparam value="#excelData.EarringId#" cfsqltype="CF_SQL_INTEGER">, <!--- earringId --->
                                        <cfqueryparam value="#excelData.LastHealthCheck#" cfsqltype="CF_SQL_DATE">,    <!--- lastHealthCheck --->
                                        <cfqueryparam value="#excelData.NextHealthCheck#" cfsqltype="CF_SQL_DATE">,    <!--- nextHealthCheck --->
                                        <cfqueryparam value="#createdAt#" cfsqltype="CF_SQL_DATE">     <!--- createdAt --->
                                    )
                                    <cfif excelData.currentRow neq excelData.recordCount>,</cfif>
                                </cfloop>
                            </cfquery>
                        <cftransaction action="commit">
                            <cfset result.success = "Veri Yüklendi">
                            <cfreturn result>
                        <cfcatch>
                            <!--- Hata durumunda işlemi geri al --->
                            <cftransaction action="rollback">
                            <p>Veritabanına yazma sırasında hata meydana geldi.</p>
                            <cfoutput>#cfcatch.message#</cfoutput>
                        </cfcatch>
                    </cftry>
                </cftransaction>
            </cfif>
        --->
        <cfcatch type="any">
            <cfset result.status = "fail">
            <cfset result.message = "Veri eklenirken hata oluştu.">
            <cfset result.error = cfcatch.message>
        </cfcatch>
    </cftry>
    </cffunction>
</cfcomponent>
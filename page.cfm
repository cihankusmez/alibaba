<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.action" default="home">
<cfset action = url.action>


<div class="container mt-2">      
    <cftry>
        <cfinclude template="pages/#HTMLEditFormat(url.action)#.cfm" />
        <!-- Eğer şablon başarıyla dahil edilirse burası çalışır -->
        <cfcatch type="any" name="e">
            <!-- Şablon dahil etme sırasında hata olursa burası çalışır -->
            <p>Hata Oluştu: <cfoutput>#e.message#</cfoutput></p>
        </cfcatch>
    </cftry>
</div>
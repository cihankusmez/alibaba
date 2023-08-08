<cfprocessingdirective pageencoding="utf-8">

<cfquery name="qAnimals" datasource="alibaba" result="r">
    select * from Animals
    left join Users
    on Users.Id = Animals.UserId
	left join AnimalTypes
    on AnimalTypes.Id = Animals.AnimalTypeId
</cfquery>

<div class="card">
    <div class="card-body">
        <a class="btn btn-secondary">Yeni Hayvan Ekle</a>
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <td>Hayvan Cinsi</td>
                    <td>Küpe No</td>
                    <td>Muayene Tarihi</td>
                    <td>Sorumlu</td>
                    <td>Aksiyon</td>
                </tr>
            </thead>
            <tbody>
                <cfloop query="qAnimals">
                    <cfoutput>
                        <tr>
                            <td>#qAnimals.AnimalTypeName#</td>
                            <td>#qAnimals.EarringId#</td>
                            <td>#qAnimals.NextHealthCheck#</td>                        
                            <td>#qAnimals.Username#</td>
                            <td>
                                <a class="btn btn-secondary">Düzenle</a>
                                <btn class="btn btn-secondary btn-danger">Sil</btn>
                            </td>                   
                        </tr>
                    </cfoutput>
                </cfloop>
            </tbody>
      </table>
    </div>
  </div>
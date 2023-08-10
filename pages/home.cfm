<cfprocessingdirective pageencoding="utf-8">

<cfset animalsDao = createObject("component", "data/animals")>
<cfset qAnimals = animalsDao.getAnimals(3)>

<cfset milk_recordsDao = createObject("component", "data/milkrecords")>
<cfset qMilkRecords = milk_recordsDao.getMilkRecords(3)>

<cfset expensesDao = createObject("component", "data/expenses")>
<cfset qExpenses = expensesDao.getExpenses(3)>

<div class="container text-center">
    <div class="row">
      <div class="col">
            <div class="card">
                <div class="card-header">Hayvanlar</div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped">
                            <thead>
                                <tr>
                                    <td>Cinsi</td>
                                    <td>Küpe No</td>
                                    <td>Muayene Tarihi</td>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput>
                                <cfloop query="qAnimals">                                    
                                    <tr>
                                        <td>#qAnimals.AnimalTypeName#</td>
                                        <td>#qAnimals.EarringId#</td>                    
                                        <td>#nextHealthCheck#</td> 
                                    </tr>
                                </cfloop>
                                </cfoutput>
                            </tbody>
                        </table>
                        <a class="btn btn-secondary" href="/alibaba/?action=animals">Devamı >></a>
                    </div>
                </div>
            </div>
      </div>
      <div class="col">
            <div class="card">
                <div class="card-header">Süt Üretimi</div>
                <div class="card-body">
                    <table class="table table-hover table-striped">
                        <thead>
                            <tr>
                                <td>Cinsi</td>
                                <td>Miktar</td>
                                <td>Tarih</td>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput>
                            <cfloop query="qMilkRecords">                                    
                                <tr>
                                    <td>#qMilkRecords.AnimalTypeName#</td>
                                    <td>#DecimalFormat(qMilkRecords.Amount)#</td>                    
                                    <td>#qMilkRecords.CreatedAt#</td> 
                                </tr>
                            </cfloop>
                            </cfoutput>
                        </tbody>
                    </table>
                    <a class="btn btn-secondary" href="/alibaba/?action=milk_records">Devamı >></a>
                </div>
            </div>
      </div>
      <div class="col">
            <div class="card">
                <div class="card-header">Giderler</div>
                <div class="card-body">
                    <table class="table table-hover table-striped">
                        <thead>
                            <tr>
                                <td>Cinsi</td>
                                <td>Miktar</td>
                                <td>Tarih</td>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput>
                            <cfloop query="qExpenses">                                    
                                <tr>
                                    <td>#qExpenses.CreatedAt#</td>                 
                                    <td>#qExpenses.ExpenseDescription#</td> 
                                    <td>#DecimalFormat(qExpenses.Amount)#</td>   
                                </tr>
                            </cfloop>
                            </cfoutput>
                        </tbody>
                    </table>
                    <a class="btn btn-secondary" href="/alibaba/?action=expenses">Devamı >></a>
                </div>
            </div>
      </div>
    </div>
  </div>

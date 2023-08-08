<cfprocessingdirective pageencoding="utf-8">

<cfquery name="qExpenses" datasource="alibaba" result="r">
    select * from Expenses
    left join Users
    on Users.Id = Expenses.UserId
</cfquery>

<div class="card">
    <div class="card-body">
        <a class="btn btn-secondary">Yeni Gider Ekle</a>
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <td>Harcama Kalemi</td>
                    <td>Toplam Tutar</td>
                    <td>Sorumlu</td>
                    <td>Aksiyon</td>
                </tr>
            </thead>
            <tbody>
                <cfloop query="qExpenses">
                    <cfoutput>
                        <tr>
                            <td>#qExpenses.ExpenseDescription#</td>
                            <td>#DecimalFormat(qExpenses.Amount)#</td>                    
                            <td>#qExpenses.Username#</td>
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
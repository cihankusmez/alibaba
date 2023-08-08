<cfprocessingdirective pageencoding="utf-8">

<cfset expensesDao = createObject("component", "data/expenses")>
<cfset qExpenses = expensesDao.getExpenses()>

<cfquery name="qUsers" datasource="alibaba" result="r">
    select * from Users
</cfquery>

<div class="card">
    <div class="card-body">
        <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#newExpensesModal">Yeni Gider Ekle</button>
        <form id="expenses_table">
          <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <td>Tarih</td>
                        <td>Harcama Kalemi</td>
                        <td>Toplam Tutar</td>
                        <td>Sorumlu</td>
                        <td>Aksiyon</td>
                    </tr>
                </thead>
                <tbody>
                    <cfset qExpensesLoop = expensesDao.getExpensesLoop(qExpenses)>
                </tbody>
            </table>
          </div>
        </form>
    </div>
  </div>

  <!-- Modal -->
<div class="modal fade" id="newExpensesModal" tabindex="-1" aria-labelledby="newExpensesModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="newExpensesModalLabel">Yeni Gider Kaydı</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form id="expenses_form">
                <div class="row mb-3">
                    <label for="inputUserId" class="col-sm-3 col-form-label">Sorumlu</label>
                    <div class="col-sm-9">
                      <select class="form-select" id="inputUserId" name="inputUserId">
                            <option value="0">--- Sorumlu Seçiniz ---</option>
                        <cfloop query="qUsers">
                            <cfoutput>
                                <option value="#qUsers.Id#">#qUsers.Username#</option>
                            </cfoutput>
                        </cfloop>
                      </select>
                    </div>
                  </div>
                <div class="row mb-3">
                <label for="inputExpenseDescription" class="col-sm-3 col-form-label">Harcama Açıklama</label>
                <div class="col-sm-9">
                    <textarea class="form-control" id="inputExpenseDescription" name="inputExpenseDescription"></textarea>
                </div>
                </div>
                <div class="row mb-3">
                  <label for="inputAmount" class="col-sm-3 col-form-label">Harcama Tutarı</label>
                  <div class="col-sm-9">
                    <input type="number" min="0" step="0.01" class="form-control" id="inputAmount" name="inputAmount" />
                  </div>
                </div>
            </form>
        </div>
        <div class="modal-footer">
          <div id="response">
            <!-- To be populated dynamically. -->
          </div>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kapat</button>
          <button id="create_expenses_button" type="button" class="btn btn-primary">Kaydet</button>
        </div>
      </div>
    </div>
  </div>



  <script>
    $("body").on('click', '#create_expenses_button',function(event) {
        var formData = $('#expenses_form').serialize();
        //console.log(formData);
        $.ajax({
            type: "POST",
            url: "./ajax_expenses.cfc?method=saveFormData",
            data: { formData : formData },
            success: function(response) {
                console.log(response);
              var r = JSON.parse(response);     
                if(r['STATUS'] == "success")
                {
                  var myModal = document.getElementById('newExpensesModal');
                  var modal = bootstrap.Modal.getOrCreateInstance(myModal);

                  modal.hide();

                  $.ajax({
                    type: "GET",
                    url: "./ajax_expenses.cfc?method=getFormData",
                    success: function(response) {
                      console.log(response)
                      $("tbody").html(response);
                    },
                    error: function(xhr, status, error) {
                      console.log(xhr);  
                      console.log(status);  
                      console.log(error);  
                      $('#response').html(xhr.responseText);
                    }
                  });

                } else {
                  console.log("error");
                  console.log(response);
                }
            },
            error: function(xhr, status, error) {
              console.log(xhr);  
              console.log(status);  
              console.log(error);  
              $('#response').html(xhr.responseText);
            }
        });
    });

    $('#expenses_table').on('click', '.delete_button', function() {
      var delete_id = $(this).data('id');
      //console.log(delete_id);

      $.ajax({
            type: "POST",
            url: "./ajax_expenses.cfc?method=deleteData",
            data: { delete_id : delete_id },
            success: function(response) {
              console.log(response);
               var r = JSON.parse(response);
               console.log(r);     
                if(r['STATUS'] == "success")
                {
                  $.ajax({
                    type: "GET",
                    url: "./ajax_expenses.cfc?method=getFormData",
                    success: function(response) {
                      console.log(response)
                      $("tbody").html(response);
                    },
                    error: function(xhr, status, error) {
                      console.log(xhr);  
                      console.log(status);  
                      console.log(error);  
                      $('#response').html(xhr.responseText);
                    }
                  });

                } else {
                  console.log("error");
                  console.log(response);
                }
            },
            error: function(xhr, status, error) {
              console.log(xhr);  
              console.log(status);  
              console.log(error);  
              $('#response').html(xhr.responseText);
            }
        });
    });
</script>
<cfprocessingdirective pageencoding="utf-8">

<cfset milkRecordsDao = createObject("component", "data/milkrecords")>
<cfset qMilkRecords = milkRecordsDao.getMilkRecords()>

<cfquery name="qAnimalTypes" datasource="alibaba" result="r">
    select * from AnimalTypes
    where AnimalTypeName IN ('İnek', 'Keçi', 'Koyun')
</cfquery>

<cfquery name="qUsers" datasource="alibaba" result="r">
    select * from Users
</cfquery>

<div class="card">
    <div class="card-body">
        <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#newMilkRecordsModal">
            Yeni Süt Üretimi Ekle
          </button>
          <form id="milk_records_table">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <td>Sütün Cinsi</td>
                        <td>Toplam Miktar</td>
                        <td>Tarih</td>
                        <td>Sorumlu</td>
                        <td>Aksiyon</td>
                    </tr>
                </thead>
                <tbody>
                  <cfset qMilkRecordsLoop = milkRecordsDao.getMilkRecordsLoop(qMilkRecords)>
                </tbody>
          </table>
        </form>
    </div>
  </div>

  <!-- Modal -->
  <div class="modal fade" id="newMilkRecordsModal" tabindex="-1" aria-labelledby="newMilkRecordsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="newMilkRecordsModalLabel">Yeni Süt Üretimi Kaydı</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form id="milk_form">
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
                  <label for="inputAnimalTypeId" class="col-sm-3 col-form-label">Sütün Cinsi</label>
                  <div class="col-sm-9">
                    <select class="form-select" id="inputAnimalTypeId" name="inputAnimalTypeId">
                        <option value="0">--- Süt Cinsi Seçiniz ---</option>
                        <cfloop query="qAnimalTypes">
                            <cfoutput>
                                <option value="#qAnimalTypes.Id#">#qAnimalTypes.AnimalTypeName#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="inputAmount" class="col-sm-3 col-form-label">Miktar</label>
                  <div class="col-sm-9">
                    <div class="input-group mb-3">
                        <input type="number" min="0" step="0.01" class="form-control" id="inputAmount" name="inputAmount" />
                        <span class="input-group-text" id="inputAmount">lt.</span>
                      </div>
                  </div>
                </div>
            </form>
        </div>
        <div class="modal-footer">
          <div id="response">
            <!-- To be populated dynamically. -->
          </div>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kapat</button>
          <button id="create_milk_records_button" type="button" class="btn btn-primary">Kaydet</button>
        </div>
      </div>
    </div>
  </div>

  <script type="text/javascript">
    $('body').on('click', '#create_milk_records_button',function(event) {
        var formData = $('#milk_form').serialize();
        
        $.ajax({
            type: "POST",
            url: "./ajax_milk.cfc?method=saveFormData",
            data: { formData : formData },
            success: function(response) {
              var r = JSON.parse(response);     
                if(r['STATUS'] == "success")
                {
                  var myModal = document.getElementById('newMilkRecordsModal');
                  var modal = bootstrap.Modal.getOrCreateInstance(myModal);

                  modal.hide();

                  $.ajax({
                    type: "GET",
                    url: "./ajax_milk.cfc?method=getFormData",
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
    
    $('#milk_records_table').on('click', '.delete_button', function() {
      var delete_id = $(this).data('id');
      //console.log(delete_id);

      $.ajax({
            type: "POST",
            url: "./ajax_milk.cfc?method=deleteData",
            data: { delete_id : delete_id },
            success: function(response) {
              console.log(response);
               var r = JSON.parse(response);
               console.log(r);     
                if(r['STATUS'] == "success")
                {
                  $.ajax({
                    type: "GET",
                    url: "./ajax_milk.cfc?method=getFormData",
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
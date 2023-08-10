<cfprocessingdirective pageencoding="utf-8">

<cfset animalsDao = createObject("component", "data/animals")>
<cfset qAnimals = animalsDao.getAnimals()>

<cfquery name="qAnimalTypes" datasource="alibaba" result="r">
    select * from AnimalTypes
</cfquery>

<cfquery name="qUsers" datasource="alibaba" result="r">
    select * from Users
</cfquery>

<div class="card">
    <div class="card-body">
        <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#newAnimalsModal">Yeni Hayvan Ekle</button>
        <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#newBulkAnimalsModal">Toplu Excel Yükleme</button>

        <form id="animals_table">
          <div class="table-responsive">
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
                    <cfset qAnimalsLoop = animalsDao.getAnimalsLoop(qAnimals)>
                </tbody>
            </table>
          </div>
      </form>
    </div>
  </div>
  
  <div class="modal fade" id="newBulkAnimalsModal" tabindex="-1" aria-labelledby="newBulkAnimalsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="newBulkAnimalsModalLabel">Toplu Hayvan Yükle</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form id="uploadForm" enctype="multipart/form-data" class="mb-2">
            <div class="input-group mb-3">
              <input id="file" type="file" name="excelFile" class="form-control" id="excelFile" accept=".xls, .xlsx" required>
              <div class="input-group-append">
                <button type="submit" class="btn btn-outline-secondary">Yükle</button>
              </div>
            </div>  
          </form>
          <div id="loading" style="display: none;">
              <img src="loading.gif" alt="Yükleniyor..."> Yükleniyor...
          </div>          
          <div id="excel_response"></div>
        </div>
      </div>
    </div>
  </div>

   <!-- Modal -->
<div class="modal fade" id="newAnimalsModal" tabindex="-1" aria-labelledby="newAnimalsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="newAnimalsModalLabel">Yeni Hayvan Ekle</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <form id="animal_form">
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
                  <label for="inputAnimalTypeId" class="col-sm-3 col-form-label">Hayvan Cinsi</label>
                  <div class="col-sm-9">
                    <select class="form-select" id="inputAnimalTypeId" name="inputAnimalTypeId">
                        <option value="0">--- Hayvan Cinsi Seçiniz ---</option>
                        <cfloop query="qAnimalTypes">
                            <cfoutput>
                                <option value="#qAnimalTypes.Id#">#qAnimalTypes.AnimalTypeName#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                  </div>
                </div>
                <div class="row mb-3">
                  <label for="inputEarringId" class="col-sm-3 col-form-label">Küpe No</label>
                  <div class="col-sm-9">
                    <input type="number" min="0" step="1" class="form-control" id="inputEarringId" name="inputEarringId" />
                  </div>
                </div>
                <div class="row mb-3">
                    <label for="inputLastHealthCheck" class="col-sm-3 col-form-label">Son Muayene</label>
                    <div class="col-sm-9">
                      <input type="date" class="form-control" id="inputLastHealthCheck" name="inputLastHealthCheck" />
                    </div>
                  </div>
                  <div class="row mb-3">
                    <label for="inputNextHealthCheck" class="col-sm-3 col-form-label">Sonraki Muayene</label>
                    <div class="col-sm-9">
                      <input type="date" class="form-control" id="inputNextHealthCheck" name="inputNextHealthCheck" />
                    </div>
                  </div>
            </form>
        </div>
        <div class="modal-footer">
          <div id="response">
            <!-- To be populated dynamically. -->
          </div>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kapat</button>
          <button id="create_animals_button" type="button" class="btn btn-primary">Kaydet</button>
        </div>
      </div>
    </div>
  </div>

  <script>
      $(document).ready(function() {
          $("#uploadForm").submit(function(e) {
              $("#loading").show();
              e.preventDefault();
              var form = new FormData(this);
              $.ajax({
                  url: "./ajax_excel_upload.cfc?method=uploadAnimal",
                  type: "POST",
                  data: form,
                  processData: false,
                  contentType: false,
                  success: function(response) {
                      $("#excel_response").html(response);
                  },
                  error: function(jqXHR, textStatus, errorThrown) {
                      console.log(jqXHR);
                      $("#excel_response").html(jqXHR.responseText);
                      console.log("Hata: " + errorThrown);
                  },
                  complete: function() {
                      $("#loading").hide();
                  }
              });
          });
      });

    $("body").on('click', '#create_animals_button',function(event) {
        var formData = $('#animal_form').serialize();
        //console.log(formData);
        $.ajax({
            type: "POST",
            url: "./ajax_animals.cfc?method=saveFormData",
            data: { formData : formData },
            success: function(response) {
                console.log(response);
              var r = JSON.parse(response);     
                if(r['STATUS'] == "success")
                {
                  var myModal = document.getElementById('newAnimalsModal');
                  var modal = bootstrap.Modal.getOrCreateInstance(myModal);

                  modal.hide();

                  $.ajax({
                    type: "GET",
                    url: "./ajax_animals.cfc?method=getFormData",
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

    $('#animals_table').on('click', '.delete_button', function() {
      var delete_id = $(this).data('id');
      //console.log(delete_id);

      $.ajax({
            type: "POST",
            url: "./ajax_animals.cfc?method=deleteData",
            data: { delete_id : delete_id },
            success: function(response) {
              console.log(response);
               var r = JSON.parse(response);
               console.log(r);     
                if(r['STATUS'] == "success")
                {
                  $.ajax({
                    type: "GET",
                    url: "./ajax_animals.cfc?method=getFormData",
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
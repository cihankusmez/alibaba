<cfprocessingdirective pageencoding="utf-8">
<cfset searchKeyword = structKeyExists(url, "q") ? trim(url.q) : "">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <a class="navbar-brand" href="/alibaba/">FarmerApp</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" aria-current="page" href="/alibaba/">Ana Sayfa</a>
          </li>          
          <li class="nav-item">
            <a class="nav-link" href="/alibaba/?action=animals">Hayvanlar</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/alibaba/?action=milk_records">Süt Üretimi</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/alibaba/?action=expenses">Giderler</a>
          </li>
        </ul>
        <form method="GET" class="d-flex" action="/alibaba/?action=animals">
          <input type="hidden" name="action" value="animals">
          <input class="form-control me-2" type="search" name="q" placeholder="Hayvan Küpe No Giriniz" aria-label="Search" value="<cfoutput>#searchKeyword#</cfoutput>">
          <button class="btn btn-outline-success" type="submit">Ara</button>
        </form>
      </div>
    </div>
  </nav>
component {

    this.name = "myApplication";
    this.applicationTimeout = CreateTimeSpan(0, 0, 0, 10);
    this.datasource = "my_datasource";
    this.sessionmanagement = true;

    // see also: http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WSc3ff6d0ea77859461172e0811cbec22c24-750b.htmlhttps://helpx.adobe.com/coldfusion/cfml-reference/application-cfc-reference/application-variables.html
    // see also: https://helpx.adobe.com/coldfusion/developing-applications/developing-cfml-applications/designing-and-optimizing-a-coldfusion-application.html

    function onApplicationStart() {
        return true;
    }

    function onSessionStart() {}

    // the target page is passed in for reference,
    // but you are not required to include it
    function onRequestStart( string targetPage ) {}

    function onRequest( string targetPage ) {
        include arguments.targetPage;
    }

    function onRequestEnd() {}

    function onSessionEnd( struct SessionScope, struct ApplicationScope ) {}

    function onApplicationEnd( struct ApplicationScope ) {
        ApplicationScope.applicationTimeout = CreateTimeSpan(0, 0, 0, 10);
    }

    // function onError( any Exception, string EventName ) {}

}

<cfcomponent extends="mura.cfobject" output="false" hint="This provides user CRUD functionality">


    <cfscript>
        function getJsonBody() {
            var json = ToString(GetHttpRequestData().content);
            if (!isJSON(json)) {
                throw (message = "Invalid JSON string", type = "ArgumentException", errorCode = "400")
            }
            return json;
        }
        function urlSafeBase64Encode(str) {
            return createObject("java", "java.util.Base64").getUrlEncoder().withoutPadding().encodeToString(str.getBytes("UTF-8"));
        }
        function urlSafeBase64Decode(str) {
            var bytes = createObject("java", "java.util.Base64").getUrlDecoder().decode(str);
            return createObject("java", "java.lang.String").init(bytes);
        }
        function urlSafeBase64ToBytes(str) {
            var bytes = createObject("java", "java.util.Base64").getUrlDecoder().decode(str);
            return bytes;
        }
    </cfscript>


    <cffunction name="registerCredentialsStep1" output="false">
        <cfset var challenge = '{
            "rp": {
                "id": "http://localhost:8080/",
                "name": "startRegistration"
            },
            "user": {
                "id": "MTc=",
                "name": "jd",
                "displayName": "John Doe"
            },
            "challenge": {
                "value": "MDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWY="
            },
            "pubKeyCredParams": [],
            "timeout": 60000,
            "excludeCredentials": [],
            "authenticatorSelection": null,
            "attestation": "direct",
            "extensions": null
        }' >


        <cfcontent type="application/json" reset="true" /><cfoutput>#challenge#</cfoutput>
        <cfabort>
    </cffunction>


<%@ page import = "com.crystaldecisions.sdk.framework.*"%>
<%@ page import = "com.crystaldecisions.sdk.exception.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.infostore.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.security.*"%>
<%@ page import = "com.crystaldecisions.sdk.occa.pluginmgr.*"%>
<%@ page import = "com.crystaldecisions.sdk.plugin.desktop.user.*"%>
<%@ page import = "com.crystaldecisions.sdk.plugin.desktop.common.*"%>
<%@ page import = "java.util.*"%>



<html>
<head>
<title>List User Aliases</title>
</head>
<body>

<%
	// Set the logon information
    String boUser = "Administrator";
    String boPassword = "Flexrep@dm1n!";
    String boCmsName = "localhost";
    String boAuthType = "secEnterprise";
    
    // Set some values
    int max_id = 0;

	// Declare Variables
    IInfoStore boInfoStore=null;
	IInfoObjects boInfoObjects=null;
	IInfoObject boInfoObject=null;
	SDKException failure = null;
	IEnterpriseSession boEnterpriseSession = null;
	
    
   try{
   	    // Logon and obtain an Enterprise Session
    	boEnterpriseSession = CrystalEnterprise.getSessionMgr().logon( boUser, boPassword, boCmsName, boAuthType);
		boInfoStore = (IInfoStore) boEnterpriseSession.getService("", "InfoStore");
    	
   		
    	// Loop through all users
    	for(;;) { 
        boInfoObjects = (IInfoObjects)boInfoStore.query("SELECT TOP 500 SI_ID, SI_NAME FROM CI_SYSTEMOBJECTS WHERE SI_KIND = 'User' And SI_ID > " + max_id +  " ORDER BY SI_ID ASC");
                                               
        if(boInfoObjects.size() == 0) 
            break;

	        for(Iterator boUsers = boInfoObjects.iterator(); boUsers.hasNext() ; ) {
	            IUser boUserAccount;
	
	            boUserAccount = (IUser) boUsers.next();
	            out.println(boUserAccount.getTitle() + " (" + boUserAccount.getID() + ")<BR>");
	            max_id = boUserAccount.getID();
	        }
        }
    }    	
    catch(SDKException e)
    {
        out.println(e.getMessage());
    }
    finally
    {
	    boEnterpriseSession.logoff();
    }
%>

</body>
</html>
